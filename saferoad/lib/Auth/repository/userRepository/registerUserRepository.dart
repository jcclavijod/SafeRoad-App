// ignore_for_file: avoid_print, use_rethrow_when_possible, unused_import, file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

import 'package:saferoad/Auth/model/usuario_model.dart';

class UserRegisterRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final firebase_storage.FirebaseStorage _firebaseStorage;

  UserRegisterRepository(
      {FirebaseAuth? firebaseAuth,
      FirebaseFirestore? firestore,
      firebase_storage.FirebaseStorage? firebaseStorage})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseStorage =
            firebaseStorage ?? firebase_storage.FirebaseStorage.instance;

  Future<void> registerUser(UserModel user, File profilePic) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.mail,
        password: user.password,
      );
      String uid = userCredential.user!.uid;

      await _firebaseStorage
          .ref('users/${userCredential.user!.uid}/profilePic')
          .putFile(profilePic);
      String profilePicUrl = await _firebaseStorage
          .ref('users/${userCredential.user!.uid}/profilePic')
          .getDownloadURL();

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': user.name,
        'lastname': user.lastname,
        'mail': user.mail,
        'password': user.password,
        'identification': user.identification,
        'gender': user.gender,
        'phoneNumber': user.phoneNumber,
        'birthday': user.birthday,
        'profilePic': profilePicUrl,
        'uid': uid,
        'isAviable': user.isAviable,
        'token': user.token,
        'createdAt': DateTime.now().toString(),
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
