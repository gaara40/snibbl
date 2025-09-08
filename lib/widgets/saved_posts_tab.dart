import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storygram/saved_posts/providers/saved_post_provider.dart';
import 'package:storygram/widgets/post_card.dart';

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

            return ListView.builder(
              itemCount: posts.length,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemBuilder: (context, index) {
                final postData = posts[index].data() as Map<String, dynamic>;

                return PostCard(
                  username: postData['username'] ?? 'Unknown',
                  text: postData['post'] ?? '',
                  createdAt: (postData['createdAt'] as Timestamp).toDate(),
                  fontSize: (postData['fontSize'] ?? 18).toDouble(),
                  fontStyle: postData['fontStyle'] ?? 'poppins',
                  textAlignment: TextAlign.left,
                  isBold: postData['isBold'] ?? false,
                  likes: List<String>.from(postData['likes'] ?? []),
                  likesCount: (postData['likes']?.length ?? 0).toString(),
                  commentCount: 0,
                  isLiked: false,
                  isSaved: true, //Since we're in Saved Tab
                  onLikeTap: () {},
                  onCommentTap: () {},
                  onSaveTap: () {}, // We can allow unsave here too later
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text("Error loading saved posts: $err")),
    );
  }
}
