import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saferoad/Auth/model/usuario_model.dart';
import 'package:saferoad/Request/bloc/request/request_bloc.dart';
import 'package:saferoad/Request/model/Request.dart';
import 'package:saferoad/Request/ui/views/progressDialog.dart';
import 'package:saferoad/Request/ui/views/startRequest.dart';

class PendingRequest extends StatefulWidget {
  const PendingRequest({
    Key? key,
  }) : super(key: key);

  @override
  State<PendingRequest> createState() => _PendingRequestState();
}

class _PendingRequestState extends State<PendingRequest> {
  bool activateWiew = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isNavigating = false; // Variable para rastrear si ya se está navegando

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestBloc, RequestState>(builder: (context, state) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .where('status', isEqualTo: 'inProcess')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final requestBloc = BlocProvider.of<RequestBloc>(context);
            final userId = snapshot.data!.docs.first.get('userId');
            final status = snapshot.data!.docs.first.get('status');

            if (userId == FirebaseAuth.instance.currentUser!.uid &&
                status == 'inProcess' &&
                !isNavigating) {
              // Verifica si no estamos navegando
              // Espera a que se carguen los datos
              isNavigating = true; // Marca que estamos navegando
              Future.delayed(const Duration(milliseconds: 500), () {
                showDialog(
                  context: context,
                  barrierDismissible: false, 
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("¡Han aceptado su solicitud!"),
                      content: Text("Presione el botón para continuar."),
                      
                      actions: [
                        TextButton(
                          onPressed: () async {
                            await requestBloc.listenRequestChanges();
                            await requestBloc.loadRequestData();
                            await requestBloc.loadMechanic();
                            print("9999999999999999999999999999");
                            print(requestBloc.state.location2);
                            print(requestBloc.state.authenticatedUser.uid);
                            print(requestBloc.state.receiver.uid);
                            print(requestBloc.state.request.id);
                            print("9999999999999999999999999999");
                            // Navega a la siguiente pantalla cuando se presiona el botón
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StartRequest(
                                  location: requestBloc.state.location2,
                                  authenticatedUser:
                                      requestBloc.state.authenticatedUser,
                                  receiver: requestBloc.state.receiver,
                                  request: requestBloc.state.request,
                                ),
                              ),
                            );
                          },
                          child: Text("Continuar"),
                        ),
                      ],
                    );
                  },
                );
              });

              // Ejecuta el código de navegación una vez que los datos se han cargado

            }
          }
          return ConnectingDialog();
        },
      );
    });
  }
}
