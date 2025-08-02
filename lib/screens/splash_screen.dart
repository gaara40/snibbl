import 'package:flutter/material.dart';
import 'package:storygram/constants/assets.dart';
import 'package:storygram/themes/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
