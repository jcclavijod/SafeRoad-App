
// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:saferoad/Auth/ui/views/decision.dart';
import 'package:page_transition/page_transition.dart';
import 'password_reset.dart';

class MyHomePage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const MyHomePage({super.key, required this.showRegisterPage});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _emailConroller = TextEditingController();
  final _passwordConroller = TextEditingController();
  Future signin() async {
    // loading widget
    showDialog(
        context: context,
        builder: (ontext) {
          return const Center(
              child: CircularProgressIndicator.adaptive(
            backgroundColor: Colors.blue,
          ));
        });
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailConroller.text.trim(),
        password: _passwordConroller.text.trim());

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _emailConroller.dispose();
    _passwordConroller.dispose();
    super.dispose();
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
                'Ingresa con tu correo!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                'Conectate',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey.shade500, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 50,
              ),
              // email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _emailConroller,
                  decoration: InputDecoration(
                      hintText: 'Correo',
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(12)),
                      fillColor: Colors.grey[200],
                      filled: true),
                ),
              ),
              const SizedBox(height: 10),

              // password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      controller: _passwordConroller,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Contraseña',
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PasswordResetPage(),
                            ));
                      },
                      child: const Text(
                        'Olvide mi contraseña',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              // sign in button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: () => signin(),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Center(
                      child: Text(
                        'Iniciar sesión',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //  not a member ? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No eres miembro?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: MyView(),
                              type: PageTransitionType.rightToLeftWithFade,
                              duration: const Duration(milliseconds: 250)));
                    },
                    child: Text('Registrate'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
