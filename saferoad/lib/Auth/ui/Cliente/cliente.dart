import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saferoad/Auth/ui/Cliente/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saferoad/Auth/bloc/cliente/cliente_bloc.dart';

class ClienteLanding extends StatelessWidget {
  const ClienteLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ClienteBloc>(create: (_) => ClienteBloc()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RegisterUserButton(),
                LoginButton(),
                LogoutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
