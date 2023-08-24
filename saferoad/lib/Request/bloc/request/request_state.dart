part of 'request_bloc.dart';

class RequestState extends Equatable {
  final bool requestCreated;
  final List<DocumentSnapshot> finishedRequests;
  final String address;
  final LatLng location;
  final UserModel authenticatedUser;
  final UserModel receiver;

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
      this.address = ""});

  RequestState copyWith({
    bool? requestCreated,
    List<DocumentSnapshot>? finishedRequests,
    String? address,
    LatLng? location,
    UserModel? authenticatedUser,
    UserModel? receiver,
  }) =>
      RequestState(
        requestCreated: requestCreated ?? this.requestCreated,
        finishedRequests: finishedRequests ?? this.finishedRequests,
        address: address ?? this.address,
        location: location ?? this.location,
        authenticatedUser: authenticatedUser ?? this.authenticatedUser,
        receiver: receiver ?? this.receiver,
      );

  @override
  List<Object> get props => [
        requestCreated,
        finishedRequests,
        address,
        location,
        authenticatedUser,
        receiver
      ];
}
