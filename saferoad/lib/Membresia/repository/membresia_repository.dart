// ignore_for_file: avoid_print, unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saferoad/Membresia/model/membresia_model.dart';

class MembresiaRepository {
  final FirebaseFirestore firestore;

  MembresiaRepository({
    required this.firestore,
  });

  Future<void> addMembresia(membresiaModel membresia) async {
    try {
      await firestore.collection('membresias').add(membresia.toMap());
    } catch (e) {
      print("Error adding membresia: $e");
    }
  }

  Future<bool> addMembresiaWithCustomId(
      String documentId, membresiaModel membresia) async {
    try {
      await firestore
          .collection('membresias')
          .doc(documentId)
          .set(membresia.toMap());
      return true;
    } catch (e) {
      print("Error adding membresia with custom ID: $e");
      return false;
    }
  }

  Future<List<membresiaModel>> getMembresias() async {
    List<membresiaModel> membresias = [];

    try {
      QuerySnapshot querySnapshot =
          await firestore.collection('membresias').get();

      for (var doc in querySnapshot.docs) {
        membresias
            .add(membresiaModel.fromMap(doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
      print("Error getting membresias: $e");
    }

    return membresias;
  }

  Future<bool> checkActiveMembership(String uid) async {
    try {
      final membershipsSnapshot = await firestore
          .collection('membresias')
          .where('uid', isEqualTo: uid)
          .where('estado', isEqualTo: 'Activo')
          .get();

      return membershipsSnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking active membership: $e');
      return false;
    }
  }

  Future<membresiaModel> getActiveMembership(String uid) async {
    try {
      final membershipsSnapshot = await firestore
          .collection('membresias')
          .where('uid', isEqualTo: uid)
          .where('estado', isEqualTo: 'Activo')
          .get();

      if (membershipsSnapshot.docs.isNotEmpty) {
        return membresiaModel.fromMap(
            membershipsSnapshot.docs[0].data() as Map<String, dynamic>);
      } else {
        throw Exception('No se encontró una membresía activa.');
      }
    } catch (e) {
      print('Error obteniendo la membresía activa: $e');
      rethrow;
    }
  }
}
