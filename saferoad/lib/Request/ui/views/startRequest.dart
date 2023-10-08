import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saferoad/Auth/model/usuario_model.dart';
import 'package:saferoad/Map/ui/views/mapAux.dart';
import 'package:saferoad/Request/bloc/request/request_bloc.dart';
import 'package:saferoad/Request/model/Request.dart';
import 'package:saferoad/ServiceRegister/ui/views/causeFailureSelection.dart';
import 'package:saferoad/ServiceRegister/ui/views/clientAcceptance.dart';
import 'package:saferoad/ServiceRegister/ui/views/myBilling.dart';
import 'package:saferoad/ServiceRegister/ui/views/waitingAction.dart';

class StartRequest extends StatefulWidget {
  final LatLng location;
  final UserModel? authenticatedUser;
  final UserModel? receiver;
  final Request? request;
  const StartRequest({
    Key? key,
    required this.location,
    required this.receiver,
    required this.authenticatedUser,
    required this.request,
  }) : super(key: key);

  @override
  State<StartRequest> createState() => _StartRequestState();
}

class _StartRequestState extends State<StartRequest> {
  bool activateWiew = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('requests')
          .doc(widget.request!.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final requestData = snapshot.data!.data() as Map<String, dynamic>;
          Request newRequest = Request.fromMap(requestData);
          activateWiew =
              widget.authenticatedUser!.uid == requestData!['userId'];
          print("COMIDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
          print(activateWiew);
          print(requestData['service']);
          print("COMIDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
          if (requestData != null) {
            final status = requestData['status'];

            if (status == 'inBilling' && activateWiew) {
              return WaitingAction(
                message: "Esperando el cálculo del servicio...",
                lottieAssetPath: 'assets/Billpage.json',
              );
            } else if (status == 'inBilling' && !activateWiew) {
              return MyBilling(
                requestId: widget.request!.id!,
              );
            } else if (status == 'inCustomerAcceptance' &&
                activateWiew &&
                requestData['service'] != null) {
              print("COMIDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
              print(activateWiew);
              print(requestData['service']);
              return RequestDetailsView(
                requestData: newRequest,
              );
            } else if (status == 'inCustomerAcceptance' && !activateWiew) {
              return WaitingAction(
                message: "Esperando la aceptación del cliente...",
                lottieAssetPath: 'assets/mechanicWait.json',
              );
            } else if (status == 'inSelectingCause' && activateWiew) {
              return WaitingAction(
                message: "Esperando la finalización del mecánico...",
                lottieAssetPath: 'assets/mechanicWait.json',
              );
            } else if (status == 'inSelectingCause' && !activateWiew) {
              return CauseOfFailureSelectionPage(
                requestData: newRequest,
              );
            } else if (status == 'finished' && !activateWiew) {
              final usersInRoadBloc = BlocProvider.of<RequestBloc>(context);

              usersInRoadBloc.finishRequest(widget.request!.id,
                  widget.receiver!.name, widget.receiver!.profilePic);
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                );
              });
            } else if (status == 'finished' && activateWiew) {
              /*
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                );
              });
              */
            } else {
              return MapViewAux(
                location: widget.location,
                authenticatedUser: widget.authenticatedUser,
                receiver: widget.receiver,
                request: widget.request,
              );
            }
          }
        }

        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }
}
