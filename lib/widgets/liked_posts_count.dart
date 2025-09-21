import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikedPostsCount extends StatelessWidget {
  const LikedPostsCount({super.key});

  @override
  Widget build(BuildContext context) {
    //Current User
    final currentUser = FirebaseAuth.instance.currentUser;

    final query =
        FirebaseFirestore.instance
            .collection('posts')
            .where('likes', arrayContains: currentUser!.email)
            .count();

    return FutureBuilder<AggregateQuerySnapshot>(
      future: query.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("0");
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
