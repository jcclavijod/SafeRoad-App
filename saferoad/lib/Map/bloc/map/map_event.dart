part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapDone extends MapEvent {}

//class OnDialTour extends MapEvent {}

//class OnFollowLocation extends MapEvent {}

class UpdateRange extends MapEvent {
  final double range;

  const UpdateRange(this.range);
}

class SaveShowDialog extends MapEvent {
  final bool showDialog;
  final bool showDialogLoading;

  const SaveShowDialog(this.showDialog, this.showDialogLoading);
}

class SaveNearbyPlaces extends MapEvent {
  final List<LatLng> nearbyPlaces;
  const SaveNearbyPlaces(this.nearbyPlaces);
}

class OnLocation extends MapEvent {
  final LatLng location;
  const OnLocation(this.location);
}

class OnMovedMapa extends MapEvent {
  final LatLng centerMap;
  const OnMovedMapa(this.centerMap);
}

class OnNewLocation extends MapEvent {
  final LatLng location;
  const OnNewLocation(this.location);
}