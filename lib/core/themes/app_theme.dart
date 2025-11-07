import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  //common primary and secondary colors
  static const Color primaryColor = Color(0xFFD4A373);
  static const Color secondaryColor = Color(0xFFFAEDCD);

  //inverse colors
  static const Color inversePrimary = Color.fromARGB(208, 222, 151, 81);
  static const Color inverseSecondary = Color.fromARGB(255, 203, 175, 104);

  //light theme
  static const Color onPrimaryColor = Color(0xFF4A3B2B);
  static const Color onSecondaryColor = Color(0xFF3E3325);
  static const Color surfaceColor = Color.fromARGB(255, 255, 251, 227);

  //others
  static const tertiaryColor = Color.fromARGB(255, 247, 220, 179);

  //loading state card color
  static const Color loadingCardColor = Color.fromARGB(255, 244, 220, 183);

  //bottom navigation bar color
  static const Color bottomNavBarColor = Color.fromARGB(255, 254, 249, 220);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      secondary: secondaryColor,
      onSecondary: onSecondaryColor,
      error: Colors.redAccent,
      onError: Colors.black87,
      surface: surfaceColor,
      onSurface: onPrimaryColor,
    ),
    scaffoldBackgroundColor: secondaryColor,
    textTheme: GoogleFonts.nunitoTextTheme().apply(
      bodyColor: onPrimaryColor,
      displayColor: onPrimaryColor,
    ),
  );
}
