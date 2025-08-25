import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postProvider = StreamProvider.family<DocumentSnapshot, String>((
  ref,
  postId,
) {
  return FirebaseFirestore.instance.collection('posts').doc(postId).snapshots();
});
