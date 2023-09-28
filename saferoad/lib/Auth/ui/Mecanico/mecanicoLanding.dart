// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:saferoad/Auth/bloc/mecanico/bloc/mecanico_bloc.dart';
import 'package:saferoad/Auth/ui/Mecanico/widgets.dart';
import 'package:provider/provider.dart';

class MecanicoLanding extends StatelessWidget {
  const MecanicoLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MecanicoBloc>(create: (_) => MecanicoBloc()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RegisterMecanicoButton(),
                LoginMecanicoButton(),
                LogoutMecanicoButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogoutMecanicoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () =>
          Provider.of<MecanicoBloc>(context, listen: false).logoutMecanico(),
      child: const Text('Cerrar sesión'),
    );
  }
}
