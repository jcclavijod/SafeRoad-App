part of 'mecanico_bloc.dart';

@immutable
abstract class MecanicoState {}

class MecanicoInitial extends MecanicoState {}

class MecanicoErrorState extends ClienteState {
  final String message;

  MecanicoErrorState({required this.message});
}

class MecanicoregisteredState extends MecanicoState {}

class MecanicoLoggedInState extends MecanicoState {}

class MecanicoLoggedOutState extends MecanicoState {}
