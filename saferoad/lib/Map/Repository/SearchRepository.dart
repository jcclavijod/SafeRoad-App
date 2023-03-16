import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart';
import 'package:saferoad/Map/model/mechanicLocation.dart';

class SearchRepository {
  StreamSubscription<Position>? _positionSubscription;

  // Create a [PolyGeofenceService] instance and set options.
  final _polyGeofenceService = PolyGeofenceService.instance.setup(
      interval: 5000,
      accuracy: 100,
      loiteringDelayMs: 60000,
      statusChangeDelayMs: 10000,
      allowMockLocations: false,
      printDevLog: false);

  void hol(location) {
    List<Mechanic> mechanics = [
      Mechanic(
          nombre: 'MECANICO 1',
          latitude: 3.449476,
          longitude: -76.498128,
          geocerca: PolyGeofence(
            id: 'geofence1',
            polygon: <LatLng>[
              const LatLng(35.101727, 129.031665),
              const LatLng(35.101815, 129.033458),
              const LatLng(35.100032, 129.034055),
              const LatLng(35.099324, 129.033811),
              const LatLng(35.099906, 129.031927),
              const LatLng(35.101080, 129.031534),
            ],
          )),
      Mechanic(
          nombre: 'MECANICO 2',
          latitude: 3.448359,
          longitude: -76.497512,
          geocerca: PolyGeofence(
            id: 'geofence2',
            polygon: <LatLng>[
              const LatLng(37.422, -122.084),
              const LatLng(37.421, -122.084),
              const LatLng(37.421, -122.084),
            ],
          )),
    ];

    PolyGeofence geofence1 = PolyGeofence(
      id: 'geofence1',
      polygon: <LatLng>[
        const LatLng(35.101727, 129.031665),
        const LatLng(35.101815, 129.033458),
        const LatLng(35.100032, 129.034055),
        const LatLng(35.099324, 129.033811),
        const LatLng(35.099906, 129.031927),
        const LatLng(35.101080, 129.031534),
      ],
    );

    PolyGeofence geofence2 = PolyGeofence(
      id: 'geofence1',
      polygon: <LatLng>[
        const LatLng(37.422, -122.084),
        const LatLng(37.421, -122.084),
        const LatLng(37.421, -122.084),
      ],
    );

    _polyGeofenceService.addPolyGeofence(geofence1);
    _polyGeofenceService.addPolyGeofence(geofence2);
  }

  List<LatLng> searchMechanicNearby(
      double latitude, double longitude, double maxDistanceInMeters) {
    final location = LatLng(latitude, longitude);
    /*Mecanico*/
    List<LatLng> points = [
      //const LatLng(3.449476, -76.498128), // Cl. 53 #11-35 Comuna 8, Cali, Valle del Cauca  *Mas cercana*

      //const LatLng(3.448359, -76.497512), // Cl. 54 #11d-92 #11d-34 a, Comuna 8, Cali, Valle del Cauca

      //const LatLng(3.448712, -76.499793), // Cl. 51 #1154 comuna 8, Cali, Valle del Cauca

      const LatLng(3.415574,
          -76.504645), // Cl. 42A #3930 a 3984, Antonio Narino, Cali, Valle del Cauca

      //const LatLng(3.441337, -76.498757),

      //const LatLng(3.445792, -76.499299), // Cl. 52 #12e-59 a 12e-1 Comuna 8, Cali, Valle del Cauca
    ];

    //const double maxDistanceInMeters = 2000; // 2km
    //const double maxDistanceInMetersFallback = 5000; // 5km fallback
    print("------------------------------------------");
    List<LatLng> listFinal =
        nearbyPointsFunc(points, maxDistanceInMeters, location);
    /*if (listFinal.isEmpty) {
      listFinal =
          nearbyPointsFunc(points, maxDistanceInMetersFallback, location);
    }*/

    return listFinal;
  }

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
      print(distanceInMeters);
      print(distanceInMetersMax);
      if (distanceInMeters <= distanceInMetersMax) {
        nearbyPoints.add(point);
      }
    }
    return nearbyPoints;
  }
}
