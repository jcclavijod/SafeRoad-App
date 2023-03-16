// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saferoad/Home/ui/views/perfil.dart';
import 'package:saferoad/Home/ui/widgets/SideMenuWidget.dart';
import 'package:saferoad/Map/ui/views/mapView.dart';

import '../../../Auth/model/user_model.dart';
import '../../../Chat/ui/views/listChats.dart';
import '../../../Map/ui/views/loading.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final user = FirebaseAuth.instance.currentUser;
  UserModel userM = UserModel();

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
    getDataFromFirestore();
    return docIds;
  }

  Future getDataFromFirestore() async {
    await FirebaseFirestore.instance
        .collection('mecanicos')
        .doc(docIDs[0])
        .get()
        .then((DocumentSnapshot snapshot) {
      userM = UserModel(
        name: snapshot['name'],
        cedula: snapshot['cedula'],
        local: snapshot['local'],
        email: snapshot['email'],
        bio: snapshot['bio'],
        profilePic: snapshot['profilePic'],
        createdAt: snapshot['createdAt'],
        phoneNumber: snapshot['phoneNumber'],
        uid: snapshot['uid'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe Road'),
      ),
      drawer: SideMenuWidget(userM: userM),
      body: const Loading(),
    );
  }
}
