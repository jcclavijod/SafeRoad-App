import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saferoad/Request/model/Request.dart';

class RequestListen {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Request> _requests = [];
  List<Request> get requests => _requests;

  RequestListen() {
    listenToRequests();
  }

  void listenToRequests() {
    _firestore
        .collection('requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _requests =
          snapshot.docs.map((doc) => Request.fromMap(doc.data())).toList();
    });
  }
}
