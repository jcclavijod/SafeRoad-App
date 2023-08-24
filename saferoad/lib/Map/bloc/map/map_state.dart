part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool mapReady;
  final double range;
  final bool showDialog;
  final bool showDialogLoading;
  final LatLng location;
  final List<DocumentSnapshot> nearbyPlaces;
  final BitmapDescriptor icon;
  final bool mechanicState;

  /*final bool drawPath;
  final bool followLocation;

 final LatLng centralLocation;*/

  // Polylines
  /*final Map<String, Polyline> polylines;*/

  const MapState({
    this.mapReady = false,
    this.showDialog = false,
    this.mechanicState = false,
    this.showDialogLoading = true,
    this.range = 1.6,
    this.location = const LatLng(0, 0),
    this.nearbyPlaces = const [],
    this.icon = BitmapDescriptor.defaultMarker,
    Map<String, Polyline>? polylines,
  });

  MapState copyWith({
    bool? mapReady,
    double? range,
    bool? mechanicState,
    bool? showDialog,
    bool? showDialogLoading,
    LatLng? location,
    BitmapDescriptor? icon,
    List<DocumentSnapshot>? nearbyPlaces,
  }) =>
      MapState(
          mapReady: mapReady ?? this.mapReady,
          range: range ?? this.range,
          mechanicState: mechanicState ?? this.mechanicState,
          showDialog: showDialog ?? this.showDialog,
          showDialogLoading: showDialogLoading ?? this.showDialogLoading,
          location: location ?? this.location,
          nearbyPlaces: nearbyPlaces ?? this.nearbyPlaces,
          icon: icon ?? this.icon,
          );

  @override
  List<Object> get props => [
        mapReady,
        range,
        mechanicState,
        showDialog,
        showDialogLoading,
        location,
        nearbyPlaces,
        icon
      ];
}
