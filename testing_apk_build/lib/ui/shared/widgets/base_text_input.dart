import 'package:flutter/material.dart';

class BaseTextInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isRequired;
  final String? Function(String?)? validator; // optional custom validator
  final String mode; // text, password, email, number
  final bool disable;

  const BaseTextInput({
    super.key,
    required this.label,
    this.hint = "",
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.isRequired = false,
    this.validator,
    this.mode = "text",
    this.disable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        maxLines: isPassword ? 1 : maxLines,
        enabled: !disable, // 👈 use this instead of readOnly
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (isRequired && (value == null || value.trim().isEmpty)) {
            return "$label is required";
          }
          if (validator != null) return validator!(value);

          if (value != null && value.isNotEmpty) {
            if (mode == "email") {
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegex.hasMatch(value)) {
                return "Please enter a valid email address";
              }
            } else if (mode == "number") {
              final numberRegex = RegExp(r'^\d+$');
              if (!numberRegex.hasMatch(value)) {
                return "Please enter a valid number";
              }
            }
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          disabledBorder: OutlineInputBorder(
            // 👈 add a custom grey border
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
