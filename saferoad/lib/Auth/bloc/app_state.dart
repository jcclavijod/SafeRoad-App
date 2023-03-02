part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  final bool isLoading;
  final bool succesful;
  const AppState({
    required this.isLoading,
    required this.succesful,
  });
}

class AppStateLoggedIn extends AppState {
  const AppStateLoggedIn({required isLoading, required succesful})
      : super(
          isLoading: isLoading,
          succesful: succesful,
        );
  @override
  List<Object?> get props => [isLoading, succesful];
}

class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({required isLoading, required succesful})
      : super(
          isLoading: isLoading,
          succesful: succesful,
        );
  @override
  List<Object?> get props => [isLoading, succesful];
}
