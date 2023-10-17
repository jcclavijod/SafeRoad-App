import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saferoad/Map/bloc/map/map_bloc.dart';
import 'package:saferoad/Map/ui/widgets/loading_dialog.dart';

class SearchMechanics extends StatefulWidget {
  const SearchMechanics({Key? key}) : super(key: key);

  @override
  State<SearchMechanics> createState() => _SearchMechanicsState();
}

class _SearchMechanicsState extends State<SearchMechanics> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
      if (!state.showDialog && state.range == 1.8) {
        context.read<MapBloc>().searchNearbyPlaces(state.location);
        Future.delayed(const Duration(seconds: 5), () {
          context.read<MapBloc>().add(const SaveShowDialog(true));
        });
        return Container(
          color: Colors.grey.withOpacity(
              0.5), // Cambia el color y la opacidad según tus preferencias
          child: const AbsorbPointer(
            absorbing: true,
            child: AutoCloseAlertDialog(),
          ),
        );
      } else if (state.nearbyPlaces.isEmpty &&
          state.showDialog &&
          state.range >= 1.8) {
        return buildDialog(context, state);
      } else if (state.nearbyPlaces.isEmpty && state.range >= 2.6) {
        return const SearchMechanics();
      }
      return Container();
    });
  }

  Widget buildDialog(BuildContext context, MapState state) {
    return Container(
      color: Colors.black54,
      child: AlertDialog(
        title: const Text('¿Quieres ampliar el rango?'),
        content: const Text(
            'No hay lugares cercanos. Es necesario buscar en un rango más amplio'),
        actions: [
          TextButton(
            onPressed: () {
              context.read<MapBloc>().add(const UpdateRange(2.6));
              context.read<MapBloc>().searchNearbyPlaces(state.location);
              //Navigator.of(context).pop();
            },
            child: const Text('Sí, ampliar a 2.5 km'),
          ),
        ],
      ),
    );
  }
}
