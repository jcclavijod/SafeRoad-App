part of 'mecanico_bloc.dart';

@immutable
abstract class MecanicoEvent {}

class RegisterMecanicoEvent extends MecanicoEvent {
  final MecanicoModel mecanico;
  final File profilePic;
  final File voucherPic;

  RegisterMecanicoEvent(
      {required this.mecanico,
      required this.profilePic,
      required this.voucherPic});
}

class LoginMecanicoEvent extends MecanicoEvent {
  final String email;
  final String password;

  LoginMecanicoEvent({required this.email, required this.password});
}

class LogoutMecanicoEvent extends MecanicoEvent {}
