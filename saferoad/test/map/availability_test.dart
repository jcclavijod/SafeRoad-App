import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:saferoad/Map/Repository/availabilityRepository.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockUser {
  final String uid;

  MockUser(this.uid);
}

void main() {
  group('AvailabilityRepository Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late AvailabilityRepository availabilityRepository;
    final mockUser = MockUser('mockUserId');

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      availabilityRepository = AvailabilityRepository(
        firestore: fakeFirestore,
        user: mockUser,
      );
    });

    test('getMechanicAvailability returns true when isAvailable is true',
        () async {
      final mockData = {
        'isAvailable': true,
      };

      final mockDocumentReference =
          fakeFirestore.collection('mecanicos').doc(mockUser.uid);

      await mockDocumentReference.set(mockData);

      final result = await availabilityRepository.getMechanicAvailability();
      expect(result, true);
    });

    test('getMechanicAvailability returns false when isAvailable is false',
        () async {
      final mockData = {
        'isAvailable': false,
      };
      final mockDocumentReference =
          fakeFirestore.collection('mecanicos').doc(mockUser.uid);
      await mockDocumentReference.set(mockData);
      final result = await availabilityRepository.getMechanicAvailability();
      expect(result, false);
    });

    test('getMechanicAvailability returns false when data is null', () async {
      final mockDocumentReference =
          fakeFirestore.collection('mecanicos').doc(mockUser.uid);

      await mockDocumentReference.set({});

      final result = await availabilityRepository.getMechanicAvailability();
      expect(result, false);
    });

    test('updateMechanicAvailability updates Firestore correctly', () async {
      const isAvailable = true;
      final mockData = {
        'isAvailable': false,
      };
      final mockDocumentReference =
          fakeFirestore.collection('mecanicos').doc(mockUser.uid);
      await mockDocumentReference.set(mockData);
      final result =
          await availabilityRepository.updateMechanicAvailability(isAvailable);
      expect(result, true);
    });

    test('updateMechanicAvailability returns false when update fails',
        () async {
      const isAvailable = true;

      final result =
          await availabilityRepository.updateMechanicAvailability(isAvailable);

      expect(result, false);
    });
  });
}
