import 'package:flutter/material.dart';

class UploadBookForm extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final FocusNode focusNode;
  final void Function(String value)? func;

  UploadBookForm({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    required this.focusNode,
    required this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) {
        // Check if func is not null before calling it
        func?.call(value);
      },
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black54
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
              color: Colors.black54, width: 0.6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.black54, width: 0.6),
          borderRadius: BorderRadius.circular(30.0),
        ),
        prefixIcon: Icon(prefixIcon),
      ),
    );
  }
}
