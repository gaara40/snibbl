import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/services/auth_services.dart';

final likedPostsCountProvider = StreamProvider<int>((ref) {
  final currentUserId = AuthServices().currentUserId;

  return FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserId)
      .collection('likedPosts')
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
});
