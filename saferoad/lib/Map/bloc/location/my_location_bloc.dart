import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart' as poly;

import '../../repository/SearchRepository.dart';
part 'my_location_event.dart';
part 'my_location_state.dart';

class MyLocationBloc extends Bloc<MyLocationEvent, MyLocationState> {
  MyLocationBloc() : super(const MyLocationState(location: LatLng(0, 0))) {
    on<OnLocationChange>((event, emit) =>
        emit(state.copyWith(existsLocation: true, location: event.location)));
  }

  SearchRepository searchRepository = SearchRepository();
  StreamSubscription<Position>? _positionSubscription;
  List<poly.LatLng> puntosCercanos = [];

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    return super.close();
  }

  void startTracking() {
    const geoLocatorOptions =
         LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);
    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: geoLocatorOptions)
            .listen((Position position) {
      final newLocation = LatLng(position.latitude, position.longitude);
      add(OnLocationChange(newLocation));
    });
  }
}
