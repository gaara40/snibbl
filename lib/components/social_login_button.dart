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
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.tertiaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(logoAssetPath),
                Text(
                  'Sign in with Google',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// SizedBox(width: 6),
      // Tooltip(
      //   message:
      //       "As readers, guest users can enjoy posts. Interacting with posts requires a login.",
      //   child: Icon(Icons.info_outline, size: 14),
      // ),
