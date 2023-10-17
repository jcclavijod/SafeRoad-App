import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:saferoad/Auth/app.dart';
import 'package:saferoad/Home/Provider/notificationsProvider.dart';
import 'package:saferoad/Home/bloc/manageNotifications/manage_notifications_bloc.dart';
import 'package:saferoad/Home/ui/views/userpage.dart';
import 'package:saferoad/Map/bloc/availability/availability_bloc.dart';
import 'package:saferoad/Map/bloc/gps/gps_bloc.dart';
import 'package:saferoad/ServiceRegister/bloc/causeFailure/cause_failure_bloc.dart';
import 'package:saferoad/ServiceRegister/bloc/myBilling/my_billing_bloc.dart';
import 'Map/bloc/location/my_location_bloc.dart';
import 'Map/bloc/map/map_bloc.dart';
//import 'package:dcdg/dcdg.dart';
import 'Map/bloc/qualification/qualification_bloc.dart';
import 'Map/bloc/usersInRoad/users_in_road_bloc.dart';
import 'Request/bloc/request/request_bloc.dart';
//import 'helpers/notificationHelper.dart';
import '../firebase_options.dart';
import 'helpers/notificationHelper.dart';

Future<void> main(context) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider(create: (context) => GpsBloc()),
      BlocProvider(create: (context) => MyLocationBloc()),
      BlocProvider(create: (context) => MapBloc()),
      BlocProvider(create: (context) => RequestBloc()),
      BlocProvider(create: (context) => AvailabilityBloc()),
      BlocProvider(create: (context) => UsersInRoadBloc()),
      BlocProvider(create: (context) => QualificationBloc()),
      BlocProvider(create: (context) => ManageNotificationsBloc()),
      BlocProvider(create: (context) => MyBillingBloc()),
      BlocProvider(create: (context) => CauseFailureBloc()),
    ], child: const MyApp()),
  );
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
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(), // Página de inicio
        '/UserPage': (context) =>
            const UserPage(), // Otras rutas de tu aplicación
        // ...
      },
    );
  }
}
