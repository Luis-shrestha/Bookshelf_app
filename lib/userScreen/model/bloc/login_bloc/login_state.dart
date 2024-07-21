part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final User user;
  LoginSuccessState({required this.user});
}

class LoginErrorState extends LoginState {
  final String errorLoginMessage;
  LoginErrorState({required this.errorLoginMessage});
}
