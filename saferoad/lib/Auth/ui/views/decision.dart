// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:saferoad/Auth/ui/views/registerM.dart';
import 'package:saferoad/Auth/ui/views/registerpage.dart';

class MyView extends StatelessWidget {
  late final VoidCallback showRegisterPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona una opción'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                '¿Qué quieres ser?',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: RegisterM(
                            showlogingPage: () {},
                          ),
                          type: PageTransitionType.rightToLeftWithFade,
                          duration: const Duration(milliseconds: 250)));
                },
                child: const Text(
                  'Mecánico',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: RegisterPage(
                            showlogingPage: () {},
                          ),
                          type: PageTransitionType.rightToLeftWithFade,
                          duration: const Duration(milliseconds: 250)));
                },
                child: const Text(
                  'Usuario',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
