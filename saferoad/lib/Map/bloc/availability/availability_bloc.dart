// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:saferoad/Membresia/repository/membresia_repository.dart';

import '../../Repository/availabilityRepository.dart';

part 'availability_event.dart';
part 'availability_state.dart';

class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
  final MembresiaRepository _repository = MembresiaRepository();
  AvailabilityBloc() : super(const AvailabilityState()) {
    on<UpdateAvailability>(
        (event, emit) => emit(state.copyWith(isAvailable: event.isAvailable)));
    on<AvailabilityText>((event, emit) =>
        emit(state.copyWith(availabilityText: event.availabilityText)));
  }

  final AvailabilityRepository availabilityRepository =
      AvailabilityRepository();

  void updateState(bool availability) {
    availabilityRepository.updateMechanicAvailability(availability);
    // No es necesario llamar a getState() aquí
    // getState();
    emit(state.copyWith(isAvailable: availability));
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

  Future<bool> hasActiveMembership(String uid) async {
    return await _repository.checkActiveMembership(uid);
  }
}
