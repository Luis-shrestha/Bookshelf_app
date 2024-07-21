part of 'register_bloc.dart';

abstract class RegisterState{}

class RegisterInitialState extends RegisterState{}

class RegisterLoadingState extends RegisterState{}

class RegisterSuccessState extends RegisterState{
  final String successMessage;

  RegisterSuccessState({required this.successMessage});
}

class RegisterErrorState extends RegisterState{
  final String errorMessage;

  RegisterErrorState({required this.errorMessage});
}