import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StreamProvider.family<DocumentSnapshot, String>((
  ref,
  uid,
) {
  return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
});
