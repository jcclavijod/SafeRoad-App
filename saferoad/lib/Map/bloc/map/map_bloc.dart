import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart' as poly;
import '../../repository/SearchRepository.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(const MapState()) {
    on<OnLocation>(
        (event, emit) => emit(state.copyWith(location: event.location)));
    on<OnMapDone>((event, emit) => emit(state.copyWith(mapReady: true)));
    on<UpdateRange>((event, emit) => emit(state.copyWith(range: event.range)));
    on<SaveShowDialog>((event, emit) => emit(state.copyWith(
        showDialog: event.showDialog,
        showDialogLoading: event.showDialogLoading)));
    on<SaveNearbyPlaces>((event, emit) =>
        emit(state.copyWith(nearbyPlaces: event.nearbyPlaces)));
  }

  late GoogleMapController _mapController;
  List<poly.LatLng> puntosCercanos = [];
  SearchRepository searchRepository = SearchRepository();

  void initMap(GoogleMapController controller) {
    if (!state.mapReady) {
      _mapController = controller;
      print("MAPA LISTO RATATA");
      /* _mapController.setMapStyle( jsonEncode(uberMapTheme) );*/
      add(OnMapDone());
    }
  }

  void location(LatLng position) {
    add(OnLocation(position));
  }

  void moveCamera(LatLng destination) {
    final cameraUpdate = CameraUpdate.newLatLng(destination);
    _mapController.animateCamera(cameraUpdate);
  }

/*
  List<LatLng> getNearbyPlaces() {
    
    List<LatLng> result = [];
    for (poly.LatLng latLng in puntosCercanos) {
      result.add(LatLng(latLng.latitude, latLng.longitude));
    }
    return result;
  }
  */

  void searchNearbyPlaces(LatLng position) {
    puntosCercanos = searchRepository.searchMechanicNearby(
        position.latitude, position.longitude, state.range);

    List<LatLng> result = [];
    for (poly.LatLng latLng in puntosCercanos) {
      result.add(LatLng(latLng.latitude, latLng.longitude));
    }

    add(SaveNearbyPlaces(result));
  }

/*
  List<LatLng> getNearbyPlaces(LatLng position) {
    puntosCercanos = searchRepository.searchMechanicNearby(
        position.latitude, position.longitude, state.range);
    List<LatLng> result = [];
    for (poly.LatLng latLng in puntosCercanos) {
      result.add(LatLng(latLng.latitude, latLng.longitude));
    }
    return result;
  }
*/
  void statusNearbyPlaces() {
    if (state.nearbyPlaces.isEmpty) {
      add(const SaveShowDialog(true, false));
      add(const UpdateRange(5000));
      searchNearbyPlaces(state.location);
    } else {
      add(const SaveShowDialog(false, false));
    }
  }

  Circle circle(LatLng location) {
    print(state.range);
    return Circle(
      circleId: const CircleId("myCircle"),
      center: location,
      radius: state.range, // Radio en metros
      fillColor: Colors.orange.withOpacity(0.1),
      strokeColor: Colors.orange,
      strokeWidth: 2,
    );
  }
}
