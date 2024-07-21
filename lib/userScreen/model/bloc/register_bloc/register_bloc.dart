import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shelf/supports/applog/applog.dart';
import 'dart:core';
import 'package:email_validator/email_validator.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  RegisterBloc() : super(RegisterInitialState()) {
    on<SignUpButtonPressedEvent>(_signUpButtonPressedEvent);
  }

  Future<void> _signUpButtonPressedEvent(
      SignUpButtonPressedEvent event, Emitter<RegisterState> emit) async {

    emit(RegisterLoadingState());

    try{

      if(event.fullName.isEmpty || event.contact.isEmpty || event.email.isEmpty || event.password.isEmpty){
        String errorMessage = "Text field Shouldn't be empty";
        emit(RegisterErrorState(errorMessage: errorMessage));
      }
      else if(!EmailValidator.validate(event.email)){
        String errorMessage = "Please enter proper email format";
        emit(RegisterErrorState(errorMessage: errorMessage));
      }
      else if(event.password.length <= 8){
        String errorMessage = "Password length should be more than 8 character";
        emit(RegisterErrorState(errorMessage: errorMessage));
      }else{
        String successMessage = "Register Successfull";
        emit(RegisterSuccessState(successMessage: successMessage));
      }

    } catch(e){
      String errorMessage = "Error when Register";
      emit(RegisterErrorState(errorMessage: errorMessage));
      AppLog.e("Register Bloc Error", "${e}");
    }
  }
}
