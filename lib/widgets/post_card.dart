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
    required this.likeCount,
    required this.isLiked,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onSaveTap,
    required this.commentCount,
  });

  final String username;
  final String text;
  final DateTime createdAt;
  final double fontSize;
  final String fontStyle;
  final TextAlign textAlignment;
  final bool isBold;

  //INTERACTION VARIABLES
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onSaveTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                Spacer(),
              ],
            ),

            const SizedBox(height: 15),

            //POST-TEXT
            Expanded(
              child: Text(
                text,
                textAlign: textAlignment,
                overflow: TextOverflow.ellipsis,
                maxLines: 8,
                style: GoogleFonts.getFont(
                  fontStyle,
                  fontSize: fontSize,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
                ),
              ),
            ),

            // Divider
            Divider(height: 1, thickness: 0.5, color: theme.dividerColor),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Like button
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        // onTap: () {
                        //   showDialog(
                        //     context: context,
                        //     builder: (ctx) {
                        //       return AlertDialog(
                        //         content: Text(
                        //           'Coming soon...',
                        //           style: TextStyle(fontSize: 18),
                        //         ),
                        //       );
                        //     },
                        //   );
                        // },
                        onTap: onLikeTap,
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 25,
                          color: theme.iconTheme.color,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        likeCount == 0 ? '' : '$likeCount',
                        style: theme.textTheme.bodySmall!.copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 15),

                  // Comment button
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        // onTap: () {
                        //   showDialog(
                        //     context: context,
                        //     builder: (ctx) {
                        //       return AlertDialog(
                        //         content: Text(
                        //           'Coming soon...',
                        //           style: TextStyle(fontSize: 18),
                        //         ),
                        //       );
                        //     },
                        //   );
                        // },
                        onTap: onCommentTap,
                        child: Icon(
                          Icons.comment_outlined,
                          size: 25,
                          color: theme.iconTheme.color,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        commentCount == 0 ? '' : '$commentCount',
                        style: theme.textTheme.bodySmall!.copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 15),

                  // Save button
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        // onTap: () {
                        //   showDialog(
                        //     context: context,
                        //     builder: (ctx) {
                        //       return AlertDialog(
                        //         content: Text(
                        //           'Coming soon...',
                        //           style: TextStyle(fontSize: 18),
                        //         ),
                        //       );
                        //     },
                        //   );
                        // },
                        onTap: onSaveTap,
                        child: Icon(
                          Icons.bookmark_outline,
                          size: 25,
                          color: theme.iconTheme.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
