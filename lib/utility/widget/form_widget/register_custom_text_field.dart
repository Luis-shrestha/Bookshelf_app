import 'package:flutter/material.dart';

class RegisterCustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int maxLines;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final Function()? suffixIconOnPressed; // Updated type
  final bool obscureText;

  const RegisterCustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.maxLines,
    required this.prefixIcon,
    this.suffixIcon,
    this.suffixIconOnPressed,
    this.obscureText = false,
    required FocusNode focusNode,
    required String? Function(dynamic value) validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      obscureText: suffixIcon == Icons.visibility_off,
      // Set obscureText based on suffixIcon
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
            color: Colors.black87
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
              color: Colors.black, width: 0.6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.black, width: 0.6),
          borderRadius: BorderRadius.circular(30.0),
        ),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: suffixIconOnPressed,
              )
            : null,
      ),
    );
  }
}
