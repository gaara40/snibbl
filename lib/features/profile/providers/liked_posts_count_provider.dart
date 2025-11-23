import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StreamProvider for the count of liked posts. Reacts to auth state
/// changes so it immediately updates after login/logout.
final likedPostsCountProvider = StreamProvider<int>((ref) {
  final authStream = FirebaseAuth.instance.authStateChanges();

  return authStream.asyncExpand((user) {
    if (user == null) return Stream.value(0);

    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('likedPosts')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);

    return userDoc;
  });
});
