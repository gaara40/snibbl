import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void onLikesCountTap(BuildContext context, {required String postId}) {
  showModalBottomSheet(
    context: Navigator.of(context, rootNavigator: true).context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),

    builder: (ctx) {
      return FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('posts').doc(postId).get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No data found"));
          }

          // Get the likes array
          List<dynamic> likes = snapshot.data!.get("likes") ?? [];
          List<String> likesList = likes.cast<String>();

          if (likesList.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text("No likes yet"),
              ),
            );
          }

          return ListView.builder(
            itemCount: likesList.length,
            itemBuilder: (ctx, index) {
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(likesList[index]),
              );
            },
          );
        },
      );
    },
  );
}
