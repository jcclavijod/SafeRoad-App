import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:saferoad/Auth/model/user_model.dart';

class FirebaseDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User get currentUser {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not Authentication exception');
    return user;
  }

  String newId() {
    return _firestore.collection('tmp').doc().id;
  }

  Future<UserModel> getMyUsers() async {
    final user = _auth.currentUser;
    final usuario = await _firestore.collection('users').doc(user?.uid).get();
    final mecanico =
        await _firestore.collection('mecanicos').doc(user?.uid).get();

    if (usuario.exists) {
      Map<String, dynamic> userData = usuario.data() ?? {};
      return UserModel.fromMap(userData);
    } else if (mecanico.exists) {
      Map<String, dynamic> mecanicoData = mecanico.data() ?? {};
      return UserModel.fromMap(mecanicoData);
    } else {
      return UserModel.complete();
    }
  }

  Future<String> getUserType() async {
    String userType = "";
    String userID = _auth.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(userID).get();
    DocumentSnapshot mechanicSnapshot =
        await _firestore.collection('mecanicos').doc(userID).get();

    if (userSnapshot.exists) {
      userType = "user";
    } else if (mechanicSnapshot.exists) {
      userType = "mecanico";
    }

    return userType;
  }

  Future<void> saveMyUser(UserModel myUser, File? image) async {
    final ref = _firestore.doc('user/${currentUser.uid}/myUsers/${myUser.uid}');

    if (image != null) {
      await _storage.refFromURL(myUser.profilePic).delete();

      final fileName = image.uri.pathSegments.last;
      final imagePath = '${currentUser.uid}/myUsersImages/$fileName';

      final storageRef = _storage.ref(imagePath);
      await storageRef.putFile(image);
      final url = await storageRef.getDownloadURL();

      final updatedUser = myUser.copyWith(profilePic: url);
      await ref.set(updatedUser.toMap(), SetOptions(merge: true));
    } else {
      await ref.set(myUser.toMap(), SetOptions(merge: true));
    }
  }

  Future<void> deleteMyUser(UserModel myUser) async {
    final ref = _firestore.doc('user/${currentUser.uid}/myUsers/${myUser.uid}');
    await _storage.refFromURL(myUser.profilePic).delete();
    await ref.delete();
  }
}
