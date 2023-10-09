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
  final Stream<List<Request>> finishedRequests;

  const FinishedRequestsLoaded(this.finishedRequests);
}


class LoadSpanishStatus extends RequestEvent {
  final String spanishStatus;
  const LoadSpanishStatus(this.spanishStatus);
}



class LoadRequestData extends RequestEvent {
  final String address;
  final LatLng location;
  final UserModel authenticatedUser;
  final UserModel receiver;
  final Request request;
  const LoadRequestData(this.authenticatedUser, this.receiver, this.location,
      this.address, this.request);
}

class LoadLocation2 extends RequestEvent {
  final LatLng location2;
  const LoadLocation2(this.location2);
}



class FirstRequestLoaded extends RequestEvent {
  final Request request;
  const FirstRequestLoaded(this.request);
}

class ProblemTextChangedEvent extends RequestEvent {
  final TextEditingController problemController;
  const ProblemTextChangedEvent(this.problemController);
}
