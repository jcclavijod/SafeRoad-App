import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saferoad/Request/model/Request.dart';
import 'package:saferoad/ServiceRegister/model/billItem.dart';
import 'package:saferoad/ServiceRegister/model/causeFailure.dart';

class CauseFailureRepository {
  final causeFailureInstance;

  CauseFailureRepository({
    required this.causeFailureInstance,
  });

  Future<List<CauseOfFailure>> fetchCausesOfFailure() async {
    final querySnapshot =
        await causeFailureInstance.collection('CauseOfFailures').get();
    final causes = <CauseOfFailure>[];

    for (final doc in querySnapshot.docs) {
      final causeData = doc.data();
      causes.add(CauseOfFailure.fromMap({
        'id': causeData['id'],
        'name': causeData['name'],
      }));
    }
    return causes;
  }

  void addCauseFailure(String request, String causeId) async {
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(request)
        .update({'causeFailure': causeId, 'status': 'finished'});
  }
}
