part of 'my_location_bloc.dart';

class MyLocationState extends Equatable {
  final bool following;
  final bool existsLocation;
  final LatLng location;

  const MyLocationState(
      {this.following = true,
      this.existsLocation = false,
      required this.location});

  MyLocationState copyWith({
    bool? following,
    bool? existsLocation,
    LatLng? location,
  }) =>
      MyLocationState(
        following: following ?? this.following,
        existsLocation: existsLocation ?? this.existsLocation,
        location: location ?? this.location,
      );

  @override
  List<Object> get props => [following, existsLocation, location];
}
