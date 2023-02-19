import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saferoad/Auth/provider/auth_provider.dart';
import 'package:saferoad/Auth/ui/views/homes_screen.dart';
import 'package:saferoad/Auth/bloc/register_screen.dart';
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
                Image.asset(
                  "assets/1.jpg",
                  height: 400,
                ),
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
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onPressed: () async {
                        if (ap.isSignedIn == true) {
                          await ap.getDataFromSP().whenComplete(
                                () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const WelcomeScreen(),
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
                        ;
                      },
                      text: "Continuar",
                    )),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onPressed: () {},
                      text: "Otros metodos de registro",
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
