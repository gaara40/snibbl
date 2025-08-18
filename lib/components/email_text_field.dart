import 'package:flutter/material.dart';
import 'package:storygram/themes/app_theme.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;

  const EmailTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: AppTheme.tertiaryColor,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppTheme.inversePrimary, width: 2.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppTheme.onSecondaryColor),
        ),
        labelStyle: TextStyle(color: AppTheme.onPrimaryColor),
        labelText: 'Email Address',
        prefixIcon: Icon(Icons.email_outlined),
        prefixIconColor: AppTheme.onPrimaryColor,
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email is required.';
        } else if (!RegExp(
          r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
        ).hasMatch(value.trim())) {
          return 'Enter a valid email address';
        }
        return null;
      },
    );
  }
}
