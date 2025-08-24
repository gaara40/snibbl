import 'package:flutter/material.dart';
import 'package:storygram/themes/app_theme.dart';

class UsernameTextField extends StatelessWidget {
  const UsernameTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: 15,

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
        labelText: 'Username',
        prefixIcon: const Icon(Icons.person, color: AppTheme.onPrimaryColor),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a username';
        } else if (value.length < 2) {
          return 'Username must be atleast 3 characters';
        } else if (value.length > 20) {
          return 'Username must not exceed 20 characters';
        }
        return null;
      },
    );
  }
}
