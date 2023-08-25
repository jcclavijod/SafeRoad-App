import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Auth/model/user_model.dart';
import 'package:intl/intl.dart';

import '../model/Request.dart';

class RequestRepository {
  final _firestoreBd = FirebaseFirestore.instance;
  final _authUser = FirebaseAuth.instance;

  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<bool> createRequest() async {
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
        'requestDetails': "Necesito un mecanico en mi ubicación urgente...",
        'status': 'pending',
        'mecanicoId': 'BEdPsCRFCAegeUUMlZtO1Vw9Unk1',
        'createdAt': {
          'date': formattedDate,
          'time': formattedTime,
        },
      });

      await requestRef.update({'id': requestRef.id});

      return true;
    } catch (e) {
      return false;
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

  Future<LatLng> locationUser() async {
    final user = FirebaseAuth.instance.currentUser!;
    String usuario = await getTypeUser(user.uid);
    DocumentSnapshot? requestDocument;
    LatLng locUser = const LatLng(0, 0);
    if (usuario == "mecanico") {
      requestDocument = await _getRequestUidByField("mecanicoId", user.uid);
    } else if (usuario == "usuario") {
      requestDocument = await _getRequestUidByField("userId", user.uid);
    }
    if (requestDocument != null) {
      GeoPoint? location = requestDocument.get('userLocation') as GeoPoint?;
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
      return mapUser("mecanicos", user.uid);
    } else if (usuario == "usuario") {
      return mapUser("users", user.uid);
    } else {
      return UserModel.complete();
    }
  }

  Future<UserModel> getClient() async {
    final user = FirebaseAuth.instance.currentUser!;
    String usuario = await getTypeUser(user.uid);
    if (usuario == "mecanico") {
      DocumentSnapshot requestDocument =
          await _getRequestUidByField("mecanicoId", user.uid);
      return mapUser('mecanicos', requestDocument.get('mecanicoId'));
    } else if (usuario == "usuario") {
      DocumentSnapshot requestDocument =
          await _getRequestUidByField("userId", user.uid);
      return mapUser('users', requestDocument.get('userId'));
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

  Future<Request> getRequest() async {
    final user = FirebaseAuth.instance.currentUser!;
    String usuario = await getTypeUser(user.uid);
    if (usuario == "usuario") {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'pending')
          .limit(1)
          .get();
      Map<String, dynamic> requestData = querySnapshot.docs.first.data();
      return Request.fromMap(requestData);
    } else if (usuario == "mecanico") {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('mecanicoId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'pending')
          .limit(1)
          .get();
      Map<String, dynamic> requestData = querySnapshot.docs.first.data();
      return Request.fromMap(requestData);
    }
    return Request.complete();
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
}
