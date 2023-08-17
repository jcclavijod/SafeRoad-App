import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:http/http.dart';
import '../../../Auth/model/user_model.dart';
import '../../../Map/ui/views/mapAux.dart';
import '../../Repository/requestRepository.dart';
import '../../bloc/request/request_bloc.dart';

class RequestPopup extends StatefulWidget {
  const RequestPopup({Key? key}) : super(key: key);

  @override
  RequestPopupState createState() => RequestPopupState();
}

class RequestPopupState extends State<RequestPopup> {
  String? address;
  late LatLng location;
  late UserModel? authenticatedUser;
  late UserModel? receiver;
  final repository = RequestRepository();

  @override
  void initState() {
    super.initState();

    final requestBloc = BlocProvider.of<RequestBloc>(context);
    requestBloc.loadRequestData();
    //_setUserAuth();
    //_setClient();
    repository.locationUser().then((result) {
      setState(() {
        location = result;
      });
    });
    repository.getAddressFromCoordinates().then((result) {
      setState(() {
        address = result;
      });
    });
  }

/*
  void _setUserAuth() async {
    final user = await repository.getUserAuth();
    setState(() {
      authenticatedUser = user;
    });
  }

  void _setClient() async {
    final client = await repository.getClient();
    setState(() {
      receiver = client;
    });
  }
  */

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
              address ?? '',
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
            child: const Text(
              'Necesito un mecánico en mi ubicación urgente...',
              style: TextStyle(
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
                  repository.updateRequestStatus('rejected');
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
                  repository.updateRequestStatus('accepted');

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapViewAux(
                        location: state.location,
                        authenticatedUser: state.authenticatedUser,
                        receiver: state.receiver,
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
