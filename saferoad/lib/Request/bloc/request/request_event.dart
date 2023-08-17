part of 'request_bloc.dart';

abstract class RequestEvent extends Equatable {
  const RequestEvent();

  @override
  List<Object> get props => [];
}


class CreateRequest extends RequestEvent {
  final bool requestCreated;
  const CreateRequest(this.requestCreated);
}

class FinishedRequestsLoaded extends RequestEvent {
  final List<DocumentSnapshot> finishedRequests;

  const FinishedRequestsLoaded( this.finishedRequests);
}

class LoadRequestData extends RequestEvent {
  final String address;
  final LatLng location;
  final UserModel authenticatedUser;
  final UserModel receiver;
  const LoadRequestData(this.authenticatedUser, this.receiver, this.location, this.address);
}

