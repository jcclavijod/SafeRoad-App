import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:saferoad/Auth/provider/auth_provider.dart';
import 'package:saferoad/Auth/ui/views/register_screen.dart';
import 'package:saferoad/Auth/ui/views/welcome_view.dart';
import 'package:saferoad/Auth/ui/widgets/custom_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/person.json',
                    width: 500, fit: BoxFit.cover, reverse: true),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Crea tu cuenta ahora",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Conecta con un mecanico ahora",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                      width: 300,
                      height: 50,
                      child: MaterialButton(
                        onPressed: () async {
                          if (ap.isSignedIn == true) {
                            await ap.getDataFromSP().whenComplete(
                                  () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const WelcomeScreen(),
                                    ),
                                  ),
                                );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          }
                        },
                        color: Colors.blue,
                        child: const Center(
                          child: Text(
                            'Ingresa con tu telefono',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const welcomeView(),
                              type: PageTransitionType.rightToLeftWithFade,
                              duration: const Duration(milliseconds: 250)));
                    },
                    child: const Text(
                      'Otros metodos de registro',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
