import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saferoad/ServiceRegister/Repository/causeFailuresRepository.dart';
import 'package:saferoad/ServiceRegister/model/causeFailure.dart';

class MockUser {
  final String uid;

  MockUser(this.uid);
}

void main() {
  group('CauseFailureRepository Tests', () {
    late CauseFailureRepository causeFailureRepository;
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      causeFailureRepository = CauseFailureRepository(causeFailureInstance: fakeFirestore);
    });

    test('fetchCausesOfFailure should return a list of CauseOfFailure', () async {
  final causeData1 = {'id': 'numeroId1', 'name': 'Cause 1'};
  final causeData2 = {'id': 'numeroId2', 'name': 'Cause 2'};

  fakeFirestore.collection('CauseOfFailures').doc('cause1').set(causeData1);
  fakeFirestore.collection('CauseOfFailures').doc('cause2').set(causeData2);

  final List<CauseOfFailure> causes = await causeFailureRepository.fetchCausesOfFailure(); // Espera la respuesta asíncrona

  expect(causes, isA<List<CauseOfFailure>>); // Comprueba que sea una lista de CauseOfFailure

  expect(causes.length, 2);

  expect(causes[0].id, causeData1['id']);
  expect(causes[0].name, causeData1['name']);
  expect(causes[1].id, causeData2['id']);
  expect(causes[1].name, causeData2['name']);
});


    test('fetchCausesOfFailure should return an empty list when no causes exist', () async {
      // Llama a la función fetchCausesOfFailure cuando no hay causas de falla en Firestore
      final causes = await causeFailureRepository.fetchCausesOfFailure();

      // Verifica que la función retorne una lista vacía
      expect(causes, isEmpty);
    });

/*
    test('addCauseFailure should update the request document', () async {
      // Define un ID de solicitud y un ID de causa de falla ficticios
      const request = 'fakeRequestId';
      const causeId = 'fakeCauseId';

      // Llama a la función addCauseFailure
      await causeFailureRepository.addCauseFailure(request, causeId);

      // Verifica que la función haya llamado correctamente a la función update en Firestore
      verify(fakeFirestore.collection('requests').doc(request).update({
        'causeFailure': causeId,
        'status': 'finished',
      })).called(1);
    });

    test('addCauseFailure should throw an exception when an error occurs', () {
      // Simula un error al actualizar el documento de solicitud en Firestore
      when(fakeFirestore.collection('requests').doc(any).update(any))
          .thenAnswer((_) => throw Exception('Simulated Error'));

      // Define un ID de solicitud y un ID de causa de falla ficticios
      const request = 'fakeRequestId';
      const causeId = 'fakeCauseId';

      // Llama a la función addCauseFailure y verifica que reemplace la excepción
      expect(() => causeFailureRepository.addCauseFailure(request, causeId), throwsException);
    });*/
  });
}