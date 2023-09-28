// ignore_for_file: avoid_print, use_rethrow_when_possible
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:saferoad/Auth/model/mecanico_model.dart';
import 'dart:io';

class RegisterRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final firebase_storage.FirebaseStorage _firebaseStorage;

  RegisterRepository(
      {FirebaseAuth? firebaseAuth,
      FirebaseFirestore? firestore,
      firebase_storage.FirebaseStorage? firebaseStorage})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseStorage =
            firebaseStorage ?? firebase_storage.FirebaseStorage.instance;

  Future<void> registerMecanico(
      MecanicoModel mecanico, File profilePic, File voucher) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: mecanico.mail,
        password: mecanico.password,
      );
      String uid = userCredential.user!.uid;

      await _firebaseStorage
          .ref('mecanicos/${userCredential.user!.uid}/profilePic')
          .putFile(profilePic);

      String profilePicUrl = await _firebaseStorage
          .ref('mecanicos/${userCredential.user!.uid}/profilePic')
          .getDownloadURL();

      await _firebaseStorage
          .ref('mecanicos/${userCredential.user!.uid}/voucher')
          .putFile(voucher);

      String voucherUrl = await _firebaseStorage
          .ref('mecanicos/${userCredential.user!.uid}/voucher')
          .getDownloadURL();

      await _firestore
          .collection('mecanicos')
          .doc(userCredential.user!.uid)
          .set({
        'name': mecanico.name,
        'lastname': mecanico.lastname,
        'mail': mecanico.mail,
        'local': mecanico.local,
        'address': mecanico.address,
        'password': mecanico.password,
        'identification': mecanico.identification,
        'gender': mecanico.gender,
        'phoneNumber': mecanico.phoneNumber,
        'birthday': mecanico.birthday,
        'profilePic': profilePicUrl,
        'voucher': voucherUrl,
        'calification': mecanico.calification,
        'uid': uid,
        'token': mecanico.token,
        'isAviable': mecanico.isAviable,
        'position': {
          'geohash': mecanico.position.geohash,
          'geopoint': mecanico.position.geopoint,
        },
        'createdAt': DateTime.now()
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
