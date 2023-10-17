/*

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:saferoad/Home/Repository/notifications.dart';
import 'package:saferoad/Home/Repository/notificationsManager.dart';
import 'package:saferoad/Map/ui/views/ratingDialog.dart';
import 'package:saferoad/Map/ui/widgets/show_dialog.dart';
import 'package:saferoad/Request/Repository/requestRepository.dart';
import 'package:saferoad/Request/model/Request.dart';


class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockRequestRepository extends Mock implements RequestRepository {}

class MockNotificationManager extends Mock implements NotificationManager {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('Notifications Repository Tests', () {
    late MockFirebaseMessaging mockMessaging;
    late MockRequestRepository mockRequestRepository;
    late MockNotificationManager mockNotificationManager;

    setUp(() {
      mockMessaging = MockFirebaseMessaging();
      mockRequestRepository = MockRequestRepository();
      mockNotificationManager = MockNotificationManager();

      // Configura las propiedades estáticas de Notifications
      Notifications.messaging = mockMessaging;
      Notifications.request = null;
      Notifications.notificationManager = mockNotificationManager;
    });

    test('getToken should call getToken from FirebaseMessaging', () async {
      when(mockMessaging.getToken()).thenAnswer((_) async => 'fake_token');

      await notifications.getToken();

      verify(mockMessaging.getToken()).called(1);
    });

    test('setupCloudMessaging should call getToken and subscribe to topics', () async {
      when(mockMessaging.onTokenRefresh)
          .thenAnswer((_) => Stream.fromIterable(['fake_token']));

      await Notifications.setupCloudMessaging();

      verify(mockMessaging.onTokenRefresh).called(1);
      verify(mockMessaging.subscribeToTopic('AllUsers')).called(1);
      verify(mockMessaging.subscribeToTopic('AvailaibleMechanics')).called(1);
    });

    test('getTypeUser should return "users" when user exists', () async {
      when(mockMessaging.onTokenRefresh)
          .thenAnswer((_) => Stream.fromIterable(['fake_token']));
      final mockFirestore = MockFirebaseFirestore();
      notifications.firebaseFirestore = mockFirestore;

      final mockDocumentSnapshot = MockDocumentSnapshot();
      when(mockFirestore.collection('users').doc(any))
          .thenAnswer((_) async => mockDocumentSnapshot);
      when(mockFirestore.collection('mecanicos').doc(any))
          .thenAnswer((_) async => MockDocumentSnapshot());

      final userType = await notifications.getTypeUser('user_uid');

      expect(userType, 'users');
    });

    test('getTypeUser should return "mecanicos" when mechanic exists', () async {
      when(mockMessaging.onTokenRefresh)
          .thenAnswer((_) => Stream.fromIterable(['fake_token']));
      final mockFirestore = MockFirebaseFirestore();
      notifications.firebaseFirestore = mockFirestore;

      when(mockFirestore.collection('users').doc(any))
          .thenAnswer((_) async => MockDocumentSnapshot());
      final mockMechanicDocumentSnapshot = MockDocumentSnapshot();
      when(mockFirestore.collection('mecanicos').doc(any))
          .thenAnswer((_) async => mockMechanicDocumentSnapshot);

      final userType = await notifications.getTypeUser('mechanic_uid');

      expect(userType, 'mecanicos');
    });

    test('modelRequestDialog should set request correctly', () async {
      final mockBuildContext = MockBuildContext();
      final fakeRequestId = 'fake_request_id';
      when(mockRequestRepository.getRequestNotification(any))
          .thenAnswer((_) async => Request(id: fakeRequestId));

      await Notifications.modelRequestDialog(fakeRequestId, mockBuildContext);

      expect(notifications.request?.id, fakeRequestId);
    });

    test('modelRatingDialog should show RatingDialog', () async {
      final mockBuildContext = MockBuildContext();
      final fakeMessage = {
        'request_id': 'fake_request_id',
        'mechanicUid': 'fake_mechanic_uid',
        'mechanicLocal': 'fake_mechanic_local',
        'mechanicPic': 'fake_mechanic_pic',
      };

      await Notifications.modelRatingDialog(fakeMessage, mockBuildContext);

      verify(mockBuildContext).read<NavigatorObserver>();
    });

    tearDown(() {
      Notifications.messaging = FirebaseMessaging.instance;
      Notifications.request = null;
      Notifications.notificationManager = NotificationManager();
    });
  });
}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

*/