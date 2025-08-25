import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> toggleLike(String postId, bool isLiked) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
  final likeRef = postRef.collection('likes').doc(uid);

  if (isLiked) {
    await likeRef.delete();
    await postRef.update({'likeCount': FieldValue.increment(-1)});
  } else {
    await likeRef.set({'likedAt': FieldValue.serverTimestamp()});
    await postRef.update({'likeCount': FieldValue.increment(1)});
  }
}
