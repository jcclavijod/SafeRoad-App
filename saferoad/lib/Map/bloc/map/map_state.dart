part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool mapReady;
  final double range;
  final bool showDialog;
  final bool showDialogLoading;
  final LatLng location;
  final List<LatLng> nearbyPlaces;

  /*final bool drawPath;
  final bool followLocation;

 final LatLng centralLocation;*/

  // Polylines
  /*final Map<String, Polyline> polylines;*/

  const MapState({
    this.mapReady = false,
    this.showDialog = false,
    this.showDialogLoading = true,
    this.range = 1000,
    this.location = const LatLng(0, 0),
    this.nearbyPlaces = const [],
    /*this.drawPath = false,
    this.followLocation = false,
    required this.centralLocation,*/
    /*required Map<String, Polyline> polylines*/
  }); /*: polylines = polylines ?? new Map();*/

  MapState copyWith({
    bool? mapReady,
    double? range,
    bool? showDialog,
    bool? showDialogLoading,
    LatLng? location,
    List<LatLng>? nearbyPlaces,
    /*bool? drawPath,
    bool? followLocation,
    LatLng? centralLocation,
    Map<String, Polyline>? polylines*/
  }) =>
      MapState(
        mapReady: mapReady ?? this.mapReady,
        range: range ?? this.range,
        showDialog: showDialog ?? this.showDialog,
        showDialogLoading: showDialogLoading ?? this.showDialogLoading,
        location: location ?? this.location,
        nearbyPlaces: nearbyPlaces ?? this.nearbyPlaces,
        /*polylines: polylines ?? this.polylines,
        centralLocation: centralLocation ?? this.centralLocation,
        followLocation: followLocation ?? this.followLocation,
        drawPath: drawPath ?? this.drawPath,*/
      );

  @override
  List<Object> get props => [mapReady, range, showDialog, showDialogLoading, location, nearbyPlaces];
}
