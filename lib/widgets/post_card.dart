import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.username,
    required this.text,
    required this.createdAt,
    required this.fontSize,
    required this.fontStyle,
    required this.textAlignment,
    required this.isBold,
  });

  final String username;
  final String text;
  final DateTime createdAt;
  final double fontSize;
  final String fontStyle;
  final TextAlign textAlignment;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
            padding: EdgeInsets.all(8),

            child: Column(
              children: [
                Row(
                  children: [
                    //USERNAME LOGO
                    CircleAvatar(
                      radius: 18,
                      child: Text(
                        username.isNotEmpty ? username[0].toUpperCase() : 'NA',
                      ),
                    ),
                    const SizedBox(width: 10),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //USERNAME
                        Text(
                          username.isNotEmpty ? username : 'undefined_user',
                          style: theme.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        //DATE AND TIME
                        Text(
                          _formatDate(createdAt),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                //POST-TEXT
                Text(
                  text,
                  textAlign: textAlignment,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                  style: GoogleFonts.getFont(
                    fontStyle,
                    fontSize: fontSize,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();

    final difference = now.difference(date);

    if (difference.inSeconds < 60) return "${difference.inSeconds}s ago";
    if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
    if (difference.inHours < 24) return "${difference.inHours}h ago";
    if (difference.inDays == 1) return "Yesterday";
    if (difference.inDays < 6) return "${difference.inDays}d ago";

    return DateFormat('d MMM yyyy').format(date);
  }
}
