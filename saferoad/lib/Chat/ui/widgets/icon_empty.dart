import 'package:flutter/material.dart';

Widget iconEmpty(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.info_outline,
        size: MediaQuery.of(context).size.width * 0.4,
        color: Colors.grey[500],
      ),
      const SizedBox(height: 16),
      Text(
        "No tienes ningún chat activo",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[500],
        ),
      ),
    ],
  );
}
