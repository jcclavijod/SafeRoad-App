part of 'mechanical_request_bloc.dart';

class MechanicalRequestState extends Equatable {
  final bool requestCreated;
  final List<DocumentSnapshot> finishedRequests;

  const MechanicalRequestState(
      {this.requestCreated = false, this.finishedRequests = const []});

  MechanicalRequestState copyWith({
    bool? requestCreated,
    List<DocumentSnapshot>? finishedRequests,
  }) =>
      MechanicalRequestState(
        requestCreated: requestCreated ?? this.requestCreated,
        finishedRequests: finishedRequests ?? this.finishedRequests,
      );

  @override
  List<Object> get props => [requestCreated, finishedRequests];
}
