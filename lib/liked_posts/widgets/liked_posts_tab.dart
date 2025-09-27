import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storygram/themes/app_theme.dart';
import 'package:storygram/widgets/posts_item.dart';

class LikedPostsTab extends StatelessWidget {
  const LikedPostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    final likedPostsQuery = FirebaseFirestore.instance
        .collection('posts')
        .where('likes', arrayContains: currentUser!.email)
        .orderBy('createdAt', descending: true);

    return StreamBuilder<QuerySnapshot>(
      stream: likedPostsQuery.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "You haven't liked any posts yet",
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.onPrimaryColor.withValues(alpha: 0.6),
              ),
            ),
          );
        }

        final postDocs = snapshot.data!.docs;

        for (var doc in postDocs) {
          debugPrint("Liked Post IDs: ${doc.id}");
        }

        return ListView.separated(
          itemBuilder: (context, index) {
            final postId = postDocs[index].id;
            return PostsItem(onTap: () {}, postId: postId);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Padding(padding: EdgeInsets.all(4));
          },
          itemCount: postDocs.length,
        );
      },
    );
  }
}
