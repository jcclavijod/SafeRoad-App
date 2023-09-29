part of 'cliente_bloc.dart';

abstract class ClienteEvent {}

class RegisterUserEvent extends ClienteEvent {
  final UserModel user;
  final File profilePic;

  RegisterUserEvent({required this.user, required this.profilePic});
}

class LoginUserEvent extends ClienteEvent {
  final String email;
  final String password;

  LoginUserEvent({required this.email, required this.password});
}

class LogoutUserEvent extends ClienteEvent {}
