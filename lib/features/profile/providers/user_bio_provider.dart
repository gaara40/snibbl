import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/core/services/auth_services.dart';

final userBioProvider = StreamProvider<String>((ref) {
  final user = AuthServices().currentUser;

  if (user == null) return Stream.value('Unrecognized User');

  if (user.isAnonymous) return Stream.value('Sign in to add your bio');

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) => doc.data()?['bio'] ?? 'Here comes your short bio');
});
