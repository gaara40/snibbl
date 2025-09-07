import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
    required this.username,
    required this.avatar,
    required this.comment,
  });

  final String username;
  final String avatar;
  final String comment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      dense: true,
      leading: CircleAvatar(radius: 18, child: Text(avatar)),
      title: Text(
        username,
        style: theme.textTheme.bodyMedium!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        comment,
        style: theme.textTheme.bodyMedium!.copyWith(fontSize: 13),
      ),
    );
  }
}
