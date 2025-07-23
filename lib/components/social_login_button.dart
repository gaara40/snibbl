import 'package:flutter/material.dart';
import 'package:storygram/themes/app_theme.dart';

class SocialLoginButton extends StatelessWidget {
  final String logoAssetPath;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.logoAssetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.secondaryColor,
        ),
        child: Center(child: Image.asset(logoAssetPath, height: 65)),
      ),
    );
  }
}
