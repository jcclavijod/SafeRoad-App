import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:saferoad/Auth/auth_error.dart';
import 'package:saferoad/Auth/provider/auth_provider.dart';

import 'email_view.dart';
import 'login_view.dart';

// ignore: camel_case_types
class welcomeView extends StatelessWidget {
  const welcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/hola_gif.json',
                width: 500, fit: BoxFit.cover, reverse: true),
            const Text(
              'Registrate con tu correo!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Text(
              'Contacta ahora con tus clientes',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey.shade500, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                width: 300,
                height: 50,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: const EmailView(),
                            type: PageTransitionType.rightToLeftWithFade,
                            duration: const Duration(milliseconds: 250)));
                  },
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      'Crear Usuario',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: const LoginView(),
                          type: PageTransitionType.rightToLeftWithFade,
                          duration: const Duration(milliseconds: 250)));
                },
                child: const Text(
                  'Ya tengo una cuenta',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: authErrorRegister != ''
                  ? Text(
                      authErrorRegister.split(']')[1],
                      textAlign: TextAlign.center,
                      // ignore: prefer_const_constructors
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
