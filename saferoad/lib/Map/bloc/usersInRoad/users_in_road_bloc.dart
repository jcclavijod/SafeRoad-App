import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saferoad/Auth/model/usuario_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Request/model/Request.dart';
import '../../../helpers/notificationHelper.dart';
import '../../Repository/mapRepository.dart';
import '../../repository/SearchRepository.dart';

part 'users_in_road_event.dart';
part 'users_in_road_state.dart';

class UsersInRoadBloc extends Bloc<UsersInRoadEvent, UsersInRoadState> {
  UsersInRoadBloc() : super(const UsersInRoadState()) {
    on<OnLocations>((event, emit) => emit(
        state.copyWith(location: event.location, location2: event.location2)));
    on<SaveIcons>((event, emit) =>
        emit(state.copyWith(icon: event.icon, icon2: event.icon2)));
    on<SaveTypeUser>(
        (event, emit) => emit(state.copyWith(userType: event.userType)));
    on<SaveUsers>((event, emit) => emit(state.copyWith(
        authenticatedUser: event.authenticatedUser, receiver: event.receiver)));
  }

  MapRepository mapRepository = MapRepository();

  final SearchRepository searchRepository = SearchRepository(
    geo: GeoFlutterFire(),
    firestore: FirebaseFirestore.instance,
    user: FirebaseAuth.instance.currentUser,
  );

  NotificationHelper notification = NotificationHelper();
  late StreamSubscription<LatLng> _locationSubscription;

  void locations(LatLng position, LatLng position2) {
    add(OnLocations(position, position2));
  }

  void typeUser() async {
    String type = await searchRepository.getTypeUser();
    add(SaveTypeUser(type));
  }

  void changeIcon() async {
    BitmapDescriptor icon1 =
        await mapRepository.getMarkerIcon("assets/iconoMecanico.png", 150);
    BitmapDescriptor icon2 =
        await mapRepository.getMarkerIcon("assets/marcador.png", 208);
    if (state.userType == "mecanico") {
      add(SaveIcons(icon1, icon2));
    } else {
      add(SaveIcons(icon2, icon1));
    }
  }

  void locationMechanic(Request? request) {
    if (state.userType == "usuario") {
      _locationSubscription = searchRepository
          .watchMechanicLocationChanges(request, state.location)
          .listen((location) {
        add(OnLocations(location, state.location2));
      });
    }
  }

  void newLocationMechanic(Request? request) async {
    if (state.userType == "mecanico") {
      searchRepository.updateRequestMechanicLocation(request, state.location2);
    }
  }

  void openPhoneApp(String url) async {
    final uri = Uri(scheme: 'tel', path: url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri); 
    } else {
      print('No se pudo abrir la aplicación de teléfono');
    }
  }

  void saveUsers(UserModel authenticatedUser, UserModel receiver) {
    add(SaveUsers(authenticatedUser, receiver));
  }

  void cancelRequest(String? requestId) async {
    Map notificationMap = {
      'body': "Se ha cancelado la solicitud de viaje",
      'title': "Solicitud cancelada",
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'request_id': requestId,
      'type': "cancelRequest",
    };
    notification.sendNotificationToDriver(
        state.receiver.token, notificationMap, dataMap);
    searchRepository.changeStatusRequest(requestId!, "canceled");
  }

  void finishRequest(final String? requestId, String? mechanicPic,
      String? mechanicLocal) async {
    Map notificationMap = {
      'body': "El viaje de atención mecánica ha finalizado",
      'title': "Solicitud Finalizada",
    };
    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'request_id': requestId,
      'type': "finishedRequest",
      'mechanicUid': state.authenticatedUser.uid,
      'mechanicPic': state.authenticatedUser.profilePic,
      'mechanicLocal': state.authenticatedUser.name,
    };
    notification.sendNotificationToDriver(
        state.receiver.token, notificationMap, dataMap);
    searchRepository.changeStatusRequest(requestId!, "finished");
  }

  void change(final String? requestId) {
    searchRepository.changeStatusRequest(requestId!, "inBilling");
  }

  @override
  Future<void> close() {
    if (!_locationSubscription.isPaused) {
      _locationSubscription.cancel();
    }
    return super.close();
  }
}
