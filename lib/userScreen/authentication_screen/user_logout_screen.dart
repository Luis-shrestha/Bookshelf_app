import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'user_login_register_view.dart';
import 'user_login_screen.dart';

class UserLogoutScreen {
  static Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const UserLoginRegisterView(),
      ),
    );
  }
}