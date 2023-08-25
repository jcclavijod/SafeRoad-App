import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Request/model/Request.dart';
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
  }

  MapRepository mapRepository = MapRepository();
  SearchRepository searchRepository = SearchRepository();
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
    print(
        "----------- VERIFICANDOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO 2222-------------");
    print(state.location);
  }

  void newLocationMechanic(Request? request) async {
    if (state.userType == "mecanico") {
      searchRepository.updateRequestMechanicLocation(request, state.location2);
    }
  }

  void openPhoneApp(String url) async {
    final uri  = Uri(scheme: 'tel', path: url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri); // Abre la aplicación de teléfono
    } else {
      // No se pudo abrir la aplicación de teléfono, maneja este caso aquí
      print('No se pudo abrir la aplicación de teléfono');
    }
  }

  @override
  Future<void> close() {
    _locationSubscription.cancel();
    return super.close();
  }
}
