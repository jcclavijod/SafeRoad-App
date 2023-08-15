part of 'mechanical_request_bloc.dart';

abstract class MechanicalRequestEvent extends Equatable {
  const MechanicalRequestEvent();

  @override
  List<Object> get props => [];
}


class CreateRequest extends MechanicalRequestEvent {
  final bool requestCreated;
  const CreateRequest(this.requestCreated);
}

class FinishedRequestsLoaded extends MechanicalRequestEvent {
  final List<DocumentSnapshot> finishedRequests;

  const FinishedRequestsLoaded( this.finishedRequests);
}