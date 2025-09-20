import 'package:flutter/material.dart';
import 'package:storygram/themes/app_theme.dart';

class ProfilePostsTabItem extends StatelessWidget {
  const ProfilePostsTabItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.tertiaryColor,
            border:
                isSelected
                    ? Border.all(color: AppTheme.primaryColor, width: 2)
                    : null,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Center(
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}
