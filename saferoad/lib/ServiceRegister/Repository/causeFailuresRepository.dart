import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saferoad/Request/model/Request.dart';
import 'package:saferoad/ServiceRegister/model/billItem.dart';
import 'package:saferoad/ServiceRegister/model/causeFailure.dart';

class CauseFailureRepository {
  final causeFailureInstance =
      FirebaseFirestore.instance.collection('CauseOfFailures');

  Future<List<CauseOfFailure>> fetchCausesOfFailure() async {
    final querySnapshot = await causeFailureInstance.get();
    return querySnapshot.docs.map((doc) {
      final causeData = doc.data();
      print(causeData['name']);
      return CauseOfFailure.fromMap({
        'id': causeData['id'],
        'name': causeData['name'],
      });
    }).toList();
  }

  void addCauseFailure(String request, String causeId) async {
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(request)
        .update({'causeFailure': causeId, 'status': 'finished'});
  }
}
