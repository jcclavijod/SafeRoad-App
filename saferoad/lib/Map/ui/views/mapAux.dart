import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saferoad/Auth/model/user_model.dart';
import 'package:saferoad/Home/ui/widgets/SideMenuWidget.dart';

import '../../../Auth/provider/auth_provider.dart';
import '../../bloc/location/my_location_bloc.dart';
import '../../bloc/map/map_bloc.dart';
import '../widgets/btn_sheet.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/show_dialog.dart';

class MapViewAux extends StatefulWidget {
  final LatLng location;
  final UserModel? authenticatedUser;
  final UserModel? receiver;
  const MapViewAux({
    Key? key,
    required this.location,
    required this.receiver,
    required this.authenticatedUser,
  }) : super(key: key);

  @override
  State<MapViewAux> createState() => _MapViewState();
}

class _MapViewState extends State<MapViewAux> {
  BitmapDescriptor? _selectedMarkerIcon;
  BitmapDescriptor? _locationIcon;
  final user = FirebaseAuth.instance.currentUser;
  late LatLng locationUser = const LatLng(0, 0);
  late LatLng locationUser2 = const LatLng(0, 0);
  UserModel userM = UserModel();
  String userType = "";

  @override
  void initState() {
    final myLocationBloc = BlocProvider.of<MyLocationBloc>(context);
    myLocationBloc.startTracking();
    super.initState();
    _setMarkerIcon();
    _setLocationIcon();
    final _repoAuth = FirebaseDataSource();

    _repoAuth.getUserType().then((value) {
      setState(() {
        userType = value;
      });
    });
  }

  void _setMarkerIcon() async {
    BitmapDescriptor markerIcon = await _getMarkerIcon('assets/marcador.png');
    setState(() {
      _selectedMarkerIcon = markerIcon;
    });
  }

  void _setLocationIcon() async {
    BitmapDescriptor locationIcon =
        await _getMarkerIcon('assets/iconoMecanico.png');
    setState(() {
      _locationIcon = locationIcon;
    });
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
      drawer: const SideMenuWidget(),
      body: BlocBuilder<MyLocationBloc, MyLocationState>(
        builder: (context, state) => createMapMechanic(state),
      ),
    );
  }

  Widget createMap(MyLocationState state) {
    if (!state.existsLocation) return const Center(child: Text('Ubicando...'));

    final mapBloc = BlocProvider.of<MapBloc>(context);

    //final locationBloc = BlocProvider.of<MyLocationBloc>(context);

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
              duration: 9000,
            ),
          if (state.showDialog)
            buildDialog(context),
          GoogleMap(
            initialCameraPosition: cameraPosition,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: mapBloc.initMap,
            markers: {
              Marker(
                markerId: const MarkerId('destino'),
                position: location,
                icon: BitmapDescriptor.defaultMarkerWithHue(200),
              ),
            },
          ),
        ]);
      },
    );
  }

  Widget createMapMechanic(MyLocationState state) {
    if (!state.existsLocation) return const Center(child: Text('Ubicando...'));

    final mapBloc = BlocProvider.of<MapBloc>(context);

    //final locationBloc = BlocProvider.of<MyLocationBloc>(context);

    LatLng locationM = state.location;
    mapBloc.location(locationM);
    //mapBloc.newLocation(location);
    final CameraPosition cameraPosition = CameraPosition(
      target: locationM,
      zoom: 15,
    );
    mapBloc.searchNearbyPlaces(locationM);
    //final List<LatLng> puntos = mapBloc.getNearbyPlaces();
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(children: [
            GoogleMap(
              initialCameraPosition: cameraPosition,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: mapBloc.initMap,
              markers: {
                Marker(
                  markerId: const MarkerId('destino'),
                  position: widget.location,
                  icon: _selectedMarkerIcon ??
                      BitmapDescriptor.defaultMarkerWithHue(200),
                  // Otras propiedades del marcador, como el ícono, el título, etc.
                ),
                Marker(
                  markerId: const MarkerId('mi_ubicacion'),
                  position: locationM,
                  icon: _locationIcon ?? BitmapDescriptor.defaultMarker,
                  infoWindow: const InfoWindow(
                    title: 'Mi ubicación',
                  ),
                  // Otras propiedades del marcador, como el título, etc.
                ),
              },
            ),
            BottomSheetContent(
              receiver: widget.receiver,
              authenticatedUser: widget.authenticatedUser,
            ),
          ]),
        );
      },
    );
  }

  Future<BitmapDescriptor> _getMarkerIcon(String assetName) async {
    final ByteData imageData = await rootBundle.load(assetName);
    final Uint8List bytes = imageData.buffer.asUint8List();
    final ui.Codec codec =
        await ui.instantiateImageCodec(bytes, targetWidth: 208);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? resizedImage =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List markerBytes = resizedImage!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(markerBytes);
  }
}
