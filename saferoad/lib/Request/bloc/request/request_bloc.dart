// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saferoad/Auth/model/user_model.dart';

import '../../Repository/requestRepository.dart';
import '../../model/Request.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final _requestRepository = RequestRepository();

  RequestBloc() : super(const RequestState()) {
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
  }

  Future<void> createRequest() async {
    final request = await _requestRepository.createRequest();
    print("!DESDE EL BLOC!, YA SE CREO LA REQUEST???????????");
    print(request);
    add(CreateRequest(request));
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
    final receiver = await _requestRepository.getClient();
    final location = await _requestRepository.locationUser();
    final request = await _requestRepository.getRequest();
    print("MOSTRANDO LOS DATOS QUE SE ESTAN ENVIANDO AL MAPA HIJO PUTA");
    print(authenticatedUser);
    print(receiver);
    print(location);
    print(request);
    add(LoadRequestData(
        authenticatedUser, receiver, location, state.address, request));
    print("SE ESTAN ENVIANDO LOS DATOS AL MAP FINAL");
  }

  void changeRequest() async {
    await _requestRepository.updateRequestStatus('inProcess');
  }
}
