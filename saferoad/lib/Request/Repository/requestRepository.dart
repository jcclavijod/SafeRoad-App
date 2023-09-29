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
  final _firestoreBd = FirebaseFirestore.instance;
  final _authUser = FirebaseAuth.instance;

  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String> createRequest(String problem) async {
    try {
      final requestRef = _firestoreBd.collection('requests').doc();
      final user = _authUser.currentUser;
      final location = await Geolocator.getCurrentPosition();
      final userLocation = GeoPoint(location.latitude, location.longitude);
      final DateTime now = DateTime.now();
      final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      final String formattedTime = DateFormat('HH:mm:ss').format(now);

      await requestRef.set({
        'userId': user?.uid,
        'userLocation': userLocation,
        'requestDetails': problem,
        'status': 'pending',
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

  Future<String> getAddressFromCoordinates() async {
    final user = FirebaseAuth.instance.currentUser;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('mecanicoId', isEqualTo: user?.uid)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();

    DocumentSnapshot requestDocument = querySnapshot.docs.first;
    GeoPoint? location = requestDocument.get('userLocation') as GeoPoint?;
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location!.latitude, location.longitude);
    Placemark placemark = placemarks.first;

    String address =
        '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}';
    return address;
  }

  Future<void> updateRequestStatus(String newStatus) async {
    final user = FirebaseAuth.instance.currentUser;
    final location = await Geolocator.getCurrentPosition();
    final userLocation = GeoPoint(location.latitude, location.longitude);
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('mecanicoId', isEqualTo: user?.uid)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot requestDocument = querySnapshot.docs.first;
      String requestId = requestDocument.id;
      if (newStatus == "inProcess") {
        await FirebaseFirestore.instance
            .collection('requests')
            .doc(requestId)
            .update({'status': newStatus, 'mechanicLocation': userLocation});
      } else {
        await FirebaseFirestore.instance
            .collection('requests')
            .doc(requestId)
            .update({'status': newStatus});
      }
    }
  }

  Future<void> cancelRequest(String newStatus) async {
    final user = FirebaseAuth.instance.currentUser;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('userId', isEqualTo: user?.uid)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot requestDocument = querySnapshot.docs.first;
      String requestId = requestDocument.id;

      await FirebaseFirestore.instance
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
      print("UBICACION PARA EL MECANICO...........");
      print(locUser);
    }
    return locUser;
  }

  Future<LatLng> locationMechanic() async {
    final user = FirebaseAuth.instance.currentUser!;
    LatLng locUser = const LatLng(0, 0);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
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

  Future<UserModel> getUser() async {
    final user = FirebaseAuth.instance.currentUser!;
    String usuario = await getTypeUser(user.uid);
    if (usuario == "mecanico") {
      return await mapUser("mecanicos", user.uid);
    } else if (usuario == "usuario") {
      return await mapUser("users", user.uid);
    } else {
      return UserModel.complete();
    }
  }

  Future<UserModel> getClient(Request request) async {
    final user = FirebaseAuth.instance.currentUser!;
    String usuario = await getTypeUser(user.uid);
    if (usuario == "mecanico") {
      return await mapUser('users', request.userId);
    } else if (usuario == "usuario") {
      print("VERIFICANDO LOS NUEVOS DATOS DEL MECANICO :: GET CLIENTE");
      print(request.mechanicId);
      return await mapUser('mecanicos', request.mechanicId);
    } else {
      return UserModel.complete();
    }
  }

  Future<List<DocumentSnapshot>> getFinishedRequests() async {
    final user = FirebaseAuth.instance.currentUser!;
    try {
      QuerySnapshot querySnapshot = await _firestoreBd
          .collection('requests')
          .where('mecanicoId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'finished')
          .orderBy('createdAt', descending: true)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      print("Error: No se pudieron traer las requests finalizadas: $e");
      return [];
    }
  }

  Future<DocumentReference> getRequest(Request request) async {
    final docReference =
        FirebaseFirestore.instance.collection('requests').doc(request.id);
    return docReference;
  }

  Future<String> getTypeUser(String uid) async {
    final usuario = await _firestoreBd.collection('users').doc(uid).get();
    final mecanico = await _firestoreBd.collection('mecanicos').doc(uid).get();
    if (usuario.exists) {
      return "usuario";
    } else if (mecanico.exists) {
      return "mecanico";
    }
    return "";
  }

  Future<DocumentSnapshot> _getRequestUidByField(
      String field, String uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where(field, isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();
    return querySnapshot.docs.first;
  }

  Future<UserModel> mapUser(String coleccion, final doc) async {
    final usuario =
        await FirebaseFirestore.instance.collection(coleccion).doc(doc).get();
    Map<String, dynamic> userData = usuario.data() ?? {};
    return UserModel.fromMap(userData);
  }

  Future<Request> getRequestNotification(String uidRequest) async {
    DocumentSnapshot documentSnapshot =
        await _firestoreBd.collection('requests').doc(uidRequest).get();

    if (documentSnapshot.exists) {
      // El documento existe, obtenemos los datos y los asignamos al modelo.
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
    print("ulala ulala ulala ulala ulala ulala ualala");
    print(request);
    DocumentSnapshot querySnapshot =
        await _firestoreBd.collection('requests').doc(request).get();
    if (newStatus == "inProcess") {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(request)
          .update({
        'status': newStatus,
        'mechanicLocation': userLocation,
        'mechanicId': _authUser.currentUser!.uid
      });
    }
  }

  String serverToken =
      'key=AAAA6e_msQo:APA91bHbH6T_3gSc_e7xt-mzenG0M7XGeagDSlzc4XqkUWx-ve8wG0ibmav1PTWl55mGT2XnQByOi3lWW7ojk6JWDL2rOn0SYr2hk8Lv5gd9F28IbjyVdrRTTfqie73Fl2iX2UcFjwFH';

  void sendNotificationToDriver(
      String token, String requestId, String problem) async {
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
