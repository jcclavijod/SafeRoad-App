import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../Request/model/Request.dart';
import '../../Repository/mapRepository.dart';
import '../../repository/SearchRepository.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(const MapState()) {
    on<OnLocation>(
        (event, emit) => emit(state.copyWith(location: event.location)));

    on<OnMapDone>((event, emit) => emit(state.copyWith(mapReady: true)));

    on<UpdateRange>((event, emit) => emit(state.copyWith(range: event.range)));

    on<UpdateMechanicState>((event, emit) =>
        emit(state.copyWith(mechanicState: event.mechanicState)));

    on<SaveShowDialog>((event, emit) => emit(state.copyWith(
        showDialog: event.showDialog,
        showDialogLoading: event.showDialogLoading)));

    on<SaveNearbyPlaces>((event, emit) =>
        emit(state.copyWith(nearbyPlaces: event.nearbyPlaces)));

    on<SaveIcon>((event, emit) => emit(state.copyWith(icon: event.icon)));
  }

  late GoogleMapController _mapController;

  SearchRepository searchRepository = SearchRepository();
  MapRepository mapRepository = MapRepository();
  late StreamSubscription<LatLng> _locationSubscription;

  void initMap(GoogleMapController controller) {
    if (!state.mapReady) {
      _mapController = controller;
      /* _mapController.setMapStyle( jsonEncode(uberMapTheme) );*/
      add(OnMapDone());
    }
  }

  void location(LatLng position) {
    add(OnLocation(position));
  }

  void updateMechanicState(bool mechanicState) {
    print("ESTE ES EL ESTADO original");
    print(state.mechanicState);
    print("ESTE ES EL ESTADO QUE SE ESTA COLOCANDO");
    print(mechanicState);
    add(UpdateMechanicState(mechanicState));
  }

  void moveCamera(LatLng destination) {
    final cameraUpdate = CameraUpdate.newLatLng(destination);
    _mapController.animateCamera(cameraUpdate);
  }

  void searchNearbyPlaces(LatLng position) async {
    List<DocumentSnapshot> puntosCercanos =
        await searchRepository.mechanicNearby(position, state.range);
    
    for (final mechanic in puntosCercanos) {
      final mechanicId = mechanic.id;
      final mechanicStream = searchRepository.listenToMechanicChanges(mechanicId);
      mechanicStream.listen((mechanicSnapshot) {
        // Actualiza el mecánico en la lista nearbyMechanics cuando cambie
        final index = puntosCercanos.indexWhere((element) => element.id == mechanicId);
        if (index >= 0) {
          puntosCercanos[index] = mechanicSnapshot;
        }
        // Puedes emitir un nuevo estado con la lista actualizada aquí si lo deseas
        add(SaveNearbyPlaces(puntosCercanos));
      });
  }
  }

  void statusNearbyPlaces() {
    if (state.nearbyPlaces.isEmpty) {
      add(const SaveShowDialog(true, false));
      add(const UpdateRange(2.6));
      searchNearbyPlaces(state.location);
    } else {
      add(const SaveShowDialog(false, false));
    }
  }

  Circle circle(LatLng location) {
    return Circle(
      circleId: const CircleId("myCircle"),
      center: location,
      radius: state.range * 1000, // Radio en metros
      fillColor: Colors.orange.withOpacity(0.1),
      strokeColor: Colors.orange,
      strokeWidth: 2,
    );
  }

  Future<void> icon(String assetName) async {
    BitmapDescriptor icon = await mapRepository.getMarkerIcon(assetName, 150);
    add(SaveIcon(icon));
  }

  @override
  Future<void> close() {
    _locationSubscription.cancel();
    return super.close();
  }
}
