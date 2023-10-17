// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saferoad/Auth/model/usuario_model.dart';
import 'package:saferoad/helpers/notificationHelper.dart';
import 'package:rxdart/rxdart.dart';
import '../../Repository/requestRepository.dart';
import '../../model/Request.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final _requestRepository = RequestRepository(
    firestoreBd: FirebaseFirestore.instance,
    user: FirebaseAuth.instance.currentUser,
  );
  late StreamSubscription _requestSubscription;
  final BehaviorSubject<List<Request>> requestsSubject =
      BehaviorSubject<List<Request>>();

  NotificationHelper notification = NotificationHelper();
  final _requestUpdatesController = StreamController<Request>();
  Stream<Request> get requestUpdatesStream => _requestUpdatesController.stream;

  StreamSubscription<List<Request>>? subscription;

  RequestBloc()
      : super(RequestState(problemController: TextEditingController())) {
    on<CreateRequest>((event, emit) =>
        emit(state.copyWith(requestCreated: event.requestCreated)));
    on<FinishedRequestsLoaded>((event, emit) =>
        emit(state.copyWith(finishedRequests: event.finishedRequests)));
    on<LoadRequestData>((event, emit) => emit(state.copyWith(
        authenticatedUser: event.authenticatedUser,
        receiver: event.receiver,
        location: event.location,
        address: event.address,
        request: event.request)));
    on<LoadLocation2>(
        (event, emit) => emit(state.copyWith(location2: event.location2)));
    on<FirstRequestLoaded>(
        (event, emit) => emit(state.copyWith(request: event.request)));

    on<ProblemTextChangedEvent>((event, emit) =>
        emit(state.copyWith(problemController: event.problemController)));

    on<LoadSpanishStatus>((event, emit) =>
        emit(state.copyWith(spanishStatus: event.spanishStatus)));
  }

  Future<void> createRequest(puntosCercanos) async {
    int count = 0;
    String requestId =
        await _requestRepository.createRequest(state.problemController.text);
    Request request =
        await _requestRepository.getRequestNotification(requestId);
    add(FirstRequestLoaded(request));
    puntosCercanos.forEach((DocumentSnapshot punto) {
      if (punto.data() != null) {
        // Verifica si el DocumentSnapshot contiene datos
        count += 1;
        print("////////////////////////////////////////////////");
        var token = punto.get("token");
        var nombre = punto.get("mail");
        if (token != null) {
          print("Token: $token");
          print("Nombre: $nombre");
          print(request.userAddress);
          print("CANTIDAD DE VECES QUE SE ENVIA EL MENSAJE: $count");
          _requestRepository.sendNotificationToDriver(
              token, requestId, request.requestDetails, request.userAddress);
          print("////////////////////////////////////////////////");
        } else {
          print("El campo 'token' no existe en este DocumentSnapshot.");
        }
      } else {
        print("El DocumentSnapshot no contiene datos.");
      }
    });

    final request2 = true;
    print("!DESDE EL BLOC!, YA SE CREO LA REQUEST???????????");
    print(request2);
    add(CreateRequest(request2));
  }

  Future<void> listenRequestChanges() async {
    DocumentReference request =
        await _requestRepository.getRequest(state.request);
    print("***************VERIFICANDO REQUEST PARA EL LISTENER**********");
    _requestSubscription = request.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> requestData =
            (snapshot.data() as Map<String, dynamic>);
        print(requestData['userId']);
        print(requestData['mechanicId']);
        Request listenReq = Request.fromMap(requestData);

        print("VERIFICANDO LOS NUEVOS DATOS DEL MECANICO :: *LISTENER*");
        print(listenReq.mechanicId);
        add(FirstRequestLoaded(listenReq));
      }
    });
  }

  void loadListRequest(String type) async {
    //
    if (type == "user") {
      _requestSubscription =
          _requestRepository.getUserRequests().listen((requests) {
        // Actualizar el stream de solicitudess
        final updatedRequests = requests.where((request) {
          // Compara la marca de tiempo de lastUpdated con la marca de tiempo anterior
          return !requestsSubject.hasValue ||
              !requestsSubject.value.contains(request);
        }).toList();

        // Actualizar el stream de solicitudes solo si hay cambios
        if (updatedRequests.isNotEmpty) {
          requestsSubject.add(requests);
        }
      });
      add(FinishedRequestsLoaded(_requestRepository.getUserRequests()));
    } else {
      add(FinishedRequestsLoaded(_requestRepository.getMechanicRequests()));
    }

    createSubscription();
  }

  void createSubscription() {
    subscription = state.finishedRequests.listen((event) {});
  }

  void cancelSubscription() {
    subscription!.cancel();
  }

  Future<void> loadMechanic() async {
    final location = await _requestRepository.locationMechanic(state.request);
    add(LoadLocation2(location));
  }

  Future<void> loadRequestData() async {
    print("=======================");
    print(state.request.id);
    final authenticatedUser = await _requestRepository.getUser(state.request);
    final receiver = await _requestRepository.getClient(state.request);
    final location = await _requestRepository.locationUser(state.request);
    //final request = await _requestRepository.getRequest(state.request);
    /*
    print("MOSTRANDO LOS DATOS QUE SE ESTAN ENVIANDO AL MAPA HIJO PUTA");
    print(authenticatedUser.uid);
    print(receiver.uid);
    print(location);
    //print(request);
    */
    emit(state.copyWith(
        authenticatedUser: authenticatedUser,
        receiver: receiver,
        location: location,
        request: state.request));
    add(LoadRequestData(
        authenticatedUser, receiver, location, state.address, state.request));
    print("SE ESTAN ENVIANDO LOS DATOS AL MAP FINAL");
  }

  void changeRequest() async {
    await _requestRepository.updateRequestStatus('inProcess');
  }

  Future<void> loadRequestInitial(Request requestUnic) async {
    add(FirstRequestLoaded(requestUnic));
  }

  Future<void> loadRequest(Request requestUnic) async {
    final authenticatedUser = await _requestRepository.getUser(requestUnic);
    final receiver = await _requestRepository.getClient(requestUnic);
    final location = await _requestRepository.locationUser(requestUnic);
    /*
    print("camilo hijo puta:");
    print(requestUnic.id);
    print("authenticatedUser hijo puta:");
    print(authenticatedUser.uid);
    print("receiver hijo puta:");
    print(receiver.uid);
    print("location hijo puta $location");
    */

    emit(state.copyWith(
        authenticatedUser: authenticatedUser,
        receiver: receiver,
        location: location));
  }

  void changeRequestCreated() async {
    emit(state.copyWith(requestCreated: true));
  }

  void changeRequestMessaging() async {
    await _requestRepository.updateRequestStatusMessaging(
        'inProcess', state.request.id!);
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
  }
}
