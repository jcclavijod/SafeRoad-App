import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../Repository/requestRepository.dart';
import '../../model/Request.dart';

part 'mechanical_request_event.dart';
part 'mechanical_request_state.dart';

class MechanicalRequestBloc
    extends Bloc<MechanicalRequestEvent, MechanicalRequestState> {
  final _requestRepository = RequestRepository();

  MechanicalRequestBloc() : super(const MechanicalRequestState()) {
    on<CreateRequest>((event, emit) =>
        emit(state.copyWith(requestCreated: event.requestCreated)));
    on<FinishedRequestsLoaded>((event, emit) =>
        emit(state.copyWith(finishedRequests: event.finishedRequests)));
  }

  Future<void> createRequest() async {
    add(CreateRequest(await _requestRepository.createRequest()));
  }

  void loadListRequest() async {
    add(FinishedRequestsLoaded(await _requestRepository.getFinishedRequests()));
  }
}
