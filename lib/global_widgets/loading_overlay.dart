import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:storygram/core/themes/app_theme.dart';

class LoadingOverlay extends StatelessWidget {
  final String message;
  const LoadingOverlay({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Container(
        color: AppTheme.secondaryColor.withValues(alpha: 0.3),
        padding: const EdgeInsets.only(bottom: 60),
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.onPrimaryColor),
            const SizedBox(height: 10),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600, // cleaner than w700
                color: AppTheme.onPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
