// ignore_for_file: depend_on_referenced_packages, avoid_print
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saferoad/Auth/bloc/cliente/cliente_bloc.dart';
import 'package:saferoad/Auth/model/mecanico_model.dart';
import 'package:saferoad/Auth/repository/mecanicoRepository/login_repository.dart';
import 'package:meta/meta.dart';
import '../../../repository/mecanicoRepository/registro_repository.dart';
part 'mecanico_event.dart';
part 'mecanico_state.dart';

class MecanicoBloc {
  final RegisterRepository registerRepository = RegisterRepository();
  final LoginMecanicoRepository loginMeRepository = LoginMecanicoRepository();
  MecanicoModel? currentUser;
  Future<void> registerMecanico(
    String name,
    String lastname,
    String mail,
    String local,
    String address,
    String password,
    String identification,
    String gender,
    String phoneNumber,
    String birthday,
    File profilePic,
    File voucher,
    double calification,
    Position position,
    String token,
  ) async {
    currentUser = MecanicoModel(
      name: name,
      lastname: lastname,
      mail: mail,
      local: local,
      address: address,
      password: password,
      identification: identification,
      gender: gender,
      phoneNumber: phoneNumber,
      birthday: birthday,
      profilePic: '',
      voucher: '',
      uid: '',
      isAviable: true,
      calification: 0,
      position: position,
      token: token,
    );

    try {
      await registerRepository.registerMecanico(
          currentUser!, profilePic, voucher);
      print('Usuario registrado exitosamente.');
    } catch (e) {
      print('Error al registrar usuario: $e');
    }
  }

  Future<void> loginMecanico(String mail, String password) async {
    try {
      await loginMeRepository.signInWithEmailAndPasswordMecanico(
          mail, password);
      print('Usuario ha iniciado sesión exitosamente.');
    } catch (e) {
      throw Exception('Error de inicio de sesión: $e');
    }
  }
}
