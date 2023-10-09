import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../Home/ui/views/userpage.dart';
import '../Map/ui/views/ratingDialog.dart';
import '../Map/ui/widgets/show_dialog.dart';
import '../Request/Repository/requestRepository.dart';
import '../Request/model/Request.dart';
import '../Request/ui/views/ensayo.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final _authUser = FirebaseAuth.instance.currentUser;
  String serverToken =
      'key=AAAA6e_msQo:APA91bHbH6T_3gSc_e7xt-mzenG0M7XGeagDSlzc4XqkUWx-ve8wG0ibmav1PTWl55mGT2XnQByOi3lWW7ojk6JWDL2rOn0SYr2hk8Lv5gd9F28IbjyVdrRTTfqie73Fl2iX2UcFjwFH';

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    //showFlutterNotification(message);
    print('Handling a background message ${message.messageId}');
    print('title ${message.notification?.title}');
    print('body ${message.notification?.body}');
    print('payload ${message.data}');
    print('type ${message.data['type']}');
    showFlutterNotification(message);
  }

  static Future initialize(BuildContext context) async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //showFlutterNotification(message);
      if (message.notification != null) {
        if (message.data["type"] == "request") {
          modelRequestDialog(getRequest(message.data), context);
        } else if (message.data["type"] == "cancelRequest") {
          
          Future.delayed(const Duration(seconds: 2), () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => CancelationAlertDialog(),
            );
          });
        } else if (message.data["type"] == "finishedRequest") {
          modelRatingDialog(message.data, context);
        } else if (message.data["type"] == "chat") {}
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      modelRequestDialog(getRequest(message.data), context);
    });

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'launch_background',
          ),
        ),
      );
    }
  }

  static void onMessageOpenedApp(BuildContext context, RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? androidNotification = message.notification?.android;
    AppleNotification? appleNotification = message.notification?.apple;
    if (notification == null) return;
    if (androidNotification != null || appleNotification != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(notification.title ?? 'No Title'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.body ?? 'No body'),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<void> getToken() async {
    String? token = await messaging.getToken();
    final user = FirebaseAuth.instance.currentUser!;
    final String collection = await getTypeUser(user.uid);
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(_authUser!.uid)
        .update({
      'token': token,
    });
    messaging.subscribeToTopic("AllUsers");
    messaging.subscribeToTopic("AvailaibleMechanics");
  }

  void setupCloudMessaging() async {
    messaging.onTokenRefresh.listen((newToken) {
      print("Token actualizado: $newToken");
      getToken();
    });
  }

  Future<String> getTypeUser(String uid) async {
    final usuario =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final mecanico =
        await FirebaseFirestore.instance.collection('mecanicos').doc(uid).get();
    if (usuario.exists) {
      return "users";
    } else if (mecanico.exists) {
      return "mecanicos";
    }
    return "";
  }

  static String getRequest(Map<String, dynamic> message) {
    String userRequest = "";
    userRequest = message["request_id"];
    return userRequest;
  }

  static void modelRequestDialog(
      String userRequest, BuildContext context) async {
    RequestRepository repo = RequestRepository();
    Request? request = await repo.getRequestNotification(userRequest);
    String address = await repo.getAddress(request.userLocation);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            RequestPopup2(address: address, request: request));
  }

  static void modelRatingDialog(
      Map<String, dynamic> message, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => RatingDialog(
        requestId: message["request_id"],
        receiverUid: message["mechanicUid"],
        mechanicLocal: message["mechanicLocal"],
        mechanicPic: message["mechanicPic"],
      ),
    );
  }

  void sendNotificationToDriver(
      String token, Map notificationMap, Map dataMap) async {
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverToken,
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

  static void cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
