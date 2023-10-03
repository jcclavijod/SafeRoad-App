part of 'cliente_bloc.dart';

abstract class ClienteState {}

class ClienteLoadingState extends ClienteState {}

class ClienteErrorState extends ClienteState {
  final String message;

  ClienteErrorState({required this.message});
}

class UserRegisteredState extends ClienteState {}

class UserLoggedInState extends ClienteState {}

class UserLoggedOutState extends ClienteState {}
