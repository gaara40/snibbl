import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/features/comments/providers/comment_count_provider.dart';
import 'package:storygram/features/profile/providers/username_provider.dart';
import 'package:storygram/features/posts/helpers/on_like_tap_btn.dart';
import 'package:storygram/features/posts/helpers/on_tap_comment_btn.dart';
import 'package:storygram/features/posts/helpers/on_tap_likes_count.dart';
import 'package:storygram/features/posts/helpers/on_tap_save_btn.dart';
import 'package:storygram/features/posts/providers/post_provider.dart';
import 'package:storygram/features/profile/providers/saved_post_provider.dart';
import 'package:storygram/core/themes/app_theme.dart';
import 'package:storygram/features/posts/presentation/widgets/post_card.dart';

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
    //Current UserName Provider
    final userAsync = ref.watch(usernameProvider);

    //Post Provider
    final postSnapshot = ref.watch(postProvider(widget.postId));

    //Comments Count Provider
    final commentCountAsync = ref.watch(commentCountProvider(widget.postId));

    if (postSnapshot.isLoading ||
        userAsync.isLoading ||
        commentCountAsync.isLoading) {
      return Container(
        //Loading State
        height: 400,
        decoration: BoxDecoration(
          color: AppTheme.loadingCardColor.withValues(alpha: 0.5),
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

    //Current User Username
    final username = userAsync.value ?? 'Anonymous';
    debugPrint('Current USername: $username');

    //Comments Count
    final commentCount = commentCountAsync.value ?? 0;

    //Saved Post Provider
    final savedPostsAsync = ref.watch(savedPostProvider);

    //Saved Posts
    final savedPosts = savedPostsAsync.value ?? [];

    final isSaved = savedPosts.contains(widget.postId);

    //Likes-Stream
    final likesStream =
        FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('likes')
            .snapshots();

    return StreamBuilder(
      stream: likesStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: 400,
            decoration: BoxDecoration(
              color: AppTheme.loadingCardColor.withValues(alpha: 0.5),
              border: Border.all(color: AppTheme.inverseSecondary),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          );
        }

        //List Of User-Ids
        final likedDocs = snapshot.data!.docs;
        final likedUserIds = likedDocs.map((doc) => doc.id).toList();

        //Check if current user liked the post
        isLiked = likedUserIds.contains(currentUser!.uid);

        return GestureDetector(
          //show full post(poem) on tapping the card
          onTap: widget.onTap,

          child: PostCard(
            username: data['username'] ?? 'undefined_user',
            text: data['post'] ?? 'Nothing to read here:(',
            createdAt: (data['createdAt'] as Timestamp).toDate(),
            fontSize: (data['fontSize'] ?? 18).toDouble(),
            fontStyle: data['fontStyle'] ?? 'poppins',
            textAlignment: _mapAlignment(data['textAlignment']),
            isBold: data['isBold'] ?? false,
            likes: likedUserIds,
            likesCount: likedUserIds.length.toString(),
            isLiked: isLiked,
            onLikeTap: () {
              onLikeTapBtn(context, isLiked, widget.postId);
              setState(() {
                isLiked = !isLiked;
              });
            },
            onCommentTap: () {
              onTapCommentBtn(
                context,
                postId: widget.postId,
                currentUserId: currentUser!.uid,
                username: username,
              );
            },
            onSaveTap: () {
              onTapSaveBtn(context, isSaved, widget.postId);
            },
            commentCount: commentCount,
            isSaved: isSaved,
            onLikesCountTap: () {
              onLikesCountTap(context, postId: widget.postId);
            },
          ),
        );
      },
    );
  }

  TextAlign _mapAlignment(String? textAlign) {
    switch (textAlign) {
      case "TextAlign.center":
      case "center":
        return TextAlign.center;

      case "TextAlign.right":
      case "right":
        return TextAlign.right;

      case "TextAlign.justify":
      case "justify":
        return TextAlign.justify;

      case "TextAlign.left":
      case "left":
      default:
        return TextAlign.left;
    }
  }
}
