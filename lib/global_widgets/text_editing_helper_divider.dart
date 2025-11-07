import 'package:flutter/material.dart';
import 'package:storygram/core/themes/app_theme.dart';

class TextEditingHelperDivider extends StatelessWidget {
  const TextEditingHelperDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4, bottom: 8),
      child: Divider(color: AppTheme.onPrimaryColor, thickness: 0.5),
    );
  }
}
