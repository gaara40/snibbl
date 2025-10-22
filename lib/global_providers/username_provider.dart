import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernameProvider = StreamProvider<String>((ref) {
  final user = FirebaseAuth.instance.currentUser;

  final guestUsername = user?.displayName;

  if (user == null) return Stream.value('undefined_user');

  if (user.isAnonymous) return Stream.value(guestUsername!);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) => doc.data()?['username'] ?? 'unknown_user');
});
