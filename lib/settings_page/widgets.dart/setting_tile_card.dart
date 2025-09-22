import 'package:flutter/material.dart';
import 'package:storygram/themes/app_theme.dart';

class SettingTileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const SettingTileCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.bottomNavBarColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: ListTile(leading: Icon(icon), title: Text(title), onTap: onTap),
    );
  }
}
