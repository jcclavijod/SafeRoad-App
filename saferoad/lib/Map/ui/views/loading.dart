import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saferoad/Map/bloc/gps/gps_bloc.dart';
import 'package:saferoad/Map/ui/views/gpsAccess.dart';
import 'package:saferoad/Map/ui/views/mapView.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<GpsBloc, GpsState>(
      builder: (context, state) {
        return state.isAllReady ? const MapView() : const GpsAccess();
      },
    ));
  }
}
