import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saferoad/Request/model/Request.dart';
import 'package:saferoad/ServiceRegister/model/billItem.dart';
import 'package:saferoad/ServiceRegister/model/service.dart';

class ServiceRepository {
  final user = FirebaseAuth.instance.currentUser!;

  Future<List<String>> saveWorkPerformed(List<BillItem> localServices) async {
    List<String> serviceReferences = [];
    final DateTime currentDate = DateTime.now();
    for (final service in localServices) {
      final workPerformedReference =
          FirebaseFirestore.instance.collection('workPerformed').doc();
      final workPerformedData = {
        'mechanic': user.uid,
        'name': service.name,
        'cost': service.value,
      };
      await workPerformedReference.set(workPerformedData);
      String id = workPerformedReference.id;
      serviceReferences.add(id);
    }
    return serviceReferences;
  }

  Future<String> finalizeService(
      String request, double total, List<String> serviceReferences) async {
    final DateTime currentDate = DateTime.now();
    final serviceReference =
        FirebaseFirestore.instance.collection('services').doc();
    final serviceData = {
      'date': currentDate,
      'worksPerformed': serviceReferences,
      'totalCost': total,
      'customerAcceptance': 'pending',
    };
    await serviceReference.set(serviceData);
    print(request);
    await FirebaseFirestore.instance.collection('requests').doc(request).update(
        {'service': serviceReference.id, 'status': 'inCustomerAcceptance'});
    return serviceReference.id;
  }

  Future<Service?> getServiceData(String serviceId) async {
    print(serviceId);
    print("hola");
    try {
      final DocumentSnapshot serviceSnapshot = await FirebaseFirestore.instance
          .collection('services')
          .doc(serviceId)
          .get();
      if (serviceSnapshot.exists) {
        return Service.fromMap(serviceSnapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error al obtener los datos del servicio: $e');
      throw e;
    }
  }

  Future<List<BillItem>> getBillItems(List<String> worksPerformed) async {
    List<BillItem> billItems = [];

    for (String documentId in worksPerformed) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('workPerformed')
          .doc(documentId)
          .get();

      if (documentSnapshot.exists) {
        BillItem billItem =
            BillItem.fromMap(documentSnapshot.data() as Map<String, dynamic>);
        billItems.add(billItem);
      }
    }

    return billItems;
  }

  void updateStatus(String request) async {
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(request)
        .update({'status': 'inSelectingCause'});
  }
}
