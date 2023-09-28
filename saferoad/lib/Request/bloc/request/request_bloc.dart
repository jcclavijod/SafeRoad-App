// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saferoad/Auth/model/usuario_model.dart';


import '../../Repository/requestRepository.dart';
import '../../model/Request.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final _requestRepository = RequestRepository();
  late StreamSubscription<DocumentSnapshot> _requestSubscription;

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
  }

  Future<void> createRequest(puntosCercanos) async {
    String requestId =
        await _requestRepository.createRequest(state.problemController.text);
    Request request =
        await _requestRepository.getRequestNotification(requestId);
    add(FirstRequestLoaded(request));
    puntosCercanos.forEach((DocumentSnapshot punto) {
      if (punto.data() != null) {
        // Verifica si el DocumentSnapshot contiene datos
        var token = punto.get("token");
        var nombre = punto.get("email");
        if (token != null) {
          print("Token: $token");
          print("Nombre: $nombre");
          _requestRepository.sendNotificationToDriver(
              token, requestId, request.requestDetails);
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

  void listenRequestChanges() async {
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

  void loadListRequest() async {
    add(FinishedRequestsLoaded(await _requestRepository.getFinishedRequests()));
  }

  void loadMechanic() async {
    final location = await _requestRepository.locationMechanic();
    add(LoadLocation2(location));
  }

  void loadRequestData() async {
    final authenticatedUser = await _requestRepository.getUser();
    final receiver = await _requestRepository.getClient(state.request);
    final location = await _requestRepository.locationUser(state.request);
    //final request = await _requestRepository.getRequest(state.request);
    print("MOSTRANDO LOS DATOS QUE SE ESTAN ENVIANDO AL MAPA HIJO PUTA");
    print(authenticatedUser.uid);
    print(receiver.uid);
    print(location);
    //print(request);
    add(LoadRequestData(
        authenticatedUser, receiver, location, state.address, state.request));
    print("SE ESTAN ENVIANDO LOS DATOS AL MAP FINAL");
  }

  void changeRequest() async {
    await _requestRepository.updateRequestStatus('inProcess');
  }

  void loadRequest(Request request) async {
    add(FirstRequestLoaded(request));
  }

  void changeRequestMessaging() async {
    await _requestRepository.updateRequestStatusMessaging(
        'inProcess', state.request.id!);
  }
}
