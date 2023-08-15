import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AvailabilityRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  Future<bool> getMechanicAvailability() async {
    try {
      final snapshot =
          await firestore.collection('mecanicos').doc(user.uid).get();
      final data = snapshot.data();
      if (data != null && data['isAvailable'] != null) {
        return data['isAvailable'] as bool;
      }
      return false;
    } catch (e) {
      throw Exception('Error al obtener la disponibilidad del mecánico');
    }
  }

  Future<void> updateMechanicAvailability(bool isAvailable) async {
    try {
      await firestore.collection('mecanicos').doc(user.uid).update({
        'isAvailable': isAvailable,
      });
    } catch (e) {
      throw Exception('Error al actualizar el estado del mecánico');
    }
  }
}
