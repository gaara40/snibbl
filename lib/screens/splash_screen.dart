import 'package:flutter/material.dart';
import 'package:storygram/constants/assets.dart';
import 'package:storygram/themes/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 3),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppAssets.appNameLogo, height: 100),
                SizedBox(height: 12),
                Text(
                  'Poetry, in its smallest, softest form',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          Spacer(flex: 2),
          Center(child: CircularProgressIndicator()),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
