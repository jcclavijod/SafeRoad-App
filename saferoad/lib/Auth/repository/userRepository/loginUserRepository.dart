// ignore_for_file: file_names, use_rethrow_when_possible
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  LoginRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await _updateUserActiveStatus(user.uid, true);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await _updateUserActiveStatus(user.uid, true);
      }
      await _firebaseAuth.signOut();
    } catch (e) {
      throw e;
    }
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  bool isUserSignedIn() {
    return _firebaseAuth.currentUser != null;
  }

  Future<void> _updateUserActiveStatus(String userId, bool isAviable) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'isAviable': isAviable,
      });
    } catch (e) {
      throw e;
    }
  }
}
