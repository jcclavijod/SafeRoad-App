import 'dart:ffi';
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

  Future<UserModel> getMyUsers() async {
    final user = FirebaseAuth.instance.currentUser!;
    final usuario = await firestore.collection('users').doc(user.uid).get();
    final mecanico =
        await firestore.collection('mecanicos').doc(user.uid).get();
    if (usuario.exists) {
      // El usuario autenticado se encuentra en la colección de usuarios
      Map<String, dynamic> userData = usuario.data() ?? {};
      return UserModel.fromMap(userData);
    } else if (mecanico.exists) {
      // El usuario autenticado se encuentra en la colección de mecánicos
      Map<String, dynamic> mecanicoData = mecanico.data() ?? {};
      return UserModel.fromMap(mecanicoData);
    } else {
      // El usuario autenticado no se encuentra en ninguna colección
      return UserModel.complete();
    }
  }

  Future<String> getUserType() async {
    String userType = "";
    String userID = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    DocumentSnapshot mechanicSnapshot = await FirebaseFirestore.instance
        .collection('mecanicos')
        .doc(userID)
        .get();

    if (userSnapshot.exists) {
      userType = "user";
    } else if (mechanicSnapshot.exists) {
      userType = "mecanico";
    }

    return userType;
  }

  Future<void> saveMyUser(UserModel myUser, File? image) async {
    final ref = firestore.doc('user/${currentUser.uid}/myUsers/${myUser.uid}');
    if (image != null) {
      await storage.refFromURL(myUser.profilePic).delete();

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
    await storage.refFromURL(myUser.profilePic).delete();
    await ref.delete();
  }
}
