import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides the current user's bio and reacts to auth state changes.
final userBioProvider = StreamProvider<String>((ref) {
  final authStream = FirebaseAuth.instance.authStateChanges();

  return authStream.asyncExpand((user) {
    if (user == null) return Stream.value('Unrecognized User');

    if (user.isAnonymous) return Stream.value('Sign in to add your bio');

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map(
          (doc) => doc.data()?['bio'] as String? ?? 'Here comes your short bio',
        );
  });
});
