// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saferoad/Auth/bloc/cliente/cliente_bloc.dart';
import 'package:saferoad/Auth/ui/Cliente/LoginViewCliente.dart';
import 'package:saferoad/Auth/ui/Cliente/registerViewCliente.dart';
import 'package:provider/provider.dart';

class RegisterUserButton extends StatefulWidget {
  @override
  _RegisterUserButtonState createState() => _RegisterUserButtonState();
}

class _RegisterUserButtonState extends State<RegisterUserButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => RegisterView()),
        );
      },
      child: const Text('Registrar usuario'),
    );
  }
}

class LoginButton extends StatefulWidget {
  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginView()),
        );
      },
      child: const Text('Iniciar sesion'),
    );
  }
}


