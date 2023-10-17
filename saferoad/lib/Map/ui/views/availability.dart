import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/availability/availability_bloc.dart';

class AvailabilitySwitchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<AvailabilityBloc>(context);
    mapBloc.getState();

    return BlocBuilder<AvailabilityBloc, AvailabilityState>(
        builder: (context, state) {
      return Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        right: 16,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                state.availabilityText,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Transform.scale(
                scale:
                    1.5, // Ajusta este valor para aumentar o disminuir el tamaño
                child: Switch(
                  value: state.isAvailable,
                  onChanged: (value) {
                    mapBloc.updateState(value);
                    print("Switch CAMBIOOOOOOOOOOOO: $value");
                  },
                  activeColor:
                      Colors.blue, // Cambia el color cuando está activo
                  activeTrackColor: Colors.blue
                      .withOpacity(0.5), // Cambia el color del área activa
                  inactiveThumbColor: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class AvailabilityOverlayWidget extends StatelessWidget {
  const AvailabilityOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    print("AVAILABILITYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
    return BlocBuilder<AvailabilityBloc, AvailabilityState>(
      builder: (context, state) {
        if (!state.isAvailable) {
          final isAvailable = state.isAvailable;
          return Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: !isAvailable,
                  child: Container(
                    color: isAvailable
                        ? Colors.transparent
                        : Colors.grey.withOpacity(0.7),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.location_off,
                        color: Colors.red,
                        size: 40,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Actualmente estas\nFuera de servicio',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              AvailabilitySwitchWidget(),
            ],
          );
        }
        return AvailabilitySwitchWidget();
      },
    );
  }
}
