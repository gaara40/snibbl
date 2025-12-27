import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storygram/features/auth/guest_users/show_guest_login_sheet.dart';

void onTapSaveBtn(BuildContext context, bool isSaved, String postId) async {
  final currentUser = FirebaseAuth.instance.currentUser;

  // Check if user is anonymous/guest
  if (currentUser != null && currentUser.isAnonymous) {
    await showGuestLoginSheet(context);
    return;
  }

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
