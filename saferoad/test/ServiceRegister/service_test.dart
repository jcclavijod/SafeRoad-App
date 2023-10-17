import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saferoad/ServiceRegister/Repository/serviceRepository.dart';
import 'package:saferoad/ServiceRegister/model/billItem.dart';
import 'package:saferoad/ServiceRegister/model/service.dart';

class MockUser {
  final String uid;

  MockUser(this.uid);
}

void main() {
  group('ServiceRepository Tests', () {
    late ServiceRepository serviceRepository;
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      serviceRepository = ServiceRepository(
          user: MockUser('mockUserId'), firestore: fakeFirestore);
    });

    test('saveWorkPerformed should save services and return their references',
        () async {
      final localServices = <BillItem>[
        BillItem(name: 'Service 1', value: 100.0),
        BillItem(name: 'Service 2', value: 150.0),
      ];

      final serviceReferences =
          await serviceRepository.saveWorkPerformed(localServices);

      expect(serviceReferences, isList);
      expect(serviceReferences.length, localServices.length);

      final workPerformedCollection = fakeFirestore.collection('workPerformed');

      for (var i = 0; i < localServices.length; i++) {
        final serviceReference = serviceReferences[i];
        final serviceSnapshot =
            await workPerformedCollection.doc(serviceReference).get();
        expect(serviceSnapshot.exists, isTrue);
        final serviceData = serviceSnapshot.data()!;
        expect(serviceData, isMap);
        expect(serviceData['mechanic'], 'mockUserId');
        expect(serviceData['name'], localServices[i].name);
        expect(serviceData['cost'], localServices[i].value);
      }
    });

    test('saveWorkPerformed should handle empty input gracefully', () async {
      final emptyServices = <BillItem>[];
      final serviceReferences =
          await serviceRepository.saveWorkPerformed(emptyServices);
      expect(serviceReferences, isEmpty);
    });

    test('finalizeService should create a service and update the request',
        () async {
      const request = 'request123';
      const total = 250.0;
      final serviceReferences = ['service1', 'service2'];
      await fakeFirestore
          .collection('requests')
          .doc(request)
          .set({'id': request});
      final serviceId = await serviceRepository.finalizeService(
          request, total, serviceReferences);
      final serviceSnapshot =
          await fakeFirestore.collection('services').doc(serviceId).get();
      expect(serviceSnapshot.exists, isTrue);
      final serviceData = serviceSnapshot.data() as Map<String, dynamic>;
      expect(serviceData['totalCost'], total);
      expect(serviceData['worksPerformed'], serviceReferences);
      final requestSnapshot =
          await fakeFirestore.collection('requests').doc(request).get();
      expect(requestSnapshot.exists, isTrue);
      final requestData = requestSnapshot.data() as Map<String, dynamic>;
      expect(requestData['service'], serviceId);
      expect(requestData['status'], 'inCustomerAcceptance');
    });

    test('finalizeService should return the service ID', () async {
      const request = 'request456';
      const total = 300.0;
      final serviceReferences = ['service3', 'service4'];
      await fakeFirestore
          .collection('requests')
          .doc(request)
          .set({'id': request});
      final serviceId = await serviceRepository.finalizeService(
          request, total, serviceReferences);
      expect(serviceId, isNotNull);
      expect(serviceId, isNotEmpty);
    });

    test('getServiceData should return service data when service exists',
        () async {
      const existingServiceId = 'service123';
      final serviceData = Service(
        date: DateTime.now().toString(),
        worksPerformed: ['service1', 'service2'],
        totalCost: 250.0,
        customerAcceptance: 'pending',
      );
      fakeFirestore
          .collection('services')
          .doc(existingServiceId)
          .set(serviceData.toMap());
      final service = await serviceRepository.getServiceData(existingServiceId);
      expect(service, isNotNull);
      expect(service?.date, isA<String>());
      expect(service?.worksPerformed, isList);
      expect(service?.totalCost, 250.0);
      expect(service?.customerAcceptance, 'pending');
    });

    test('getServiceData should return null when service does not exist',
        () async {
      const nonExistentServiceId = 'service456';
      final service =
          await serviceRepository.getServiceData(nonExistentServiceId);
      expect(service, isNull);
    });

    test(
        'getBillItems should return a list of BillItems when workPerformed documents exist',
        () async {
      const documentId1 = 'workPerformed1';
      const documentId2 = 'workPerformed2';

      final billItemData1 = {'name': 'Service 1', 'cost': 100};
      final billItemData2 = {'name': 'Service 2', 'cost': 150};

      await fakeFirestore
          .collection('workPerformed')
          .doc(documentId1)
          .set(billItemData1);
      await fakeFirestore
          .collection('workPerformed')
          .doc(documentId2)
          .set(billItemData2);

      final worksPerformed = [documentId1, documentId2];

     final billItems = await serviceRepository.getBillItems(worksPerformed);

      expect(billItems, isList);
      expect(billItems.length, worksPerformed.length);
      expect(billItems[0].name, billItemData1['name']);
      expect(billItems[0].value, billItemData1['cost']);
      expect(billItems[1].name, billItemData2['name']);
      expect(billItems[1].value, billItemData2['cost']);
    });

    test(
        'getBillItems should return an empty list when workPerformed documents do not exist',
        () async {
      const nonExistentDocumentId = 'nonExistentWorkPerformed';
      final worksPerformed = [nonExistentDocumentId];
      final billItems = await serviceRepository.getBillItems(worksPerformed);
      expect(billItems, isEmpty);
    });
  });
}
