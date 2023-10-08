import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saferoad/Request/model/Request.dart';

class RequestProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Request> _requests = [];

  List<Request> get requests => _requests;

  // Método para escuchar cambios en la colección de solicitudes
  void listenToRequests() {
    _firestore
        .collection('requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _requests = snapshot.docs
          .map((doc) => Request.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      notifyListeners(); // Notifica a los oyentes cuando cambian las solicitudes
    });
  }
}
