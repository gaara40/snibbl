import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/global_providers/user_provider.dart';

class CommentCard extends ConsumerWidget {
  const CommentCard({super.key, required this.userId, required this.comment});

  final String userId;

  final String comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final userAsync = ref.watch(userProvider(userId));

    return userAsync.when(
      data: (userDoc) {
        final userData = userDoc.data() as Map<String, dynamic>?;
        final username = userData?['username'] ?? 'unknown_user';

        return ListTile(
          dense: true,
          leading: CircleAvatar(radius: 18, child: Text(username[0])),
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
      },
      loading: () => const ListTile(title: Text("Loading...")),
      error: (e, _) => ListTile(title: Text("Error: $e")),
    );
  }
}
