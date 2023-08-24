part of 'users_in_road_bloc.dart';

 class UsersInRoadEvent extends Equatable {
  const UsersInRoadEvent();

  @override
  List<Object> get props => [];
}

class OnLocations extends UsersInRoadEvent {
  final LatLng location;
  final LatLng location2;
  const OnLocations(this.location,this.location2);
}


class SaveIcons extends UsersInRoadEvent {
  final BitmapDescriptor icon;
  final BitmapDescriptor icon2;
  const SaveIcons(this.icon,this.icon2);
}

class SaveTypeUser extends UsersInRoadEvent {
  final String userType;
  const SaveTypeUser(this.userType);
}