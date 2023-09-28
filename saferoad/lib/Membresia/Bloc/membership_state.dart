import 'package:saferoad/Membresia/model/membresia_model.dart';

abstract class MembresiaState {}

class InitialMembresiaState extends MembresiaState {}

class LoadingMembresiaState extends MembresiaState {}

class MembresiaAddedState extends MembresiaState {
  final membresiaModel membresia;

  MembresiaAddedState(this.membresia);
}

class ErrorMembresiaState extends MembresiaState {
  final String error;

  ErrorMembresiaState(this.error);
}
