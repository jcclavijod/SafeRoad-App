import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saferoad/Home/ui/widgets/SideMenuWidget.dart';
import 'package:saferoad/Request/ui/views/ListRequests.dart';
import '../../../Auth/provider/auth_provider.dart';
import '../../../Request/ui/views/createRequest.dart';
import '../../../Request/ui/views/requestMechanic.dart';
import '../../../helpers/notificationHelper.dart';
import '../../bloc/location/my_location_bloc.dart';
import '../../bloc/map/map_bloc.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/show_dialog.dart';
import 'availability.dart';
import '../../../Membresia/ui/widgets/verificationMembership.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  String userType = "";
  @override
  void initState() {
    NotificationHelper.initialize(context);
    final myLocationBloc = BlocProvider.of<MyLocationBloc>(context);
    myLocationBloc.startTracking();
    super.initState();

    final repoAuth = FirebaseDataSource();

    repoAuth.getUserType().then((value) {
      setState(() {
        userType = value;
      });
    });
  }

  @override
  void dispose() {
    NotificationHelper.cancelAllNotifications();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (userType == "user") {
      final mapBloc = BlocProvider.of<MapBloc>(context);
      return Scaffold(
        drawer: const SideMenuWidget(),
        body: BlocBuilder<MyLocationBloc, MyLocationState>(
            builder: (context, state) => createMap(state)),
      );
    } else if (userType == "mecanico") {
      return Stack(children: [
        Scaffold(
          drawer: const SideMenuWidget(),
          body: BlocBuilder<MyLocationBloc, MyLocationState>(
            builder: (context, state) => createMapMechanic(state),
          ),
        ),
        FutureBuilder<void>(
          future: VerificationMembership()
              .verifyMembership(context), // Verify membership here
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // ignore: prefer_const_constructors
              return Center(child: Text('Error verifying membership'));
            } else {
              return Container();
              /*
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('requests')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    //final requestId = snapshot.data!.docs.first.id;
                    final mechanicId =
                        snapshot.data!.docs.first.get('mecanicoId');
                    final status = snapshot.data!.docs.first.get('status');
                    if (mechanicId == FirebaseAuth.instance.currentUser!.uid &&
                        status == 'pending') {
                      return const Visibility(
                          visible: true, // Mostrar el widget RequestPopup
                          child: RequestPopup());
                    }
                  }
                  return Visibility(
                    visible: false,
                    child: Container(),
                  );
                },
              );*/
            }
          },
        ),
        AvailabilityOverlayWidget(),
      ]);
    } else {
      return const Center(
        child: Text("Cargando mapa..."),
      );
    }
  }

  Widget createMap(MyLocationState state) {
    if (!state.existsLocation) return const Center(child: Text('Ubicando...'));

    final mapBloc = BlocProvider.of<MapBloc>(context);

    //final locationBloc = BlocProvider.of<MyLocationBloc>(context);

    LatLng location = state.location;
    final CameraPosition cameraPosition = CameraPosition(
      target: location,
      zoom: 15,
    );
    mapBloc.searchNearbyPlaces(location);

    mapBloc.icon('assets/iconoMecanico.png');
    //final List<LatLng> puntos = mapBloc.getNearbyPlaces();
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return Stack(children: [
          if (state.showDialogLoading)
            const LoadingDialog(
              message: 'Buscando locales cercanos en 2 KM...',
              duration: 9000,
            ),
          if (state.showDialog) // Mostrar ventana emergente solo la primera vez
            buildDialog(context),
          GoogleMap(
            initialCameraPosition: cameraPosition,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: mapBloc.initMap,
            circles: {mapBloc.circle(location)},
            markers: Set<Marker>.from(state.nearbyPlaces.map((punto) {
              final LatLng mechanicLocation = LatLng(
                  punto.get('position')['geopoint'].latitude,
                  punto.get('position')['geopoint'].longitude);
              return Marker(
                markerId: MarkerId(punto.get('local')),
                position: mechanicLocation,
                icon: state.icon,
                infoWindow: InfoWindow(
                  title: punto.get('local'),
                ),
              );
            })),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CreateRequest(nearbyPlaces: mapBloc.state.nearbyPlaces),
          ),
        ]);
      },
    );
  }

  Widget createMapMechanic(MyLocationState state) {
    if (!state.existsLocation) return const Center(child: Text('Ubicando...'));

    final mapBloc = BlocProvider.of<MapBloc>(context);

    LatLng location = state.location;
    final CameraPosition cameraPosition = CameraPosition(
      target: location,
      zoom: 15,
    );
    mapBloc.searchNearbyPlaces(location);
    //final List<LatLng> puntos = mapBloc.getNearbyPlaces();
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return Stack(children: [
          GoogleMap(
            initialCameraPosition: cameraPosition,
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: mapBloc.initMap,
            circles: {mapBloc.circle(location)},
          ),
        ]);
      },
    );
  }
}
