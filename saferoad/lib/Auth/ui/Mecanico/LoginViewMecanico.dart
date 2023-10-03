// ignore_for_file: unused_element, non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:saferoad/Auth/bloc/mecanico/bloc/mecanico_bloc.dart';
import 'package:saferoad/Auth/ui/Mecanico/registerViewMecanico.dart';

class LoginMecanico extends StatefulWidget {
  @override
  _LoginMecanicoViewState createState() => _LoginMecanicoViewState();
}

class _LoginMecanicoViewState extends State<LoginMecanico> {
  final _formKey = GlobalKey<FormState>();
  final MecanicoBloc _mecanicoBloc = MecanicoBloc();
  String email = '';
  String password = '';
  bool _isLoading = false;
  void _RegisterToMecanico(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterMechanicView()),
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
              Expanded(
                child: Lottie.asset(
                  'assets/animation_ln2sain4.json',
                ),
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      await _mecanicoBloc.loginMecanico(email, password);
                      Navigator.of(context).pushReplacementNamed('/');
                    } catch (e) {
                      print('Error al iniciar sesión: $e');
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(12.0),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () => _RegisterToMecanico(context),
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
