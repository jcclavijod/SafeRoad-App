import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QualificationRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  Future<void> saveRating(double rating, String mechanicId) async {
  try {
    final ratingData = {
      'qualification': rating,
      'user': user.uid,
      'mechanicId': mechanicId,
      'date': Timestamp.now(),
    };

    await FirebaseFirestore.instance.collection('mechanicQualifications').add(ratingData);
  } catch (error) {
    throw Exception('Error al guardar la calificación: $error');
  }
}


}
