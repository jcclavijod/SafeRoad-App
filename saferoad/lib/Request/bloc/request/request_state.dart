part of 'request_bloc.dart';

class RequestState extends Equatable {
  final bool requestCreated;
  final List<DocumentSnapshot> finishedRequests;
  final String address;
  final LatLng location;
  final LatLng location2;
  final UserModel authenticatedUser;
  final UserModel receiver;
  final Request request;

  const RequestState(
      {this.requestCreated = false,
      this.finishedRequests = const [],
      this.authenticatedUser = const UserModel(
        name: "",
        cedula: "",
        local: "",
        email: "",
        bio: "",
        profilePic: "",
        createdAt: "",
        phoneNumber: "",
        uid: "",
      ),
      this.receiver = const UserModel(
        name: "",
        cedula: "",
        local: "",
        email: "",
        bio: "",
        profilePic: "",
        createdAt: "",
        phoneNumber: "",
        uid: "",
      ),
      this.location = const LatLng(0, 0),
      this.location2 = const LatLng(0, 0),
      this.address = "",
      this.request = const Request(
          createdAt:  DateTimeObject(date:'',time: ''),
          mecanicoId: "",
          requestDetails: "",
          status: "",
          userId: "",
          userLocation:  GeoPoint(0,0) )});

  RequestState copyWith({
    bool? requestCreated,
    List<DocumentSnapshot>? finishedRequests,
    String? address,
    LatLng? location,
    LatLng? location2,
    UserModel? authenticatedUser,
    UserModel? receiver,
    Request? request,
  }) =>
      RequestState(
        requestCreated: requestCreated ?? this.requestCreated,
        finishedRequests: finishedRequests ?? this.finishedRequests,
        address: address ?? this.address,
        location: location ?? this.location,
        location2: location2 ?? this.location2,
        authenticatedUser: authenticatedUser ?? this.authenticatedUser,
        receiver: receiver ?? this.receiver,
        request: request ?? this.request,
      );

  @override
  List<Object> get props => [
        requestCreated,
        finishedRequests,
        address,
        location,
        location2,
        authenticatedUser,
        receiver,
        request
      ];
}
