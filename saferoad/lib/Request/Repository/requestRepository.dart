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

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<DocumentSnapshot>> findNearbyMechanics(GeoPoint ubicacion) async {
    final querySnapshot = await _firestoreBd
        .collection('mecanicos')
        .where('ubicacion',
            isGreaterThan: GeoPoint(
                ubicacion.latitude - 0.018, ubicacion.longitude - 0.018))
        .where('ubicacion',
            isLessThan: GeoPoint(
                ubicacion.latitude + 0.018, ubicacion.longitude + 0.018))
        .orderBy('ubicacion', descending: false)
        .limit(10)
        .get();

    return querySnapshot.docs;
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

      // Actualizar el estado de la solicitud a "rejected"
      if (newStatus == "accepted") {
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
    } // Guardar la solicitud actualizada en la base de datos
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

      // Actualizar el estado de la solicitud a "rejected"

      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .update({'status': newStatus});
    } // Guardar la solicitud actualizada en la base de datos
  }

  Future<LatLng> locationUser() async {
    final user = FirebaseAuth.instance.currentUser;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('mecanicoId', isEqualTo: user?.uid)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();

    DocumentSnapshot requestDocument = querySnapshot.docs.first;
    GeoPoint? location = requestDocument.get('userLocation') as GeoPoint?;

    LatLng locUser = convertGeoPointToLatLng(location);
    return locUser; // Guardar la solicitud actualizada en la base de datos
  }


  Future<LatLng> locationUserUSUARIO() async {
    final user = FirebaseAuth.instance.currentUser;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('userId', isEqualTo: user?.uid)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();

    DocumentSnapshot requestDocument = querySnapshot.docs.first;
    GeoPoint? location = requestDocument.get('userLocation') as GeoPoint?;

    LatLng locUser = convertGeoPointToLatLng(location);
    return locUser; // Guardar la solicitud actualizada en la base de datos
  }

  LatLng convertGeoPointToLatLng(GeoPoint? geoPoint) {
    return LatLng(geoPoint!.latitude, geoPoint.longitude);
  }

  Future<UserModel> getUserAuthMech() async {
    final user = FirebaseAuth.instance.currentUser!;
    final mecanico = await FirebaseFirestore.instance
        .collection('mecanicos')
        .doc(user.uid)
        .get();
    if (mecanico.exists) {
      // El usuario autenticado se encuentra en la colección de mecánicos
      Map<String, dynamic> mecanicoData = mecanico.data() ?? {};
      return UserModel.fromMap(mecanicoData);
    } else {
      // El usuario autenticado no se encuentra en ninguna colección
      return UserModel.complete();
    }
  }


   Future<UserModel> getUserAuth() async {
    final user = FirebaseAuth.instance.currentUser!;
    final users = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (users.exists) {
      // El usuario autenticado se encuentra en la colección de mecánicos
      Map<String, dynamic> mecanicoData = users.data() ?? {};
      return UserModel.fromMap(mecanicoData);
    } else {
      // El usuario autenticado no se encuentra en ninguna colección
      return UserModel.complete();
    }
  }

  Future<UserModel> getClient() async {
    final user = FirebaseAuth.instance.currentUser!;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('mecanicoId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();

    DocumentSnapshot requestDocument = querySnapshot.docs.first;
    String? uid = requestDocument.get('userId');
    final usuario =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (usuario.exists) {
      // El usuario autenticado se encuentra en la colección de usuarios
      Map<String, dynamic> userData = usuario.data() ?? {};
      return UserModel.fromMap(userData);
    } else {
      // El usuario autenticado no se encuentra en ninguna colección
      return UserModel.complete();
    }
  }

  Future<UserModel> getClientMECANICO() async {
    final user = FirebaseAuth.instance.currentUser!;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('userId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();

    DocumentSnapshot requestDocument = querySnapshot.docs.first;
    String? uid = requestDocument.get('mecanicoId');
    final usuario =
        await FirebaseFirestore.instance.collection('mecanicos').doc(uid).get();
    if (usuario.exists) {
      // El usuario autenticado se encuentra en la colección de usuarios
      Map<String, dynamic> userData = usuario.data() ?? {};
      return UserModel.fromMap(userData);
    } else {
      // El usuario autenticado no se encuentra en ninguna colección
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
}
