import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userPostsCountProvider = StreamProvider<int>((ref) {
  final authStream = FirebaseAuth.instance.authStateChanges();

  return authStream.asyncExpand((user) {
    if (user == null) return Stream.value(0);

    return FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  });
});
