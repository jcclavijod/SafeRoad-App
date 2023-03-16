// ignore_for_file: unnecessary_null_comparison, avoid_print, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:saferoad/Auth/ui/views/update.dart';

class Perfil extends StatefulWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  late String fullName = '';
  late String email = '';
  late String cedula = '';
  late String phoneNumber = '';
  late String photoURL = '';
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final mechanicDoc = await FirebaseFirestore.instance
        .collection('mecanicos')
        .doc(user.uid)
        .get();
    final userData = userDoc.exists ? userDoc.data() : null;
    final mechanicData = mechanicDoc.exists ? mechanicDoc.data() : null;

    if (userData != null) {
      setState(() {
        fullName = '${userData['first name']} ${userData['last name']}';
        email = userData['email'] ?? '';
        cedula = userData['cedula'].toString();
        phoneNumber = userData['phoneNumber'].toString();
        photoURL = userData['profilePic'] ?? '';
        // ignore: avoid_print
        print('Eres un usuario');
      });
    } else if (mechanicData != null) {
      setState(() {
        fullName = '${mechanicData['first name']} ${mechanicData['last name']}';
        email = mechanicData['email'] ?? '';
        cedula = mechanicData['cedula'].toString();
        phoneNumber = mechanicData['phoneNumber'].toString();
        photoURL = mechanicData['profilePic'] ?? '';
        // ignore: avoid_print
        print('Eres un mecanico');
      });
    } else {
      print('No se encontró el usuario en ninguna colección');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (fullName == null ||
        email == null ||
        cedula == null ||
        photoURL == null) {
      return const CircularProgressIndicator();
    } else {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    photoURL,
                    height: _isExpanded ? 400 : 300,
                    width: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      return child;
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cedula,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                phoneNumber,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const Padding(padding: EdgeInsets.all(20)),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: const MyUpdate(),
                          type: PageTransitionType.rightToLeftWithFade,
                          duration: const Duration(milliseconds: 250)));
                },
                icon: const Icon(Icons.settings),
                label: const Text('Editar perfil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
