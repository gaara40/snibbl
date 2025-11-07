import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:storygram/services/auth_services.dart';
import 'package:storygram/themes/app_theme.dart';
import 'package:storygram/widgets/posts_item.dart';

class LikedPostsTab extends StatelessWidget {
  const LikedPostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthServices().currentUserId;

    //Liked Posts Stream
    final likedPostsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .collection('likedPosts')
        .orderBy('likedAt', descending: true);

    return StreamBuilder<QuerySnapshot>(
      stream: likedPostsStream.snapshots(),
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

        final likedPostDocs = snapshot.data!.docs;

        for (var doc in likedPostDocs) {
          debugPrint("Liked Post IDs: ${doc.id}");
        }

        return ListView.separated(
          itemBuilder: (context, index) {
            final postId = likedPostDocs[index].id;
            return PostsItem(onTap: () {}, postId: postId);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Padding(padding: EdgeInsets.all(4));
          },
          itemCount: likedPostDocs.length,
        );
      },
    );
  }
}
