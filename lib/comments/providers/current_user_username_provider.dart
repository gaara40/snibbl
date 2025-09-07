import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final currentUserUsernameProvider = FutureProvider<String>((ref) async {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    return 'Anonymous';
  }

  final userDoc =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

  return userDoc.data()?['username'] ?? 'Anonymous';
});
