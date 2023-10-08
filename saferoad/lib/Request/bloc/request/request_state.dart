part of 'request_bloc.dart';

class RequestState extends Equatable {
  final bool requestCreated;
  final Stream<List<Request>> finishedRequests;
  final String address;
  final LatLng location;
  final LatLng location2;
  final UserModel authenticatedUser;
  final UserModel receiver;
  final Request request;
  final TextEditingController problemController;
  final String spanishStatus;

  const RequestState(
      {required this.problemController,
      this.requestCreated = false,
      this.finishedRequests = const Stream.empty(),
      this.authenticatedUser = const UserModel(
        name: "",
        lastname: "",
        mail: "",
        password: "",
        identification: "",
        gender: "",
        phoneNumber: "",
        birthday: "",
        uid: "",
        profilePic: "",
        isAviable: false,
        token: "",
      ),
      this.receiver = const UserModel(
        name: "",
        lastname: "",
        mail: "",
        password: "",
        identification: "",
        gender: "",
        phoneNumber: "",
        birthday: "",
        uid: "",
        profilePic: "",
        isAviable: false,
        token: "",
      ),
      this.location = const LatLng(0, 0),
      this.location2 = const LatLng(0, 0),
      this.address = "",
      this.request = const Request(
          createdAt: DateTimeObject(date: '', time: ''),
          mechanicId: "",
          requestDetails: "",
          status: "",
          userId: "",
          userAddress: "",
          userLocation: GeoPoint(0, 0),
          mechanicLocation: GeoPoint(0, 0),
          service:"",
          selectedCauseId: ""),
          this.spanishStatus = "",});

  RequestState copyWith(
          {bool? requestCreated,
          Stream<List<Request>>? finishedRequests,
          String? address,
          String? spanishStatus,
          LatLng? location,
          LatLng? location2,
          UserModel? authenticatedUser,
          UserModel? receiver,
          Request? request,
          TextEditingController? problemController}) =>
      RequestState(
        requestCreated: requestCreated ?? this.requestCreated,
        finishedRequests: finishedRequests ?? this.finishedRequests,
        address: address ?? this.address,
        location: location ?? this.location,
        location2: location2 ?? this.location2,
        authenticatedUser: authenticatedUser ?? this.authenticatedUser,
        receiver: receiver ?? this.receiver,
        request: request ?? this.request,
        problemController: problemController ?? this.problemController,
        spanishStatus: spanishStatus ?? this.spanishStatus
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
        request,
        problemController,
        spanishStatus
      ];
}
