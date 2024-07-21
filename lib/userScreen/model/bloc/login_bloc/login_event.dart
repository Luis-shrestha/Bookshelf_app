part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginButtonPressEvent extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressEvent({
    required this.email,
    required this.password,
  });
}
