import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final savedPostProvider = StreamProvider<List<String>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .snapshots()
      .map((doc) {
        final data = doc.data();
        if (data == null) return [];
        return List<String>.from(data['savedPosts'] ?? []);
      });
});
