import 'package:flutter/material.dart';

class BillAppBar extends StatelessWidget {
  final String text;
  const BillAppBar({
    required this.text,
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize:
          const Size.fromHeight(kToolbarHeight), // Altura estándar del AppBar
      child: AppBar(
        title: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.transparent, // Fondo transparente
        elevation: 0, // Sin sombra
        automaticallyImplyLeading: false, // Sin botón de retroceso
        // Personaliza el contenido del AppBar aquí
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3366FF), Color(0xFF00CCFF)],
            ),
          ),
        ),
      ),
    );
  }
}
