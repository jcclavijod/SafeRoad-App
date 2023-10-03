// ignore_for_file: use_key_in_widget_constructors, unused_import
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:saferoad/Auth/ui/Cliente/LoginViewCliente.dart';
import 'package:saferoad/Auth/ui/Mecanico/LoginViewMecanico.dart';

class DecisionPage extends StatelessWidget {
  void _navigateToCliente(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }

  void _navigateToMecanico(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginMecanico()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/hola_gif.json',
                  width: 500, fit: BoxFit.cover, reverse: true),
              const Text(
                'Bienvenido a Safe Road',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 50,
              ),
              // Botón para el rol de cliente
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  onPressed: () => _navigateToCliente(context),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Soy Cliente',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Botón para el rol de mecánico
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  onPressed: () => _navigateToMecanico(context),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Soy Mecánico',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
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
