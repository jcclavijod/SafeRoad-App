import 'package:poly_geofence_service/models/poly_geofence.dart';

class Mechanic {
  final String nombre;
  final double latitude;
  final double longitude;
  final PolyGeofence geocerca;

  Mechanic({required this.nombre, required this.latitude, required this.longitude, required this.geocerca});
}