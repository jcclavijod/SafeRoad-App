// ignore_for_file: unused_element, non_constant_identifier_names, library_private_types_in_public_api, use_key_in_widget_constructors, unused_import, file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lottie/lottie.dart';
import 'package:saferoad/Auth/bloc/cliente/cliente_bloc.dart';
import 'package:saferoad/Auth/ui/Cliente/registerViewCliente.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final ClienteBloc _clienteBloc = ClienteBloc();
  String email = '';
  String password = '';

  void _RegisterToCliente(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Lottie.asset(
                'assets/animation_ln2saq36.json',
                height: 300,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu correo electrónico.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu contraseña.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  
                  if (_formKey.currentState!.validate()) {
                    _clienteBloc.loginUser(email, password);
                    //Navigator.of(context).pop();
                    
                    Navigator.of(context).pushReplacementNamed('/');
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: const EdgeInsets.all(12.0),
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () => _RegisterToCliente(context),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: const Text(
                  '¿No tienes cuenta? Crea una ahora!',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
