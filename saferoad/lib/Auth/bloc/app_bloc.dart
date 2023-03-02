// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:saferoad/Auth/auth.dart';
import 'package:saferoad/Auth/auth_error.dart';
part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(const AppStateLoggedOut(isLoading: true, succesful: false)) {
    on<AppEventLogIn>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true, succesful: false));
      try {
        await Auth().signInWithEmailAndPassword(
            email: event.email, password: event.password);
        emit(const AppStateLoggedIn(isLoading: false, succesful: true));
      } on FirebaseAuthException catch (e) {
        // ignore: avoid_print
        print(e);
        authErrorLogin = e.toString();
        emit(const AppStateLoggedIn(isLoading: false, succesful: true));
      }
    });
    on<AppEventLogOut>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true, succesful: false));
      try {
        await Auth().signOut();
        emit(const AppStateLoggedOut(isLoading: false, succesful: true));
      } on FirebaseAuthException catch (e) {}
    });
    on<AppEventRegister>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true, succesful: false));
      try {
        await Auth().createUserWithEmaildAndPassword(
            email: event.email, password: event.password);
        emit(const AppStateLoggedIn(isLoading: false, succesful: true));
      } on FirebaseAuthException catch (e) {
        // ignore: avoid_print
        print(e);
        authErrorLogin = e.toString();
        emit(const AppStateLoggedIn(isLoading: false, succesful: true));
      }
    });
    on<AppEventResetPassword>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true, succesful: false));
      try {
        await Auth().sendResetPasswordEmail(email: event.email);
        emit(const AppStateLoggedIn(isLoading: false, succesful: true));
      } on FirebaseAuthException catch (e) {
        print(e);
        authErrorLogin = e.toString();
        emit(const AppStateLoggedOut(isLoading: false, succesful: false));
      }
    });
  }
}
