import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void onLikesCountTap(BuildContext context, {required String postId}) {
  showModalBottomSheet(
    context: Navigator.of(context, rootNavigator: true).context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      // 🔹 Real-time stream of the likes subcollection
      final likesStream =
          FirebaseFirestore.instance
              .collection('posts')
              .doc(postId)
              .collection('likes')
              .snapshots();

      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: StreamBuilder<QuerySnapshot>(
          stream: likesStream,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("No likes yet"),
                ),
              );
            }

            // Extract all userIds (doc IDs)
            final likeUserIds =
                snapshot.data!.docs.map((doc) => doc.id).toList();

            // 🔹 Now fetch all user docs for these IDs (real-time)
            return StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('users')
                      .where(FieldPath.documentId, whereIn: likeUserIds)
                      .snapshots(),
              builder: (ctx, userSnap) {
                if (userSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!userSnap.hasData || userSnap.data!.docs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No users found"),
                    ),
                  );
                }

                final userDocs = userSnap.data!.docs;

                return ListView.builder(
                  itemCount: userDocs.length,
                  itemBuilder: (ctx, index) {
                    final user = userDocs[index];
                    final username = user['username'];

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(username[0].toUpperCase()),
                      ),
                      title: Text(username),
                    );
                  },
                );
              },
            );
          },
        ),
      );
    },
  );
}
