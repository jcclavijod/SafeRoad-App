// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saferoad/Home/ui/views/perfil.dart';
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
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('User Name'),
              accountEmail: Text('user.email@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/men/1.jpg'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map_outlined),
              title: const Text('Map'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Loading(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble),
              title: const Text('Chat'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(authenticatedUser: userM),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Perfil(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Safe Road'),
      ),
      body: const Loading(),
    );
  }
}
