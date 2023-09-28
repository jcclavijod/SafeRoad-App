// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class auth_repository extends StatelessWidget {
  final String documetId;
  const auth_repository({super.key, required this.documetId});

  @override
  Widget build(BuildContext context) {
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    return FutureBuilder(
      future: user.doc(documetId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            '${data['first name']} '
            '${data['last name']}  '
            '${data['age']}'
            ' years old',
            style: const TextStyle(fontSize: 20),
          );
        }
        return const Text('loading');
      },
    );
  }
}
