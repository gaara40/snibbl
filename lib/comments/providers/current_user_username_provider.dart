import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storygram/global_providers/auth_providers.dart';

final currentUserUsernameProvider = FutureProvider<String>((ref) async {
  final currentUser = await ref.watch(authStateProvider.future);

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
