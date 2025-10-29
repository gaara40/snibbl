import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userBioProvider = StreamProvider<String>((ref) {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return Stream.value('Unrecognized User');

  if (user.isAnonymous) return Stream.value('Sign in to add your bio');

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) => doc.data()?['bio'] ?? 'Here comes your short bio');
});
