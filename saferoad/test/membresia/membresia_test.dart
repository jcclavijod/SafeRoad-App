import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saferoad/Membresia/model/membresia_model.dart';
import 'package:saferoad/Membresia/repository/membresia_repository.dart';



void main() {
  group('MembresiaRepository Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late MembresiaRepository membresiaRepository;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      membresiaRepository = MembresiaRepository(firestore: fakeFirestore);
    });

    test('getMembresias returns a list of membresias', () async {
      final fakeMembresiasData = [
        {
          'id': '1',
          'nombre': 'Membresia 1',
        },
        {
          'id': '2',
          'nombre': 'Membresia 2',
        },
      ];
      fakeFirestore.collection('membresias').add(fakeMembresiasData[0]);
      fakeFirestore.collection('membresias').add(fakeMembresiasData[1]);
      final result = await membresiaRepository.getMembresias();
      expect(result, hasLength(fakeMembresiasData.length));
    });

    test('getMembresias return an empty list of membresias', () async {
      final result = await membresiaRepository.getMembresias();
      expect(result, isEmpty);
    });

    test('checkActiveMembership returns true when active membership exists',
        () async {
      const uid = 'user123';
      fakeFirestore.collection('membresias').add({
        'uid': uid,
        'estado': 'Activo',
      });
      final result = await membresiaRepository.checkActiveMembership(uid);
      expect(result, isTrue);
    });

    test('checkActiveMembership returns false when no active membership exists',
        () async {
      const uid = 'user456';
      final result = await membresiaRepository.checkActiveMembership(uid);
      expect(result, isFalse);
    });

    test('getActiveMembership returns active membership when it exists',
        () async {
      const uid = 'user123';
      fakeFirestore.collection('membresias').add({
        'uid': uid,
        'estado': 'Activo',
      });

      final activeMembership =
          await membresiaRepository.getActiveMembership(uid);
      expect(activeMembership, isNotNull);
    });

    test(
        'getActiveMembership throws exception when no active membership exists',
        () async {
      const uid = 'user456';
      expect(
          () => membresiaRepository.getActiveMembership(uid), throwsException);
    });

    test('addMembresiaWithCustomId should return true on success', () async {
      const customDocumentId = 'custom123';
      final membresia = membresiaModel(
          // Agrega los datos de la membresía de prueba según tu modelo
          );

      final result = await membresiaRepository.addMembresiaWithCustomId(
          customDocumentId, membresia);

      expect(result, isTrue);
    });

  });
}
