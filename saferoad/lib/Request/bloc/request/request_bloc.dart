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
        address: event.address)));
  }

  Future<void> createRequest() async {
    add(CreateRequest(await _requestRepository.createRequest()));
  }

  void loadListRequest() async {
    add(FinishedRequestsLoaded(await _requestRepository.getFinishedRequests()));
  }

  void loadRequestData() async {
    //final address = await _requestRepository.getAddressFromCoordinates();
    final authenticatedUser = await _requestRepository.getUserAuthMech();
    final receiver = await _requestRepository.getClient();
    final location = await _requestRepository.locationUser();
    add(LoadRequestData(authenticatedUser, receiver, location, state.address));
    print("SE ESTAN ENVIANDO LOS DATOS AL MAP FINAL");
  }

  
}
