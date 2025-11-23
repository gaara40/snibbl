import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the currently authenticated user's username as a reactive stream.
///
/// This provider listens to FirebaseAuth.instance.authStateChanges() so it will
/// automatically update when a user logs out, logs in, or when the auth state
/// changes. For anonymous users it returns the `displayName` (guest name).
final usernameProvider = StreamProvider<String>((ref) {
  final auth = FirebaseAuth.instance;

  // Listen to auth state changes so the provider reacts to login/logout.
  final authStateStream = auth.authStateChanges();

  // For each auth state, switch to the appropriate username stream.
  return authStateStream.asyncExpand((user) {
    if (user == null) {
      // No authenticated user
      return Stream.value('undefined_user');
    }

    if (user.isAnonymous) {
      // Return a single-value stream from the reload future so the
      // provider emits the up-to-date displayName.
      return Stream.fromFuture(
        user.reload().then((_) {
          final current = FirebaseAuth.instance.currentUser;
          return current?.displayName ?? 'undefined_user';
        }),
      );
    }

    // Authenticated non-anonymous user: stream the username from Firestore
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((doc) => doc.data()?['username'] as String? ?? 'unknown_user');
  });
});
