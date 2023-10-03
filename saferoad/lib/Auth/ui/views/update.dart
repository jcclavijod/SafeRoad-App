import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyUpdate extends StatefulWidget {
  const MyUpdate({super.key});

  @override
  State<MyUpdate> createState() => _MyUpdateState();
}

class _MyUpdateState extends State<MyUpdate> {
  final String? userEmail = FirebaseAuth.instance.currentUser!.email;
  CollectionReference user = FirebaseFirestore.instance.collection('users');

  final _firstNameConroller = TextEditingController();
  final _lastNameConroller = TextEditingController();
  final _cedulaConrroller = TextEditingController();

  List<String> docIDs = [];

  // update function
  Future update() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get()
        // ignore: avoid_function_literals_in_foreach_calls
        .then((value) => value.docs.forEach((doc) {
              docIDs.add(doc.reference.id);
            }));

    await user.doc(docIDs[0]).update({
      'first name': _firstNameConroller.text.trim(),
      'last name': _lastNameConroller.text.trim(),
      'cedula': _cedulaConrroller.text.trim()
    });
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
              //Hello Again
              const Text('Actualizar!'),
              const SizedBox(height: 5),
              const Text(
                'Actualiza tus datos!',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),

              // first name textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _firstNameConroller,
                  decoration: InputDecoration(
                      hintText: 'First Name',
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

              // last name textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _lastNameConroller,
                  decoration: InputDecoration(
                      hintText: 'Last Name',
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

              // age textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _cedulaConrroller,
                  decoration: InputDecoration(
                      hintText: 'Cedula',
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

              // signUp button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: () => update(),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Center(
                      child: Text(
                        'Hecho',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
