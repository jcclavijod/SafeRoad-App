import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saferoad/Auth/bloc/app_bloc.dart';
import 'package:saferoad/Auth/provider/auth_provider.dart';
import 'package:saferoad/Auth/ui/views/Email_view.dart';
import 'package:saferoad/Auth/ui/views/welcome_screen.dart';
import 'package:saferoad/Auth/ui/views/welcome_view.dart';
import 'package:saferoad/firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> home() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  runApp(const MyApp2());
}

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return BlocProvider(
      create: (context) => AppBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: welcomeView(),
        title: "Safe Road",
      ),
    );
  }
}
