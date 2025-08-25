import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:storygram/widgets/post_card.dart';

class PostsFeed extends StatelessWidget {
  const PostsFeed({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('posts')
                .orderBy("createdAt", descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "No Snibbls yet..\nBe the first to share yours!\nTap the + button below to add one.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          final posts = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(6),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final data = posts[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {},
                child: PostCard(
                  username: data['username'] ?? 'undefined_user',
                  text: data['post'] ?? 'Nothing to read here:(',
                  createdAt: (data['createdAt'] as Timestamp).toDate(),
                  fontSize: (data['fontSize'] ?? 18).toDouble(),
                  fontStyle: data['fontStyle'] ?? 'poppins',
                  textAlignment: _mapAlignment(data['textAlign']),
                  isBold: data['isBold'] ?? false,
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Padding(padding: EdgeInsets.all(6));
            },
          );
        },
      ),
    );
  }

  TextAlign _mapAlignment(String? textAlign) {
    switch (textAlign) {
      case "TextAlign.center":
        return TextAlign.center;

      case "TextAlign.right":
        return TextAlign.right;

      case "TextAlign.justify":
        return TextAlign.justify;

      default:
        return TextAlign.left;
    }
  }
}
