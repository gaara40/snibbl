import 'package:flutter/material.dart';
import 'package:storygram/core/constants/assets.dart';

class AppBarLogo extends StatelessWidget {
  const AppBarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: SizedBox(
        height: 45,
        child: Image.asset(AppAssets.appNameLogo, fit: BoxFit.contain),
      ),
    );
  }
}
