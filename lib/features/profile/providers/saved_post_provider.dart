import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final savedPostProvider = StreamProvider<List<String>>((ref) {
  final authStream = FirebaseAuth.instance.authStateChanges();

  return authStream.asyncExpand((user) {
    if (user == null) return Stream.value(<String>[]);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((doc) {
          final data = doc.data();
          if (data == null) return <String>[];
          return List<String>.from(data['savedPosts'] ?? []);
        });
  });
});
