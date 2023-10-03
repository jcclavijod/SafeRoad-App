// ignore_for_file: use_build_context_synchronously, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saferoad/Auth/app.dart';
import 'package:saferoad/Membresia/ui/views/membershipPage.dart';
import '../../Bloc/membership_bloc.dart';

class VerificationMembership {
  final MembresiaBloc _membresiaBloc = MembresiaBloc();

  Future<void> verifyMembership(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final hasActiveMembership =
          await _membresiaBloc.checkActiveMembership(user.uid);
      if (hasActiveMembership) {
        return;
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const NoMembershipAlertDialog(),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const UnauthorizedDialog(),
      );
    }
  }
}

class NoMembershipAlertDialog extends StatelessWidget {
  const NoMembershipAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('No tienes una membresía activa :('),
      content:
          const Text('Para usar los servicios necesitas tener una membresía'),
      actions: [
        TextButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            );
          },
          child: const Text('Cerrar Sesión'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MembershipPage(),
              ),
            );
          },
          child: const Text('Activar membresía'),
        ),
      ],
    );
  }
}

class UnauthorizedDialog extends StatelessWidget {
  const UnauthorizedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Usuario no autenticado'),
      content:
          const Text('Para usar los servicios necesitas estar autenticado'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
