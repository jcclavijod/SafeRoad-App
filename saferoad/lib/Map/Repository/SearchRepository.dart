import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as ma;
import 'package:saferoad/Request/model/Request.dart';

class SearchRepository {
  final geo = GeoFlutterFire();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;



  List<LatLng> nearbyPointsFunc(
      List<LatLng> points, double distanceInMetersMax, LatLng location) {
    List<LatLng> nearbyPoints = [];
    for (final point in points) {
      double distanceInMeters = Geolocator.distanceBetween(
        point.latitude,
        point.longitude,
        location.latitude,
        location.longitude,
      );

      if (distanceInMeters <= distanceInMetersMax) {
        nearbyPoints.add(point);
      }
    }
    return nearbyPoints;
  }

  Future<List<DocumentSnapshot>> mechanicNearby(
      ma.LatLng location, double radius) async {
    GeoFirePoint center =
        geo.point(latitude: location.latitude, longitude: location.longitude);
    var collectionReference = firestore.collection('mecanicos');
    Query collectionQuery =
        collectionReference.where('isAvailable', isEqualTo: true);
    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: collectionQuery)
        .within(center: center, radius: radius, field: "position");
    List<DocumentSnapshot> nearbyMechanics = await stream.first;
    return verifyInRange(nearbyMechanics, location, radius);
  }

  Future<List<DocumentSnapshot>> verifyInRange(
      List<DocumentSnapshot> list, ma.LatLng location, double radius) async {
    List<DocumentSnapshot> filteredMechanics = [];
    for (DocumentSnapshot punto in list) {
      GeoPoint geoPoint = punto.get('position')['geopoint'];
      double distanceInMeters = Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        geoPoint.latitude,
        geoPoint.longitude,
      );

      if (distanceInMeters <= radius * 1000) {
        filteredMechanics.add(punto);
      }
    }
    return filteredMechanics;
  }

  Stream<ma.LatLng> watchMechanicLocationChanges(
      Request? request, ma.LatLng location) {
    return firestore
        .collection('requests')
        .doc(request!.id)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final mechanicLocation = snapshot.get('mechanicLocation') as GeoPoint;
        return ma.LatLng(mechanicLocation.latitude, mechanicLocation.longitude);
      } else {
        return location;
      }
    });
  }

  Future<void> updateRequestMechanicLocation(
      Request? request, ma.LatLng newLocation) async {
    final newGeoPoint = GeoPoint(newLocation.latitude, newLocation.longitude);

    await firestore
        .collection('requests')
        .doc(request!
            .id) // Aquí asumo que el objeto Request tiene un atributo "id"
        .update({'mechanicLocation': newGeoPoint});
  }

  Future<String> getTypeUser() async {
    final usuario = await firestore.collection('users').doc(user.uid).get();
    final mecanico =
        await firestore.collection('mecanicos').doc(user.uid).get();
    if (usuario.exists) {
      return "usuario";
    } else if (mecanico.exists) {
      return "mecanico";
    }
    return "";
  }

  void changeStatusRequest(String requestId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(requestId)
        .update({
      'status': newStatus,
    });
  }

  Stream<DocumentSnapshot> listenToMechanicChanges(String mechanicId) {
    return firestore.collection('mecanicos').doc(mechanicId).snapshots();
  }
}
