import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WaitingAction extends StatelessWidget {
  final String message;
  final String lottieAssetPath;

  WaitingAction({
    required this.message,
    required this.lottieAssetPath,
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Cambia este color al que desees
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              lottieAssetPath,
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            const SizedBox(height: 16.0),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16.0),
            const Icon(
              Icons.access_time, // Puedes cambiar este icono
              size: 48.0,
              color: Colors.blue, // Cambia el color del icono
            ),
          ],
        ),
      ),
    );
  }
}
