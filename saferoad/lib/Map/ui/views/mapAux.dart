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
import '../../../Request/model/Request.dart';
import '../../bloc/location/my_location_bloc.dart';
import '../../bloc/map/map_bloc.dart';
import '../../bloc/usersInRoad/users_in_road_bloc.dart';
import '../widgets/btn_sheet.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/show_dialog.dart';

class MapViewAux extends StatefulWidget {
  final LatLng location;
  final UserModel? authenticatedUser;
  final UserModel? receiver;
  final Request? request;
  const MapViewAux({
    Key? key,
    required this.location,
    required this.receiver,
    required this.authenticatedUser,
    required this.request,
  }) : super(key: key);

  @override
  State<MapViewAux> createState() => _MapViewState();
}

class _MapViewState extends State<MapViewAux> {
  @override
  void initState() {
    final myLocationBloc = BlocProvider.of<MyLocationBloc>(context);
    myLocationBloc.startTracking();
    final usersInRoadBloc = BlocProvider.of<UsersInRoadBloc>(context);
    usersInRoadBloc.typeUser();
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
      drawer: const SideMenuWidget(),
      body: BlocBuilder<MyLocationBloc, MyLocationState>(
        builder: (context, state) => createMapMechanic(state),
      ),
    );
  }

  Widget createMapMechanic(MyLocationState state) {
    if (!state.existsLocation) return const Center(child: Text('Ubicando...'));

    final mapBloc = BlocProvider.of<MapBloc>(context);
    LatLng locationM = state.location;
    final usersInRoadBloc = BlocProvider.of<UsersInRoadBloc>(context);
    usersInRoadBloc.locations(widget.location, locationM);

    final CameraPosition cameraPosition = CameraPosition(
      target: locationM,
      zoom: 15,
    );

    usersInRoadBloc.changeIcon();
    usersInRoadBloc.locationMechanic(widget.request);
    usersInRoadBloc.newLocationMechanic(widget.request);
    usersInRoadBloc.saveUsers(widget.authenticatedUser!, widget.receiver!);

    return BlocBuilder<UsersInRoadBloc, UsersInRoadState>(
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
                  position: state.location,
                  icon: state.icon2,
                ),
                Marker(
                  markerId: const MarkerId('mi_ubicacion'),
                  position: state.location2,
                  icon: state.icon,
                ),
              },
            ),
            BottomSheetContent(
              receiver: widget.receiver,
              authenticatedUser: widget.authenticatedUser,
              userType: state.userType,
              request: widget.request,
            ),
          ]),
        );
      },
    );
  }
}
