import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saferoad/Auth/model/usuario_model.dart';
import 'package:saferoad/Request/model/Request.dart';
import 'package:saferoad/Request/ui/views/startRequest.dart';
//import 'package:http/http.dart';

import '../../../Map/ui/views/mapAux.dart';
import '../../Repository/requestRepository.dart';
import '../../bloc/request/request_bloc.dart';

class RequestPopup2 extends StatefulWidget {
  final Request? request;
  final String address;
  final VoidCallback? onClose; // Agrega un manejador onClose
  const RequestPopup2({
    Key? key,
    required this.request,
    required this.address,
    this.onClose, // Recibe el manejador onClose
  }) : super(key: key);

  @override
  RequestPopup2State createState() => RequestPopup2State();
}

class RequestPopup2State extends State<RequestPopup2> {
  late LatLng location;
  late UserModel? authenticatedUser;
  late UserModel? receiver;
  final repository = RequestRepository(
    firestoreBd: FirebaseFirestore.instance,
    user: FirebaseAuth.instance.currentUser,
  );

  @override
  void initState() {
    super.initState();
    final requestBloc = BlocProvider.of<RequestBloc>(context);
    requestBloc.loadRequestInitial(widget.request!);
    requestBloc.loadRequestData();
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: BlocBuilder<RequestBloc, RequestState>(builder: (context, state) {
        return containerRequest(state);
      }),
    );
  }

  Widget containerRequest(RequestState state) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Color de la sombra
            spreadRadius: 7,
            blurRadius: 20,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Nueva petición',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Dirección:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            child: Text(
              widget.address,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              widget.request!.requestDetails,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.priority_high,
                  color: Colors.white,
                ),
                label: const Text(
                  'Denegar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  //repository.updateRequestStatus('rejected');
                  //Navigator.of(context).pop();
                  widget.onClose?.call();
                },
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  BlocProvider.of<RequestBloc>(context)
                      .changeRequestMessaging();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StartRequest(
                        location: state.location,
                        authenticatedUser: state.authenticatedUser,
                        receiver: state.receiver,
                        request: state.request,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Aceptar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
