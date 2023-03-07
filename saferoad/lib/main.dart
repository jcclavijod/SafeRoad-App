import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saferoad/Auth/provider/auth_provider.dart';
import 'package:saferoad/Auth/provider/provider.dart';
import 'package:saferoad/Auth/ui/views/welcome_screen.dart';
import 'package:saferoad/firebase_options.dart';
import 'package:provider/provider.dart';

import 'Auth/Repository/auth_repository.dart';
import 'Auth/bloc/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  runApp(
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepository _authRepository = AuthRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: _authRepository),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<AuthProviders>(
          create: (_) => AuthProviders(),
        ), // envolver su widget con ChangeNotifierProvider<AuthProvider>
      ],
      child: MaterialApp(
        title: 'Saferoad',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return const WelcomeScreen();
          },
        ),
      ),
    );
  }
}
