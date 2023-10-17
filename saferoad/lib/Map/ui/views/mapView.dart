import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lot;
import 'package:saferoad/Home/Repository/notifications.dart';
import 'package:saferoad/Home/ui/views/generalNotifications.dart';
import 'package:saferoad/Home/ui/widgets/SideMenuWidget.dart';
import '../../../Auth/provider/auth_provider.dart';
import '../../../Request/ui/views/createRequest.dart';
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
    Notifications.initialize(context);
    Notifications().setupCloudMessaging();
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
    //NotificationHelper.cancelAllNotifications();
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
      print("VERIFICAR EL FOKIN MAPVIEW MALPARIDO ");
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
              return Center(child: Text('Error verificando la membresia'));
            } else {
              return Container();
            }
          },
        ),
        const GeneralNotifications(),
        const AvailabilityOverlayWidget(),
      ]);
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            lot.Lottie.asset(
              'assets/chargeMap.json',
              fit: BoxFit.contain,
            ),
            const SizedBox(
                height: 16.0), // Espacio entre el texto y el widget Lottie
            const Text("Cargando mapa..."),
          ],
        ),
      );
    }
  }

  Widget createMap(MyLocationState state) {
    if (!state.existsLocation) return const Center(child: Text('Ubicando...'));

    final mapBloc = BlocProvider.of<MapBloc>(context);

    LatLng location = state.location;
    mapBloc.location(location);
    final CameraPosition cameraPosition = CameraPosition(
      target: location,
      zoom: 15,
    );
    mapBloc.searchNearbyPlaces(location);
    mapBloc.icon('assets/iconoMecanico.png');
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
    mapBloc.location(location);

    final CameraPosition cameraPosition = CameraPosition(
      target: location,
      zoom: 15,
    );
    mapBloc.searchNearbyPlaces(location);
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
