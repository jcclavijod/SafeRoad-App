import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saferoad/Request/bloc/request/request_bloc.dart';
import 'package:saferoad/Request/model/Request.dart';
import 'package:saferoad/Home/ui/widgets/SideMenuWidget.dart';
import 'package:saferoad/Request/ui/widgets/iconEmpty.dart';
import 'package:saferoad/Request/ui/views/startRequest.dart';

class ListRequests extends StatefulWidget {
  final String type;
  const ListRequests({super.key, required this.type});

  @override
  ListRequestsState createState() => ListRequestsState();
}

class ListRequestsState extends State<ListRequests> {
  @override
  void initState() {
    super.initState();
    print("LISTA DE VIAJES MALPARIDO");
    final requestBloc = BlocProvider.of<RequestBloc>(context);
    requestBloc.loadListRequest(widget.type);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Solicitudes'),
      ),
      drawer: const SideMenuWidget(),
      body: _buildFinishedRequestCard(context),
    );
  }

  Widget _buildFinishedRequestCard(BuildContext context) {
    return BlocBuilder<RequestBloc, RequestState>(builder: (context, state) {
      return StreamBuilder<List<Request>>(
        stream: state.finishedRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: requestEmpty(context),
            );
          } else {
            final requests = snapshot.data;

            return ListView.builder(
              itemCount: requests!.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                print("tamaño: ${requests.length}");
                print("estado: ${request.status}");
                return _requestCard(request, index, state, context);
              },
            );
          }
        },
      );
    });
  }

  Widget _requestCard(
      Request request, int index, RequestState state, BuildContext context) {
    Widget serviceImage;
    Color buttonColor;
    String spanishStatus = "";
    final requestBloc = BlocProvider.of<RequestBloc>(context);
    if (request.status == "inProcess") {
      print("EN PROCESOOOOOOOOO");
    }
    switch (request.status) {
      case 'pending':
        serviceImage =
            const Icon(Icons.access_time, size: 40, color: Colors.grey);
        buttonColor = Colors.grey;
        spanishStatus = "Pendiente";
        break;
      case 'inProcess':
        serviceImage = const Icon(Icons.build, size: 40, color: Colors.orange);
        buttonColor = Colors.orange;
        spanishStatus = "En proceso";

        break;
      case 'inBilling':
        serviceImage = const Icon(Icons.money, size: 40, color: Colors.green);
        buttonColor = Colors.green;
        spanishStatus = "En facturación";
        break;
      case 'inCustomerAcceptance':
        serviceImage = const Icon(Icons.check, size: 40, color: Colors.blue);
        buttonColor = Colors.blue;
        spanishStatus = "Esperando repuesta";
        break;
      case 'inSelectingCause':
        serviceImage = const Icon(Icons.help, size: 40, color: Colors.blue);
        buttonColor = Colors.blue;

        spanishStatus = "Esperando respuesta";

        break;
      case 'finished':
        serviceImage =
            const Icon(Icons.check_circle, size: 40, color: Colors.green);
        buttonColor = Colors.green;
        spanishStatus = "Finalizado";
        break;
      default:
        serviceImage =
            const Icon(Icons.assignment, size: 40, color: Colors.blue);
        buttonColor = Colors.blue;
        break;
    }

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          serviceImage,
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Servicio #${index + 1}', // Reemplaza esto con el campo adecuado de usuario
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  request
                      .userAddress, // Reemplaza esto con el campo adecuado de dirección de usuario
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Estado: ${spanishStatus}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          if (request.status != "finished")
            ElevatedButton(
              onPressed: () async {
                await requestBloc.loadRequest(request);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StartRequest(
                      location: state.location,
                      authenticatedUser: state.authenticatedUser,
                      receiver: state.receiver,
                      request: request,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Ver Detalle'),
            ),
        ],
      ),
    );
  }
}
