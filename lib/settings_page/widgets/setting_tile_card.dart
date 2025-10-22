import 'package:flutter/material.dart';
import 'package:storygram/themes/app_theme.dart';

class SettingTileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? subTitle;
  final VoidCallback? onTap;
  final String? trailingText;

  const SettingTileCard({
    super.key,
    required this.icon,
    required this.title,
    this.subTitle,
    this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.bottomNavBarColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: subTitle,
        trailing:
            trailingText != null
                ? GestureDetector(
                  onTap: onTap,
                  child: Text(
                    trailingText!,
                    style: const TextStyle(
                      color: AppTheme.inverseSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                )
                : null,
        // If no trailing text -> full tile tap works
        onTap: trailingText == null ? onTap : null,
      ),
    );
  }
}
