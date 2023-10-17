import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:saferoad/Auth/model/usuario_model.dart';
import '../model/Request.dart';

class RequestRepository {
  final FirebaseFirestore firestoreBd;
  final user;

  RequestRepository({
      required this.firestoreBd,
      required this.user,
    });

  Future<String> createRequest(String problem) async {
    try {
      final requestRef = firestoreBd.collection('requests').doc();
      final location = await Geolocator.getCurrentPosition();
      final userLocation = GeoPoint(location.latitude, location.longitude);
      final String address = await getAddress(userLocation);
      final DateTime now = DateTime.now();
      final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      final String formattedTime = DateFormat('HH:mm:ss').format(now);

      await requestRef.set({
        'userId': user?.uid,
        'userLocation': userLocation,
        'requestDetails': problem,
        'status': 'pending',
        'userAddress': address,
        'createdAt': {
          'date': formattedDate,
          'time': formattedTime,
        },
      });

      await requestRef.update({'id': requestRef.id});

      return requestRef.id;
    } catch (e) {
      return "No se pudo crear la request";
    }
  }

  Future<void> updateRequestStatus(String newStatus) async {
    final location = await Geolocator.getCurrentPosition();
    final userLocation = GeoPoint(location.latitude, location.longitude);
    QuerySnapshot querySnapshot = await firestoreBd
        .collection('requests')
        .where('mecanicoId', isEqualTo: user?.uid)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot requestDocument = querySnapshot.docs.first;
      String requestId = requestDocument.id;
      if (newStatus == "inProcess") {
        await firestoreBd
            .collection('requests')
            .doc(requestId)
            .update({'status': newStatus, 'mechanicLocation': userLocation});
      } else {
        await firestoreBd
            .collection('requests')
            .doc(requestId)
            .update({'status': newStatus});
      }
    }
  }

  Future<void> cancelRequest(String newStatus) async {
    QuerySnapshot querySnapshot = await firestoreBd
        .collection('requests')
        .where('userId', isEqualTo: user?.uid)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot requestDocument = querySnapshot.docs.first;
      String requestId = requestDocument.id;

      await firestoreBd
          .collection('requests')
          .doc(requestId)
          .update({'status': newStatus});
    }
  }

  Future<LatLng> locationUser(Request request) async {
    LatLng locUser = const LatLng(0, 0);
    if (request.userLocation != null) {
      GeoPoint? location = request.userLocation;
      locUser = convertGeoPointToLatLng(location);
    }
    return locUser;
  }

  Future<LatLng> locationMechanic(Request request) async {
    LatLng locUser = const LatLng(0, 0);
    QuerySnapshot querySnapshot = await firestoreBd
        .collection('requests')
        .where("userId", isEqualTo: user.uid)
        .where('status', isEqualTo: 'inProcess')
        .limit(1)
        .get();
    GeoPoint? location =
        querySnapshot.docs.first.get('mechanicLocation') as GeoPoint?;
    locUser = convertGeoPointToLatLng(location);
    return locUser;
  }

  LatLng convertGeoPointToLatLng(GeoPoint? geoPoint) {
    return LatLng(geoPoint!.latitude, geoPoint.longitude);
  }

  Future<UserModel> getUser(Request request) async {
    bool activateWiew = user.uid == request.userId;
    String usuario = await getTypeUser(activateWiew);
    if (usuario == "mecanico") {
      return await mapUser("mecanicos", user.uid);
    } else if (usuario == "usuario") {
      return await mapUser("users", user.uid);
    } else {
      return UserModel.complete();
    }
  }

  Future<UserModel> getClient(Request request) async {
    bool activateWiew = user.uid == request.userId;
    String usuario = await getTypeUser(activateWiew);
    if (usuario == "mecanico") {
      return await mapUser('users', request.userId);
    } else if (usuario == "usuario") {
      return await mapUser('mecanicos', request.mechanicId);
    } else {
      return UserModel.complete();
    }
  }

  Stream<List<Request>> getMechanicRequests() {
    try {
      return firestoreBd
          .collection('requests')
          .where('mechanicId', isEqualTo: user.uid)
          .where('status', whereNotIn: ['pending', 'rejected'])
          .orderBy('status')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((querySnapshot) {
            List<Request> requests = [];
            for (DocumentSnapshot doc in querySnapshot.docs) {
              Request request =
                  Request.fromMap(doc.data() as Map<String, dynamic>);
              print(request.status);
              requests.add(request);
            }
            return requests;
          })
          .distinct(); 
    } catch (e) {
      print("Error: No se pudieron traer las requests finalizadas: $e");
      return Stream.error(e);
    }
  }

  Stream<List<Request>> getUserRequests() {
    try {
      return firestoreBd
          .collection('requests')
          .where('userId', isEqualTo: user.uid)
          .where('status', whereNotIn: ['pending', 'rejected'])
          .orderBy('status')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((querySnapshot) {
            List<Request> requests = [];
            for (DocumentSnapshot doc in querySnapshot.docs) {
              Request request =
                  Request.fromMap(doc.data() as Map<String, dynamic>);
              requests.add(request);
            }
            return requests;
          })
          .distinct(); 
    } catch (e) {
      print("Error: No se pudieron traer las requests finalizadas: $e");
      return Stream.error(e);
    }
  }

  Future<DocumentReference> getRequest(Request request) async {
    final docReference =
        firestoreBd.collection('requests').doc(request.id);
    return docReference;
  }

  Future<String> getTypeUser(bool uid) async {
     if (uid) {
      return "usuario";
    } else if (!uid) {
      return "mecanico";
    }
    return "";
  }

  Future<UserModel> mapUser(String coleccion, final doc) async {
    final usuario =
        await firestoreBd.collection(coleccion).doc(doc).get();
    Map<String, dynamic> userData = usuario.data() ?? {};
    return UserModel.fromMap(userData);
  }

  Future<Request> getRequestNotification(String uidRequest) async {
    DocumentSnapshot documentSnapshot =
        await firestoreBd.collection('requests').doc(uidRequest).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      return Request.fromMap(data);
    } else {
      return Request.complete();
    }
  }

  Future<String> getAddress(location) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location!.latitude, location.longitude);
    Placemark placemark = placemarks.first;

    String address =
        '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}';
    return address;
  }

  Future<void> updateRequestStatusMessaging(
      String newStatus, String request) async {
    final location = await Geolocator.getCurrentPosition();
    final userLocation = GeoPoint(location.latitude, location.longitude);
    if (newStatus == "inProcess") {
      await firestoreBd
          .collection('requests')
          .doc(request)
          .update({
        'status': newStatus,
        'mechanicLocation': userLocation,
        'mechanicId': user.uid
      
      });
    }
  }

  String serverToken =
      'key=AAAA6e_msQo:APA91bHbH6T_3gSc_e7xt-mzenG0M7XGeagDSlzc4XqkUWx-ve8wG0ibmav1PTWl55mGT2XnQByOi3lWW7ojk6JWDL2rOn0SYr2hk8Lv5gd9F28IbjyVdrRTTfqie73Fl2iX2UcFjwFH';

  void sendNotificationToDriver(
      String token, String requestId, String problem, String address) async {
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverToken,
    };
    Map notificationMap = {
      'body': problem,
      'title': 'Nuevo Servicio',
    };
    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'request_id': requestId,
      'address': address,
      'type': "request",
    };
    Map sendNotificationMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token,
    };
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );
  }
}
