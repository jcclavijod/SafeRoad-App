//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saferoad/Auth/app.dart';
import 'package:saferoad/Map/bloc/availability/availability_bloc.dart';
import 'package:saferoad/Map/bloc/gps/gps_bloc.dart';
import 'Map/bloc/location/my_location_bloc.dart';
import 'Map/bloc/map/map_bloc.dart';
//import 'package:dcdg/dcdg.dart';
import 'Map/bloc/usersInRoad/users_in_road_bloc.dart';
import 'Request/bloc/request/request_bloc.dart';
import 'helpers/notificationHelper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.setupFirebase();
  await NotificationHelper.initializeNotification();

  /*
   final FirebaseMessaging _fireMessage = FirebaseMessaging.instance;

   _fireMessage.configure(
    onMessage: (Map<String, dynamic> message) async {
      print('Mensaje de notificación recibido: $message');

      final requestId = message['data']['requestId'];
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RequestDetailsPage(requestId: requestId),
        ),
      );
    },
    onResume: (Map<String, dynamic> message) async {
      print('La aplicación estaba en segundo plano: $message');
    },
    onLaunch: (Map<String, dynamic> message) async {
      print('La aplicación estaba cerrada: $message');

      final requestId = message['data']['requestId'];
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RequestDetailsPage(requestId: requestId),
        ),
      );
    },
  );
*/
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => GpsBloc()),
      BlocProvider(create: (context) => MyLocationBloc()),
      BlocProvider(create: (context) => MapBloc()),
      BlocProvider(create: (context) => RequestBloc()),
      BlocProvider(create: (context) => AvailabilityBloc()),
      BlocProvider(create: (context) => UsersInRoadBloc())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}
