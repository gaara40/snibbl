import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/helpers/on_tap_comment.dart';
import 'package:storygram/helpers/on_tap_save.dart';
import 'package:storygram/helpers/toggle_like.dart';
import 'package:storygram/providers/post_provider.dart';
import 'package:storygram/providers/user_like_provider.dart';
import 'package:storygram/widgets/post_card.dart';

class PostsItem extends ConsumerWidget {
  const PostsItem({super.key, required this.onTap, required this.postId});

  final String postId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postSnapshot = ref.watch(postProvider(postId));
    final userLikeSnapshot = ref.watch(userLikeProvider(postId));

    if (postSnapshot.isLoading) {
      return const Center(child: CircularProgressIndicator());
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
    final isLiked = userLikeSnapshot.value?.exists ?? false;

    return GestureDetector(
      //show full post(poem) on tapping the card
      onTap: onTap,

      child: PostCard(
        username: data['username'] ?? 'undefined_user',
        text: data['post'] ?? 'Nothing to read here:(',
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        fontSize: (data['fontSize'] ?? 18).toDouble(),
        fontStyle: data['fontStyle'] ?? 'poppins',
        textAlignment: _mapAlignment(data['textAlign']),
        isBold: data['isBold'] ?? false,
        likeCount: data['likeCount'] ?? 0,
        isLiked: isLiked,
        onLikeTap: () {
          toggleLike(postId, isLiked);
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
