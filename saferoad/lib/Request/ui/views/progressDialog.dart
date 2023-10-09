import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:saferoad/Auth/model/usuario_model.dart';
import 'package:saferoad/Request/ui/views/startRequest.dart';

import '../../../Map/ui/views/mapAux.dart';
import '../../Repository/requestRepository.dart';
import '../../bloc/request/request_bloc.dart';
import '../../model/Request.dart';

class ConnectingDialog extends StatefulWidget {
  const ConnectingDialog({Key? key}) : super(key: key);

  @override
  ConnectingDialogState createState() => ConnectingDialogState();
}

class ConnectingDialogState extends State<ConnectingDialog> {
  int elapsedTimeInSeconds = 0;
  late LatLng location;
  late UserModel? authenticatedUser;
  late UserModel? receiver;
  late Request? request;
  late Timer _timer;
  final repository = RequestRepository();

  @override
  void initState() {
    super.initState();
    final requestBloc = BlocProvider.of<RequestBloc>(context);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTimeInSeconds++;
      });
      if (elapsedTimeInSeconds == 60) {
        timer.cancel();
        repository.cancelRequest('rejected');
        // Cancelar la solicitud // Cerrar el diálogo
      }
    });
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestBloc, RequestState>(builder: (context, state) {
      if (elapsedTimeInSeconds == 60) {
        return showTimeoutDialog(context);
      } else {
        return progressDialog(state);
      }
    });
  }

  Widget progressDialog(RequestState state) {
    return Stack(children: [
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: const Text("Conectando con mecánico cercano"),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/connectingMechanic.json',
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16.0),
              Stack(
                children: [
                  LinearProgressIndicator(
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue.shade300,
                    ),
                    value: elapsedTimeInSeconds / 60,
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "${(elapsedTimeInSeconds / 10 * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      repository.cancelRequest('rejected');
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 0.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                    ),
                    child: Text(
                      "Cancelar",
                      style: TextStyle(
                        color: Colors.blue.shade300,
                      ),
                    ),
                  ),
                  Text(
                    "Tiempo transcurrido: ${elapsedTimeInSeconds.toString()}s",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget showTimeoutDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade300,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Center(
                child: Text(
                  "Tiempo de espera agotado",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Lottie.asset(
              'assets/notFoundMech.json',
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Nadie ha aceptado su solicitud a tiempo. Por favor, inténtelo de nuevo más tarde.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Acción al hacer clic en "Aceptar" (cierra el cuadro de diálogo)
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue.shade300,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 0.0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
              ),
              child: const Text(
                "Aceptar",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
