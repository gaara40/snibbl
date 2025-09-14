import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void onLikeTapBtn(BuildContext context, bool isLiked, String postId) async {
  final currentUser = FirebaseAuth.instance.currentUser;

  final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

  if (isLiked) {
    // unlike
    await postRef.update({
      'likes': FieldValue.arrayRemove([currentUser!.email]),
    });
  } else {
    // like
    await postRef.update({
      'likes': FieldValue.arrayUnion([currentUser!.email]),
    });
  }
}
