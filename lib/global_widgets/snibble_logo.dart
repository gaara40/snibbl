import 'package:flutter/material.dart';
import 'package:storygram/core/constants/assets.dart';

class SnibbleLogo extends StatelessWidget {
  const SnibbleLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppAssets.appNameLogo, height: 80),
              SizedBox(height: 12),
              Text(
                'Poetry, in its smallest, softest form',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
