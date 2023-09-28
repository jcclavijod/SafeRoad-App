import 'package:flutter/material.dart';

class CenteredTextWidget extends StatelessWidget {
  const CenteredTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'MAPA CON RUTA',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
