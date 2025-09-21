import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final likedPostsCountProvider = StreamProvider<int>((ref) {
  final email = FirebaseAuth.instance.currentUser?.email;
  if (email == null) return const Stream.empty();
  return FirebaseFirestore.instance
      .collection('posts')
      .where('likes', arrayContains: email)
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
});
