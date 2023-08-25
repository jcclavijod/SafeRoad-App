part of 'users_in_road_bloc.dart';

class UsersInRoadState extends Equatable {
  final LatLng location;
  final LatLng location2;
  final BitmapDescriptor icon;
  final BitmapDescriptor icon2;
  final String userType;


  const UsersInRoadState({
    this.location = const LatLng(0, 0),
    this.location2 = const LatLng(0, 0),
    this.userType = "",
    this.icon = BitmapDescriptor.defaultMarker,
    this.icon2 = BitmapDescriptor.defaultMarker,
  });

  UsersInRoadState copyWith({
    LatLng? location,
    LatLng? location2,
    BitmapDescriptor? icon,
    BitmapDescriptor? icon2,
    String? userType,
  }) =>
      UsersInRoadState(
          userType: userType ?? this.userType,
          location: location ?? this.location,
          location2: location2 ?? this.location2,
          icon: icon ?? this.icon,
          icon2: icon2 ?? this.icon2,
          );
  @override
  List<Object> get props => [
        location,
        location2,
        icon,
        icon2,
        userType
      ];
}
