
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saferoad/Auth/provider/auth_provider.dart';

import 'package:saferoad/Auth/ui/views/welcome_screen.dart';
import 'package:saferoad/firebase_options.dart';
import 'package:provider/provider.dart';

import 'Auth/ui/views/homes_screen.dart';

import 'Map/bloc/gps/gps_bloc.dart';
import 'Map/bloc/location/my_location_bloc.dart';
import 'Map/bloc/map/map_bloc.dart';

import 'package:saferoad/Auth/app.dart';
import 'package:saferoad/firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => GpsBloc()),
      BlocProvider(create: (context) => MyLocationBloc()),
      BlocProvider(create: (context) => MapBloc())
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
