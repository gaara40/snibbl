import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/features/profile/providers/saved_post_provider.dart';

class SavedPostsCount extends ConsumerWidget {
  const SavedPostsCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedPostsAsync = ref.watch(savedPostProvider);

    return savedPostsAsync.when(
      data: (savedPostIds) {
        final count = savedPostIds.length;
        return Text(count.toString());
      },
      loading: () => const Text(".."),
      error: (err, _) => const Text("0"),
    );
  }
}
