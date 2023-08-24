import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../Auth/model/user_model.dart';
import '../../../Map/ui/views/mapAux.dart';
import '../../Repository/requestRepository.dart';
import '../widgets/widgetAux.dart';

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
  late Timer _timer;
  final repository = RequestRepository();

  @override
  void initState() {
    super.initState();
    _setUserAuth();
    _setClient();
    _setLocation();
    /*repository.locationUser2().then((result) {
      setState(() {
        location = result;
      });
    });*/
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTimeInSeconds++;
      });
      if (elapsedTimeInSeconds == 120) {
        timer.cancel();
      }
    });
  }

  void _setUserAuth() async {
    final user = await repository.getUserAuth();
    setState(() {
      authenticatedUser = user;
    });
  }

  void _setClient() async {
    final client = await repository.getClientMECANICO();
    setState(() {
      receiver = client;
    });
  }

  void _setLocation() async {
    final _location = await repository.locationUserUSUARIO();
    setState(() {
      location = _location;
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
              Image.asset(
                "assets/mecanic.png",
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 16.0),
              Stack(
                children: [
                  LinearProgressIndicator(
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue.shade300,
                    ),
                    value: elapsedTimeInSeconds / 120,
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
      StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('requests')
              .orderBy('createdAt',
                  descending: true) // Ordenar por fecha de creación descendente
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              //final requestId = snapshot.data!.docs.first.id;

              final userId = snapshot.data!.docs.first.get('userId');
              final status = snapshot.data!.docs.first.get('status');

              if (userId == FirebaseAuth.instance.currentUser!.uid &&
                  status == 'accepted') {
                //final location =
                //snapshot.data!.docs.first.get('mechanicLocation');
                return MapViewAux(
                  location: location,
                  authenticatedUser: authenticatedUser,
                  receiver: receiver,
                );
              }
            }
            return Container();
          })
    ]);
  }
}
