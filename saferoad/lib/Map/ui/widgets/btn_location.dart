
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saferoad/Map/bloc/location/my_location_bloc.dart';

import '../../bloc/map/map_bloc.dart';

class BtnLocation extends StatelessWidget {
  const BtnLocation({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    final mapBloc = BlocProvider.of<MapBloc>(context);
    final myLocationBloc = BlocProvider.of<MyLocationBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10 ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: const Icon( Icons.my_location, color: Colors.black87 ),
          onPressed: () {
            
            final destination = myLocationBloc.state.location;
            mapBloc.moveCamera(destination);

          },
        ),
      ),
    );
  }
}


