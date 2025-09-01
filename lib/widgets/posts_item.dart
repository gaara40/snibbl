import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/helpers/on_tap_comment.dart';
import 'package:storygram/helpers/on_tap_save.dart';
import 'package:storygram/providers/post_provider.dart';
import 'package:storygram/themes/app_theme.dart';
import 'package:storygram/widgets/post_card.dart';

class PostsItem extends ConsumerStatefulWidget {
  const PostsItem({super.key, required this.onTap, required this.postId});

  final String postId;
  final VoidCallback onTap;

  @override
  ConsumerState<PostsItem> createState() => _PostsItemState();
}

class _PostsItemState extends ConsumerState<PostsItem> {
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final postSnapshot = ref.watch(postProvider(widget.postId));

    if (postSnapshot.isLoading) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 248, 229, 181),
          border: Border.all(color: AppTheme.inverseSecondary),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      );
    }

    if (!postSnapshot.hasValue || !postSnapshot.value!.exists) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error fetching post',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final data = postSnapshot.value!.data() as Map<String, dynamic>;

    //List of Likes
    final likesList = List<String>.from(data['likes'] ?? []);

    //Checking if the current user has liked or not
    isLiked = likesList.contains(currentUser!.email);

    return GestureDetector(
      //show full post(poem) on tapping the card
      onTap: widget.onTap,

      child: PostCard(
        username: data['username'] ?? 'undefined_user',
        text: data['post'] ?? 'Nothing to read here:(',
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        fontSize: (data['fontSize'] ?? 18).toDouble(),
        fontStyle: data['fontStyle'] ?? 'poppins',
        textAlignment: _mapAlignment(data['textAlign']),
        isBold: data['isBold'] ?? false,
        likes: likesList,
        likesCount: likesList.length.toString(),
        isLiked: isLiked,
        onLikeTap: () async {
          final postRef = FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.postId);

          if (isLiked) {
            // unlike
            await postRef.update({
              'likes': FieldValue.arrayRemove([currentUser!.email]),
            });
          } else {
            // like
            await postRef.update({
              'likes': FieldValue.arrayUnion([currentUser!.email]),
            });
          }

          setState(() {
            isLiked = !isLiked;
          });
        },
        onCommentTap: () {
          onTapComment(context);
        },
        onSaveTap: () {
          onTapSave(context);
        },
        commentCount: 0,
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
