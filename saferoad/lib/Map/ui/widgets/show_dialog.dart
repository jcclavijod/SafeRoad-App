import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/map/map_bloc.dart';

Widget buildDialog(BuildContext context) {
  return Container(
    color: Colors.black54,
    child: AlertDialog(
      title: const Text('¿Quieres ampliar el rango?'),
      content: const Text(
          'No hay lugares cercanos. Es necesario buscar en un rango más amplio'),
      actions: [
        TextButton(
          onPressed: () {
            context.read<MapBloc>().add(const SaveShowDialog(false, false));
            //Navigator.of(context).pop();
          },
          child: const Text('Sí, ampliar a 5 km'),
        ),
      ],
    ),
  );
}
