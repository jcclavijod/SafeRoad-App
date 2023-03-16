// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saferoad/Home/ui/views/perfil.dart';
import 'package:saferoad/Map/ui/views/mapView.dart';


class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final user = FirebaseAuth.instance.currentUser;
  // document IDs
  List<String> docIDs = [];

  // get docIDs
  Future<List<String>> getDocIds() async {
    List<String> docIds = [];

    // Buscar documentos en la colección "mecanicos" y "users"
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('mecanicos')
        .where('email', isEqualTo: 'mashi@gmail.com')
        .get();

    snapshot.docs.forEach((doc) {
      docIds.add(doc.id);
    });

    snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: 'mashi@gmail.com')
        .get();

    snapshot.docs.forEach((doc) {
      docIds.add(doc.id);
    });

    return docIds;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout),
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.map_outlined)),
                Tab(icon: Icon(Icons.chat_bubble)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
            title: const Text('Safe Road'),
          ),
          // ignore: prefer_const_constructors
          body: TabBarView(
            children: const [
              MapView(),
              Icon(Icons.directions_transit),
              Perfil(),
            ],
          ),
        ),
      ),
    );
  }
}
