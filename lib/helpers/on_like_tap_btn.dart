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

  // Dislike Post
  if (isLiked) {
    await postRef.collection('likes').doc(currentUserId).delete();

    //Delete User's like from the post-owner's activity
    if (postOwnerId != currentUserId) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(postOwnerId)
          .collection('activities')
          .doc(activitesDocId)
          .delete();
    }

    //Delete User's like from likedPosts
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('likedPosts')
        .doc(postId)
        .delete();
  } else
  // Like Post
  {
    await postRef.collection('likes').doc(currentUserId).set({});

    //Add Current user's liked posts
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('likedPosts')
        .doc(postId)
        .set({});

    //Add User's like to the post-owner's activity
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
