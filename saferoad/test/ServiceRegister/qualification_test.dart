import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
// Reemplaza 'my_app' con tu paquete real
import 'package:mockito/mockito.dart';
import 'package:saferoad/Map/Repository/qualificationRepository.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockUser {
  final String uid;

  MockUser(this.uid);
}

void main() {
  group('QualificationRepository Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late QualificationRepository qualificationRepository;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      qualificationRepository = QualificationRepository(
        firestore: fakeFirestore,
        user: MockUser('mockUserId'), // Debes crear tu propia clase MockUser
      );
    });

    test('saveRating returns true on success', () async {
      final result =
          await qualificationRepository.saveRating(4.5, 'mechanic123');
      expect(result, true);
    });

    test('saveRating returns false on failure', () async {
      
      qualificationRepository = QualificationRepository(
        firestore: fakeFirestore,
        user: "",
      );

      final result =
          await qualificationRepository.saveRating(3.0, 'mechanic456');

      expect(result, false);
    });
  });
}
