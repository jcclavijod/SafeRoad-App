import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Home/ui/views/userpage.dart';
import '../../bloc/map/map_bloc.dart';
import '../../bloc/usersInRoad/users_in_road_bloc.dart';

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
            context.read<MapBloc>().add(const SaveShowDialog(false));
            //Navigator.of(context).pop();
          },
          child: const Text('Sí, ampliar a 4 km'),
        ),
      ],
    ),
  );
}

class CancelationAlertDialog extends StatelessWidget {
  String user = "Cliente";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersInRoadBloc, UsersInRoadState>(
      builder: (context, state) {
        if (state.userType == "mecanico") {
          user = "Mecánico";
        }
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Bordes redondeados
          ),
          title: Row(
            children: const [
              Icon(
                Icons.cancel,
                color: Colors.red,
                size: 32.0,
              ),
              SizedBox(width: 8.0),
              Text(
                'Cancelación de servicio',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text('El $user ha cancelado el servicio.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16.0), // Bordes redondeados
                  ),
                ),
              ),
              child: const Text(
                'Aceptar',
                style: TextStyle(
                  fontSize: 18.0, // Tamaño de letra aumentado
                  color: Colors.white, // Cambia el color del texto a blanco
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
