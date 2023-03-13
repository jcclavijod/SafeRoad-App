// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:saferoad/Auth/ui/views/UserInformation.dart';
import 'package:saferoad/Auth/ui/views/decisionUser.dart';

class UserMechanicScreen extends StatefulWidget {
  const UserMechanicScreen({Key? key}) : super(key: key);

  @override
  _UserMechanicScreenState createState() => _UserMechanicScreenState();
}

class _UserMechanicScreenState extends State<UserMechanicScreen> {
  String? _selectedUserType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            );
          },
        ),
        title: Text('Volver'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿Qué tipo de usuario eres?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const decisionUser()),
                    (route) => false);
              },
              // ignore: sort_child_properties_last
              child: const Text(
                'Soy un usuario',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                minimumSize: const Size(200, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const userInformation()),
                    (route) => false);
              },
              // ignore: sort_child_properties_last
              child: const Text(
                'Soy un mecánico',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.teal,
                backgroundColor: Colors.white,
                minimumSize: const Size(200, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
