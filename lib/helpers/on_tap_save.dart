import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void onTapSave(BuildContext context, bool isSaved, String postId) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  final userRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser!.uid);

  if (isSaved) {
    await userRef.update({
      'savedPosts': FieldValue.arrayRemove([postId]),
    });
  } else {
    await userRef.update({
      'savedPosts': FieldValue.arrayUnion([postId]),
    });
  }
}
