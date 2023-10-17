import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Repository/availabilityRepository.dart';

part 'availability_event.dart';
part 'availability_state.dart';

class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
  AvailabilityBloc() : super(const AvailabilityState()) {
    on<UpdateAvailability>(
        (event, emit) => emit(state.copyWith(isAvailable: event.isAvailable)));
    on<AvailabilityText>((event, emit) =>
        emit(state.copyWith(availabilityText: event.availabilityText)));
  }

  final AvailabilityRepository availabilityRepository = AvailabilityRepository(
    firestore: FirebaseFirestore.instance,
    user: FirebaseAuth.instance.currentUser,
  );

  void updateState(bool availability) async {
    availabilityRepository.updateMechanicAvailability(availability);
    getState();
  }

  void getState() async {
    final isAvailable = await availabilityRepository.getMechanicAvailability();
    if (isAvailable) {
      add(const AvailabilityText("Conectado"));
    } else {
      add(const AvailabilityText("Desconectado"));
    }
    add(UpdateAvailability(isAvailable));
  }
}
