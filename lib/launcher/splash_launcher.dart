import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storygram/main.dart';
import 'package:storygram/screens/splash_screen.dart';

class Splashlauncher extends StatefulWidget {
  const Splashlauncher({super.key});

  @override
  State<Splashlauncher> createState() => _SplashlauncherState();
}

class _SplashlauncherState extends State<Splashlauncher> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      if (user == null) {
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          '/loginScreen',
          (route) => false,
        );
      } else {
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          '/mainScreen',
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
