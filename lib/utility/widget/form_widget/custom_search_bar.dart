import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? prefixIcon;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final IconData suffixIcon;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    required this.focusNode,
    this.onChanged,
    required this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        textAlign: TextAlign.left,
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged, // Use this line
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.black87,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.black54),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.black54, width: 0.6,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black54, width: 0.6,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          suffixIcon: Icon(suffixIcon),
        ),
      ),
    );
  }
}
