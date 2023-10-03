// ignore_for_file: use_build_context_synchronously, unused_import, depend_on_referenced_packages, avoid_print, file_names
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saferoad/Home/ui/widgets/SideMenuWidget.dart';
import 'package:saferoad/Membresia/Bloc/membership_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saferoad/Membresia/model/membresia_model.dart';
import 'package:saferoad/Membresia/repository/membresia_repository.dart';
import 'package:saferoad/Membresia/ui/widgets/alertas.dart';
import 'package:saferoad/Membresia/ui/widgets/membershipPopup.dart';
import 'package:saferoad/Membresia/ui/widgets/planCard.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({Key? key}) : super(key: key);
  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  final MembresiaBloc _bloc = MembresiaBloc();
  bool _membershipActivated = false;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membresía'),
        backgroundColor: Colors.blue,
      ),
      drawer: const SideMenuWidget(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Elige tu plan de membresía',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              StreamBuilder<int>(
                stream: _bloc.selectedDurationStream,
                initialData: _bloc.selectedDuration,
                builder: (context, snapshot) {
                  return PlanCard(
                    title: 'Mensual',
                    subtitle: 'Costo: ${calculateCost(1)} pesos Colombianos',
                    isSelected: snapshot.data == 1,
                    onTap: () {
                      _bloc.updateSelectedDuration(1);
                    },
                  );
                },
              ),
              StreamBuilder<int>(
                stream: _bloc.selectedDurationStream,
                initialData: _bloc.selectedDuration,
                builder: (context, snapshot) {
                  return PlanCard(
                    title: 'Semestral',
                    subtitle: 'Costo: ${calculateCost(6)} pesos colombianos',
                    isSelected: snapshot.data == 6,
                    onTap: () {
                      _bloc.updateSelectedDuration(6);
                    },
                  );
                },
              ),
              StreamBuilder<int>(
                stream: _bloc.selectedDurationStream,
                initialData: _bloc.selectedDuration,
                builder: (context, snapshot) {
                  return PlanCard(
                    title: 'Anual',
                    subtitle: 'Costo: ${calculateCost(12)} pesos colombianos',
                    isSelected: snapshot.data == 12,
                    onTap: () {
                      _bloc.updateSelectedDuration(12);
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    final hasActiveMembership =
                        await _bloc.checkActiveMembership(user.uid);
                    if (hasActiveMembership) {
                      try {
                        final activeMembership =
                            await _bloc.getActiveMembership(user.uid);
                        if (activeMembership.fechaFinal != null) {
                          final expirationDate = DateFormat('dd/MM/yyyy')
                              .format(
                                  DateTime.parse(activeMembership.fechaFinal!));
                          Alertas.showMembershipAlert(
                              context,
                              'Ya tienes una membresía activa.',
                              expirationDate);
                        } else {
                          print('Error obteniendo la membresía activa.');
                        }
                      } catch (e) {
                        print('Error obteniendo la membresía activa: $e');
                      }
                    } else {
                      print('Selected Duration: ${_bloc.selectedDuration}');
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return MembershipPopUp(
                            onMembershipConfirmed: () async {
                              setState(() {
                                _membershipActivated = true;
                              });
                              await _bloc.addMembresia(
                                  user.uid, _bloc.selectedDuration);
                            },
                          );
                        },
                      );

                      if (_membershipActivated) {
                        Alertas.showSuccessAlert(context,
                            'Gracias por confiar en nuestro servicio.');
                      }
                    }
                  } else {
                    print('Usuario no autenticado');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                ),
                child: const Text(
                  '¡Únete ahora!',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

int calculateCost(int months) {
  double monthlyCost = 20000;
  return (monthlyCost * months).toInt();
}
