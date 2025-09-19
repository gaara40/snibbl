import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernameProvider = FutureProvider<String>((ref) async {
  final user = FirebaseAuth.instance.currentUser;

  final guestUsername = user?.displayName;

  if (user == null) return 'undefined_user';

  if (user.isAnonymous) return guestUsername ?? 'Guest';

  final doc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  return doc.data()?['username'] ?? 'unknown_user';
});
