import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void onLikeTapBtn(BuildContext context, bool isLiked, String postId) async {
  final currentUser = FirebaseAuth.instance.currentUser;

  final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
  final postSnap = await postRef.get();

  if (!postSnap.exists) return;

  //Post Owner ID
  final postOwnerId = postSnap['userId'];

  //Current user ID
  final currentUserId = currentUser!.uid;

  final currentUserDoc =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

  //Current User's username
  final currentUsername = currentUserDoc['username'];
  debugPrint('Current Username = $currentUsername');

  //Activities Doc ID
  final activitesDocId = '${postId}_$currentUserId';

  if (isLiked) {
    // unlike
    await postRef.update({
      'likes': FieldValue.arrayRemove([currentUser.email]),
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(postOwnerId)
        .collection('activities')
        .doc(activitesDocId)
        .delete();
  } else {
    // like
    await postRef.update({
      'likes': FieldValue.arrayUnion([currentUser.email]),
    });

    if (postOwnerId != currentUserId) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(postOwnerId)
          .collection('activities')
          .doc(activitesDocId) //DETERMINISTIC ID
          .set({
            'type': 'like',
            'fromUserId': currentUserId,
            'fromUsername': currentUsername,
            'postId': postId,
            'message': '$currentUsername liked you post',
            'createdAt': FieldValue.serverTimestamp(),
          });
    }
  }
}
