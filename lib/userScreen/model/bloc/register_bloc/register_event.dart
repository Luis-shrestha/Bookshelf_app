part of 'register_bloc.dart';

abstract class RegisterEvent {}

class SignUpButtonPressedEvent extends RegisterEvent {
  final String fullName;
  final String contact;
  final String email;
  final String password;
  final String? bio;
  final File? profilePicture;

  SignUpButtonPressedEvent({
    required this.fullName,
    required this.contact,
    required this.email,
    required this.password,
    this.bio,
    this.profilePicture,
  });
}
