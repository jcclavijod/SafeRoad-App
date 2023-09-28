// ignore_for_file: file_names, use_rethrow_when_possible, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginMecanicoRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  LoginMecanicoRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> signInWithEmailAndPasswordMecanico(
      String mail, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: mail,
        password: password,
      );
      /*
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await _updateUserActiveStatus(user.uid, true);
        await _firebaseAuth.signOut();
        print('El mecanico ${user.email} ha salido.');
      }
      */
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          throw Exception('Usuario no encontrado');
        } else if (e.code == 'wrong-password') {
          throw Exception('Contraseña incorrecta');
        }
      }
      throw e;
    }
  }

  Future<void> signOut() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await _updateUserActiveStatus(user.uid, false);
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
      await _firestore.collection('mecanicos').doc(userId).update({
        'isAviable': isAviable,
      });
    } catch (e) {
      throw e;
    }
  }
}
