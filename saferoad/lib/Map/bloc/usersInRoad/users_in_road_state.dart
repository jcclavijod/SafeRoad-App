part of 'users_in_road_bloc.dart';

class UsersInRoadState extends Equatable {
  final LatLng location;
  final LatLng location2;
  final BitmapDescriptor icon;
  final BitmapDescriptor icon2;
  final String userType;
  final UserModel authenticatedUser;
  final UserModel receiver;


  const UsersInRoadState({
    this.location = const LatLng(0, 0),
    this.location2 = const LatLng(0, 0),
    this.userType = "",
    this.icon = BitmapDescriptor.defaultMarker,
    this.icon2 = BitmapDescriptor.defaultMarker,
    this.authenticatedUser = const UserModel(
         name: "",
        cedula: "",
        local: "",
        email: "",
        genero: "",
        ubicacion: "",
        bio: "",
        profilePic: "",
        createdAt: "",
        phoneNumber: "",
        uid: "",
        token: "" 
      ),
      this.receiver = const UserModel(
         name: "",
        cedula: "",
        local: "",
        email: "",
        genero: "",
        ubicacion: "",
        bio: "",
        profilePic: "",
        createdAt: "",
        phoneNumber: "",
        uid: "",
        token: "" 
      ),
  });

  UsersInRoadState copyWith({
    LatLng? location,
    LatLng? location2,
    BitmapDescriptor? icon,
    BitmapDescriptor? icon2,
    String? userType,
    UserModel? authenticatedUser,
    UserModel? receiver,
  }) =>
      UsersInRoadState(
          userType: userType ?? this.userType,
          location: location ?? this.location,
          location2: location2 ?? this.location2,
          icon: icon ?? this.icon,
          icon2: icon2 ?? this.icon2,
          authenticatedUser: authenticatedUser ?? this.authenticatedUser,
          receiver: receiver ?? this.receiver,
          );
  @override
  List<Object> get props => [
        location,
        location2,
        icon,
        icon2,
        userType,
        authenticatedUser,
        receiver,
      ];
}
