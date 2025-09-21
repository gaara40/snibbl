import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/liked_posts/providers/liked_posts_count_provider.dart';

class LikedPostsCount extends ConsumerWidget {
  const LikedPostsCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(likedPostsCountProvider);

    return countAsync.when(
      data: (count) => Text(count.toString()),
      loading: () => const Text(".."),
      error: (err, _) => const Text("0"),
    );
  }
}
