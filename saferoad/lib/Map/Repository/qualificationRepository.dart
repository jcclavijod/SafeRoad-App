import 'package:cloud_firestore/cloud_firestore.dart';

class QualificationRepository {
  final FirebaseFirestore firestore;
  final user;

  QualificationRepository({
    required this.firestore,
    required this.user,
  });

  Future<bool> saveRating(
    double rating,
    String receiverUid,
    String mechanicId,
  ) async {
    print("HOLAAAAAAAAAAAAAA");
    print(receiverUid);
    print(mechanicId);
    print(rating);
    try {
      final ratingData = {
        'qualification': rating,
        'user': receiverUid,
        'mechanicId': mechanicId,
        'date': Timestamp.now(),
      };

      await firestore.collection('mechanicQualifications').add(ratingData);

      return true;
    } catch (error) {
      return false;
    }
  }
}
