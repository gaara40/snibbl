import 'package:flutter/material.dart';
import 'package:storygram/themes/app_theme.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback toggleVisibility;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.toggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: AppTheme.tertiaryColor,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppTheme.inversePrimary,
            width: 2.5,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppTheme.onSecondaryColor),
        ),
        labelStyle: const TextStyle(color: AppTheme.onPrimaryColor),
        labelText: 'Password',
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: AppTheme.onPrimaryColor,
        ),
        suffixIcon: IconButton(
          onPressed: toggleVisibility,
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Password is required.';
        } else if (value.trim().length < 6) {
          return 'Password must be at least 6 characters.';
        }
        return null;
      },
    );
  }
}
