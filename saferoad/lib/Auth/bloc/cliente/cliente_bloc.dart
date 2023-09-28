// ignore_for_file: unused_import, depend_on_referenced_packages, no_leading_underscores_for_local_identifiers, avoid_print, unused_element
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saferoad/Auth/model/usuario_model.dart';
import 'package:meta/meta.dart';
import 'package:saferoad/Auth/repository/userRepository/loginUserRepository.dart';
import '../../repository/userRepository/registerUserRepository.dart';
part 'cliente_event.dart';
part 'cliente_state.dart';

class ClienteBloc {
  final UserRegisterRepository registerRepository = UserRegisterRepository();
  final LoginRepository loginRepository = LoginRepository();
  UserModel? currentUser; 

  Future<void> registerUser(
    String name,
    String lastname,
    String mail,
    String password,
    String identification,
    String gender,
    String phoneNumber,
    String birthday,
    String uid,
    bool isAviable,
    File profilePic,
  ) async {
    currentUser = UserModel(
      name: name,
      lastname: lastname,
      mail: mail,
      password: password,
      identification: identification,
      gender: gender,
      phoneNumber: phoneNumber,
      birthday: birthday,
      uid: '',
      isAviable: true,
      profilePic: '',
      token: ''
    );

    try {
      await registerRepository.registerUser(currentUser!, profilePic);
      print('Usuario registrado exitosamente.');
    } catch (e) {
      print('Error al registrar usuario: $e');
    }
  }

  Future<void> loginUser(String mail, String password) async {
    try {
      await loginRepository.signInWithEmailAndPassword(mail, password);
      print('Usuario ha iniciado sesión exitosamente.');
    } catch (e) {
      print('Error al iniciar sesión: $e');
    }
  }

  Future<void> logoutUser() async {
    try {
      await loginRepository.signOut();
      print('Usuario ha cerrado sesión exitosamente.');
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }
}
