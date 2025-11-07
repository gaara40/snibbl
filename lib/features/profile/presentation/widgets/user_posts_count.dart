import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/features/profile/providers/user_posts_count_provider.dart';

class UserPostsCount extends ConsumerWidget {
  const UserPostsCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(userPostsCountProvider);

    return countAsync.when(
      data: (count) => Text(count.toString()),
      loading: () => const Text(".."),
      error: (err, _) => const Text("0"),
    );
  }
}
