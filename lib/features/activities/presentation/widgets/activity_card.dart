import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.username,
    required this.message,
    required this.postId,
    required this.timeAgo,
  });

  final String username;
  final String message;
  final String postId;
  final String timeAgo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            CircleAvatar(child: Text(username[0].toUpperCase())),
            const SizedBox(width: 8),
            Expanded(
              child: Text('$message.  $timeAgo', softWrap: true, maxLines: 2),
            ),
            const SizedBox(width: 8),
            Text(
              postId.length > 4 ? postId.substring(postId.length - 4) : postId,
            ),
          ],
        ),
      ),
    );
  }
}
