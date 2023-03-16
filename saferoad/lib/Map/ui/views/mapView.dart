import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../bloc/location/my_location_bloc.dart';
import '../../bloc/map/map_bloc.dart';
import '../widgets/btn_location.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/show_dialog.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  void initState() {
    final myLocationBloc = BlocProvider.of<MyLocationBloc>(context);
    myLocationBloc.startTracking();
    super.initState();
  }

/*
  @override
  void dispose() {
    final myLocationBloc = BlocProvider.of<MyLocationBloc>(context);
    myLocationBloc.close();
    super.dispose();
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MyLocationBloc, MyLocationState>(
          builder: (context, state) => createMap(state)),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [const BtnLocation()],
      ),
    );
  }

  Widget createMap(MyLocationState state) {
    if (!state.existsLocation) return const Center(child: Text('Ubicando...'));

    final mapBloc = BlocProvider.of<MapBloc>(context);

    final locationBloc = BlocProvider.of<MyLocationBloc>(context);

    LatLng location = state.location;
    mapBloc.location(location);
    final CameraPosition cameraPosition = CameraPosition(
      target: location,
      zoom: 15,
    );
    mapBloc.searchNearbyPlaces(location);
    //final List<LatLng> puntos = mapBloc.getNearbyPlaces();
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return Stack(children: [
          if (state.showDialogLoading)
            const LoadingDialog(
              message: 'Buscando locales cercanos en 2 KM...',
              duration: 2000,
            ),
          if (state.showDialog) // Mostrar ventana emergente solo la primera vez
            buildDialog(context),
          GoogleMap(
            initialCameraPosition: cameraPosition,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: mapBloc.initMap,
            circles: Set.of([mapBloc.circle(location)]),
            markers: Set<Marker>.from(state.nearbyPlaces.map((LatLng punto) {
              return Marker(
                markerId: MarkerId(punto.toString()),
                position: punto,
                icon: BitmapDescriptor.defaultMarkerWithHue(200),
                infoWindow: InfoWindow(
                  title: punto.toString(),
                ),
              );
            })),
          ),
        ]);
      },
    );
  }
}
