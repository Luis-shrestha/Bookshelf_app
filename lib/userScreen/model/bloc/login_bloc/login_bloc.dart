import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../firebase_authentication_service/firebase_auth_helper.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginButtonPressEvent>(_loginButtonPressEvent);
  }

  Future<void> _loginButtonPressEvent(
      LoginButtonPressEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    try {
      User? user = await FirebaseAuthHelper.signInUsingEmailPassword(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        emit(LoginSuccessState(user: user));
      } else {
        emit(LoginErrorState(errorLoginMessage: "Unable to Login. Please try again."));
      }
    } catch (e) {
      emit(LoginErrorState(errorLoginMessage: e.toString()));
    }
  }
}
