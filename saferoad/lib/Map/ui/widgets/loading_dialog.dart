import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../bloc/map/map_bloc.dart';

class LoadingDialog extends StatefulWidget {
  final String message;
  final int duration;


  const LoadingDialog(
      {Key? key,
      this.message = 'Buscando locales cercanos en 2 KM',
      this.duration = 2000,
      })
      : super(key: key);

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20.0),
          Text(widget.message),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );
  }

  void _startTimer() {
    Timer(Duration(milliseconds: widget.duration), () {
      setState(() {
        _isLoading = false;
      });

      //context.read<MapBloc>().add(const SaveShowDialog(false, false));

      context.read<MapBloc>().statusNearbyPlaces();
    });
  }
}
