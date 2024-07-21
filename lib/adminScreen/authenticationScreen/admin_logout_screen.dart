import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shelf/adminScreen/authenticationScreen/admin_login_register_view.dart';

class AdminLogoutScreen {
  static Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const AdminLoginRegisterView(),
      ),
    );
  }
}