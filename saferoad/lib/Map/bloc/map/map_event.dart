part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapDone extends MapEvent {}


class UpdateRange extends MapEvent {
  final double range;
  const UpdateRange(this.range);
}

class UpdateMechanicState extends MapEvent {
  final bool mechanicState;
  const UpdateMechanicState(this.mechanicState);
}

class SaveShowDialog extends MapEvent {
  final bool showDialog;
  final bool showDialogLoading;

  const SaveShowDialog(this.showDialog, this.showDialogLoading);
}

class SaveNearbyPlaces extends MapEvent {
  final List<DocumentSnapshot> nearbyPlaces;
  const SaveNearbyPlaces(this.nearbyPlaces);
}

class SaveIcon extends MapEvent {
  final BitmapDescriptor icon;
  const SaveIcon(this.icon);
}


class OnLocation extends MapEvent {
  final LatLng location;
  const OnLocation(this.location);
}


class OnMovedMapa extends MapEvent {
  final LatLng centerMap;
  const OnMovedMapa(this.centerMap);
}
