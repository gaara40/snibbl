import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storygram/core/themes/app_theme.dart';
import 'package:storygram/features/posts/presentation/widgets/posts_item.dart';

class MySnibblsTab extends StatelessWidget {
  const MySnibblsTab({super.key});

  @override
  Widget build(BuildContext context) {
    //Current User
    final currentUser = FirebaseAuth.instance.currentUser;

    //Current User's UID
    final userId = currentUser?.uid;

    final userPostsQuery = FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true);
    return StreamBuilder(
      stream: userPostsQuery.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No Snibbls yet!\nTap + below to add one",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.onPrimaryColor.withValues(alpha: 0.6),
              ),
            ),
          );
        }

        final postDocs = snapshot.data!.docs;

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
