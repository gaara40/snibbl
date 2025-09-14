import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityProvider =
    StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, String>((
      ref,
      userId,
    ) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('activities')
          .orderBy('createdAt', descending: true)
          .snapshots();
    });
