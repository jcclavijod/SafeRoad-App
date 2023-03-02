import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:saferoad/Auth/provider/auth_provider.dart';
import 'package:saferoad/Auth/ui/views/welcome_screen.dart';
import 'package:saferoad/auth/bloc/app_bloc.dart';
import 'package:saferoad/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (BuildContext context) => AppBloc(),
        ),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomeScreen(),
        title: "Safe Road",
      ),
    );
  }
}
