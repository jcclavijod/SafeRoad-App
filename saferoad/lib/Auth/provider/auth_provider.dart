import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:saferoad/Auth/model/user_model.dart';

class FirebaseDataSource {
  User get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not Authentication exception');
    return user;
  }

  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;

  String newId() {
    return firestore.collection('tmp').doc().id;
  }

  Stream<Iterable<UserModel>> getMyUsers() {
    return firestore
        .collection('user/${currentUser.uid}/myUsers')
        .snapshots()
        .map((it) => it.docs.map((e) => UserModel.fromMap(e.data())));
  }

  Future<void> saveMyUser(UserModel myUser, File? image) async {
    final ref = firestore.doc('user/${currentUser.uid}/myUsers/${myUser.uid}');
    if (image != null) {
      if (myUser.profilePic != null) {
        await storage.refFromURL(myUser.profilePic!).delete();
      }

      final fileName = image.uri.pathSegments.last;
      final imagePath = '${currentUser.uid}/myUsersImages/$fileName';

      final storageRef = storage.ref(imagePath);
      await storageRef.putFile(image);
      final url = await storageRef.getDownloadURL();
    }
    await ref.set(myUser.toMap(), SetOptions(merge: true));
  }

  Future<void> deleteMyUser(UserModel myUser) async {
    final ref = firestore.doc('user/${currentUser.uid}/myUsers/${myUser.uid}');
    if (myUser.profilePic != null) {
      await storage.refFromURL(myUser.profilePic!).delete();
    }
    await ref.delete();
  }
}
