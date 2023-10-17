import 'package:cloud_firestore/cloud_firestore.dart';

class AvailabilityRepository {
  final FirebaseFirestore firestore;
  final user;

  AvailabilityRepository({
    required this.firestore,
    required this.user,
  });

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

  Future<bool> updateMechanicAvailability(bool isAvailable) async {
    try {
      await firestore.collection('mecanicos').doc(user.uid).update({
        'isAvailable': isAvailable,
      });
      return true;
    } catch (e) {
      print('Error al actualizar el estado del mecánico: $e');
      return false;
    }
  }
}
