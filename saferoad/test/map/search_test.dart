import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saferoad/Map/Repository/searchRepository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:saferoad/Request/model/Request.dart';

class MockUser {
  final String uid;

  MockUser(this.uid);
}

class Position {
  final String geohash;
  final GeoPoint geopoint;

  const Position({
    required this.geohash,
    required this.geopoint,
  });
}

void main() {
  group('SearchRepository Tests', () {
    late SearchRepository searchRepository;
    late FakeFirebaseFirestore fakeFirestore;
    final user = MockUser('mockUserId');
    const location = LatLng(3.452372, -76.496545);
    late GeoFlutterFire geo;
    const radius = 1.5;
    final request = Request.complete(id: "request123");

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      geo = GeoFlutterFire();
      searchRepository =
          SearchRepository(geo: geo, firestore: fakeFirestore, user: user);
    });

    test('mechanicNearby should return nearby mechanics', () async {
      const location1 = {
        'geohash': 'd29eehk0',
        'geopoint': GeoPoint(3.451216, -76.503197)
      };
      const location2 = {
        'geohash': 'd29ee5mk',
        'geopoint': GeoPoint(3.446354, -76.501545)
      };
      await fakeFirestore
          .collection('mecanicos')
          .add({'isAvailable': true, 'position': location1});
      await fakeFirestore
          .collection('mecanicos')
          .add({'isAvailable': true, 'position': location2});
      final result = await searchRepository.mechanicNearby(location, radius);
      expect(result.length, 2);
    });

    test(
        'mechanicNearby should return an empty list when no mechanics are nearby',
        () async {
      const location1 = {
        'geohash': 'd29e6k5j',
        'geopoint': GeoPoint(3.406749, -76.537293)
      };
      const location2 = {
        'geohash': 'd29e7v1q',
        'geopoint': GeoPoint(3.412404, -76.473950)
      };
      await fakeFirestore
          .collection('mecanicos')
          .add({'isAvailable': true, 'position': location1});
      await fakeFirestore
          .collection('mecanicos')
          .add({'isAvailable': true, 'position': location2});

      final result = await searchRepository.mechanicNearby(location, radius);

      expect(result, isEmpty);
    });

    test(
        'watchMechanicLocationChanges should return initial location when no data',
        () {
      final stream =
          searchRepository.watchMechanicLocationChanges(request, location);
      expect(stream, emits(location));
    });

    test(
      'watchMechanicLocationChanges should return mechanic location when available',
      () async {
        const initialLocation = LatLng(3.452372, -76.496545);
        const newLocation = LatLng(3.446354, -76.501545);

        fakeFirestore.collection('requests').doc(request.id).set({
          'mechanicLocation':
              GeoPoint(initialLocation.latitude, initialLocation.longitude),
        });

        final stream =
            searchRepository.watchMechanicLocationChanges(request, location);

        await expectLater(stream, emits(initialLocation));

        fakeFirestore.collection('requests').doc(request.id).update({
          'mechanicLocation':
              GeoPoint(newLocation.latitude, newLocation.longitude),
        });

        await expectLater(stream, emitsInOrder([initialLocation, newLocation]));
      },
    );

    test(
        'listenToMechanicChanges should return a stream of mechanic changes for an existing mechanic',
        () async {
      const mechanicId = 'mockUserId';
      final mechanicData = {"lastName": "pedro"};
      await fakeFirestore
          .collection('mecanicos')
          .doc(mechanicId)
          .set(mechanicData);

      final stream = searchRepository.listenToMechanicChanges(mechanicId);
      final initialSnapshot = await stream.first;
      expect(initialSnapshot.data(), equals(mechanicData));
      final updatedMechanicData = {"lastName": "Julian"};
      await fakeFirestore
          .collection('mecanicos')
          .doc(mechanicId)
          .update(updatedMechanicData);

      final updatedSnapshot = await stream.first;

      expect(updatedSnapshot, isNotNull);
      expect(updatedSnapshot.data(), equals(mechanicData));
    });

    test(
        'listenToMechanicChanges should return an empty stream for a non-existing mechanic',
        () async {
      const mechanicId = 'mockUserId';
      final stream = searchRepository.listenToMechanicChanges(mechanicId);
      final snapshot = await stream.first;
      await expectLater(snapshot.data(), equals(null));
    });
  });
}
