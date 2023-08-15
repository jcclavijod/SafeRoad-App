import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saferoad/Map/bloc/gps/gps_bloc.dart';

class GpsAccess extends StatelessWidget {
  const GpsAccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<GpsBloc, GpsState>(
          builder: (context, state) {
            return !state.isGpsEnable
                ? const EnableGps()
                : const AccessButton();
          },
        ),
      ),
    );
  }
}

class AccessButton extends StatelessWidget {
  const AccessButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Es necesario habilitar el Gps"),
        MaterialButton(
          color: Colors.blueGrey,
          shape: const StadiumBorder(),
          elevation: 0,
          onPressed: () {
            final gpsBloc = BlocProvider.of<GpsBloc>(context);
            gpsBloc.askGpsAccess();
          },
          child: const Text("Solicitar Acceso",
              style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}

class EnableGps extends StatelessWidget {
  const EnableGps({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Debe habilitar el Gps",
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
    );
  }
}
