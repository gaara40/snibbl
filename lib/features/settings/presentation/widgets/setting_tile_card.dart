import 'package:flutter/material.dart';
import 'package:storygram/core/themes/app_theme.dart';

class SettingTileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? subTitle;
  final VoidCallback? onTap;
  final String? trailingText;
  final bool enabled;

  const SettingTileCard({
    super.key,
    required this.icon,
    required this.title,
    this.subTitle,
    this.onTap,
    this.trailingText,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.bottomNavBarColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        enabled: enabled,
        leading: Icon(icon),
        title: Text(title),
        subtitle: subTitle,
        trailing:
            trailingText != null
                ? GestureDetector(
                  onTap: enabled ? onTap : null,
                  child: Text(
                    trailingText!,
                    style: TextStyle(
                      color:
                          enabled
                              ? AppTheme.inverseSecondary
                              : AppTheme.inverseSecondary.withValues(
                                alpha: 0.5,
                              ),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
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
