import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/core/services/auth_services.dart';

final userPostsCountProvider = StreamProvider<int>((ref) {
  final uid = AuthServices().currentUserId;
  return FirebaseFirestore.instance
      .collection('posts')
      .where('userId', isEqualTo: uid)
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
});
