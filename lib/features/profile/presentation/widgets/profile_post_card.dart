import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storygram/core/themes/app_theme.dart';

class ProfilePostTile extends StatelessWidget {
  final String text;
  final double fontSize;
  final String fontStyle;
  final TextAlign textAlignment;
  final bool isBold;

  const ProfilePostTile({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fontStyle,
    required this.textAlignment,
    required this.isBold,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.inverseSecondary.withValues(alpha: 0.2),
        ),

        color: AppTheme.loadingCardColor,
      ),
      child: Center(
        child: Text(
          text,
          maxLines: 6, // show only preview, not full post
          overflow: TextOverflow.ellipsis,
          textAlign: textAlignment,
          style: GoogleFonts.getFont(
            fontStyle,
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
