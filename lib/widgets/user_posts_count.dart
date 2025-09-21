import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPostsCount extends StatelessWidget {
  const UserPostsCount({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;

    final aggregateQuery =
        FirebaseFirestore.instance
            .collection('posts')
            .where('userId', isEqualTo: userId)
            .count();

    return FutureBuilder<AggregateQuerySnapshot>(
      future: aggregateQuery.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("..");
        }
        if (snapshot.hasError) {
          return const Text("0");
        }

        final count = snapshot.data?.count ?? 0;
        return Text(count.toString());
      },
    );
  }
}
