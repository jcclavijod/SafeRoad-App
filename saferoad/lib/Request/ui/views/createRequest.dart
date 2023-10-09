import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saferoad/Request/ui/views/pendingRequest.dart';
import 'package:saferoad/Request/ui/views/progressDialog.dart';

import '../../bloc/request/request_bloc.dart';

class CreateRequest extends StatelessWidget {
  CreateRequest({
    Key? key,
    required this.nearbyPlaces,
  }) : super(key: key);

  List<DocumentSnapshot> nearbyPlaces;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestBloc, RequestState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (BlocProvider.of<RequestBloc>(context)
                        .state
                        .problemController
                        .text
                        .isEmpty) {
                      const snackBar = SnackBar(
                        content: Text(
                            'Por favor, describe tu problema antes de continuar.'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return const PendingRequest();
                        },
                      );

                      await BlocProvider.of<RequestBloc>(context)
                          .createRequest(nearbyPlaces);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                  ),
                  child: const Text(
                    'Conectar con mecánico cercano',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: state.problemController,
                  onChanged: (value) {
                    BlocProvider.of<RequestBloc>(context)
                        .add(ProblemTextChangedEvent(state.problemController));
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textDirection: TextDirection.ltr,
                  decoration: const InputDecoration(
                    labelText: 'Describe tu problema',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
