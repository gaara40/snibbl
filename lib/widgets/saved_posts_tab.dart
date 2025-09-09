import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storygram/saved_posts/providers/saved_post_provider.dart';
import 'package:storygram/widgets/posts_item.dart';

class SavedPostsTab extends ConsumerWidget {
  const SavedPostsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedPostsAsync = ref.watch(savedPostProvider);

    return savedPostsAsync.when(
      data: (savedPostIds) {
        if (savedPostIds.isEmpty) {
          return const Center(
            child: Text(
              "No saved posts yet",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return FutureBuilder<QuerySnapshot>(
          future:
              FirebaseFirestore.instance
                  .collection('posts')
                  .where(FieldPath.documentId, whereIn: savedPostIds)
                  .orderBy('createdAt', descending: true)
                  .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No saved posts found"));
            }

            final posts = snapshot.data!.docs;

            return ListView.separated(
              padding: EdgeInsets.only(bottom: 8),
              itemBuilder: (context, index) {
                final postId = posts[index].id;
                return PostsItem(onTap: () {}, postId: postId);
              },
              separatorBuilder: (context, index) {
                return Padding(padding: EdgeInsets.all(5));
              },
              itemCount: posts.length,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text("Error loading saved posts: $err")),
    );
  }
}
