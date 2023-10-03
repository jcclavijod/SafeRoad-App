// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:saferoad/Auth/ui/Mecanico/LoginViewMecanico.dart';
import 'package:saferoad/Auth/ui/Mecanico/registerViewMecanico.dart';
import 'package:provider/provider.dart';

class RegisterMecanicoButton extends StatefulWidget {
  @override
  _RegisterMecanicoButtonState createState() => _RegisterMecanicoButtonState();
}

class _RegisterMecanicoButtonState extends State<RegisterMecanicoButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => RegisterMechanicView()),
        );
      },
      child: const Text('Registrar usuario'),
    );
  }
}

class LoginMecanicoButton extends StatefulWidget {
  @override
  _LoginMecanicoButtonState createState() => _LoginMecanicoButtonState();
}

class _LoginMecanicoButtonState extends State<LoginMecanicoButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginMecanico()),
        );
      },
      child: const Text('Iniciar sesion'),
    );
  }
}
