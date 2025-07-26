import 'package:flutter/material.dart';
import 'package:storygram/constants/assets.dart';
import 'package:storygram/themes/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/authGate',
        (routes) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 3),
          Center(child: Image.asset(AppAssets.appNameLogo, width: 250)),

          Spacer(flex: 2),
          Center(child: CircularProgressIndicator()),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
