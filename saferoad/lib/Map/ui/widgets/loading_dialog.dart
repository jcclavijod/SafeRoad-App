import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/map/map_bloc.dart';

class LoadingDialog extends StatefulWidget {
  final String message;
  final int duration;

  const LoadingDialog({
    Key? key,
    this.message = 'Buscando locales cercanos en 2 KM',
    this.duration = 9000,
  }) : super(key: key);

  @override
  LoadingDialogState createState() => LoadingDialogState();
}

class LoadingDialogState extends State<LoadingDialog> {
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
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      if (mounted) {
        context.read<MapBloc>().statusNearbyPlaces();
      }
    });
  }
}

class AutoCloseAlertDialog extends StatefulWidget {
  final String message;

  const AutoCloseAlertDialog({
    Key? key,
    this.message = 'Buscando mecánicos cercanos',
  }) : super(key: key);

  @override
  AutoCloseAlertDialogState createState() => AutoCloseAlertDialogState();
}

class AutoCloseAlertDialogState extends State<AutoCloseAlertDialog> {
  @override
  void initState() {
    super.initState();
    _closeDialogAfterDuration();
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

  void _closeDialogAfterDuration() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        //context.read<MapBloc>().statusNearbyPlaces();
        //Navigator.of(context).pop();
      }
    });
  }
}
