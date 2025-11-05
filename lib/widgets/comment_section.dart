import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/comments/model/comment_model.dart';
import 'package:storygram/comments/providers/comment_providers.dart';
import 'package:storygram/helpers/toasts.dart';
import 'package:storygram/themes/app_theme.dart';
import 'package:storygram/widgets/comment_card.dart';

class CommentSection extends ConsumerStatefulWidget {
  const CommentSection(
    this.postId,
    this.currentUserId,
    this.username, {
    super.key,
  });

  final String postId;
  final String currentUserId;
  final String username;

  @override
  ConsumerState<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends ConsumerState<CommentSection> {
  //controller
  final _commentController = TextEditingController();

  //Current User
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _postComment() async {
    final text = _commentController.text.trim();

    // Check if the input is empty
    if (text.isEmpty) {
      debugPrint("No comment entered");
      return;
    }

    debugPrint("Posting comment: $text");
    debugPrint("postId: ${widget.postId}");
    debugPrint("currentUserId: ${widget.currentUserId}");
    debugPrint("username: ${widget.username}");

    try {
      final comment = CommentModel(
        id: '',
        userId: widget.currentUserId,
        comment: text,
        timestamp: DateTime.now(),
      );

      await ref
          .read(commentRepositoryProvider)
          .postComment(widget.postId, comment);

      debugPrint("Comment posted successfully!");

      _commentController.clear();
      if (mounted) {
        FocusScope.of(context).unfocus();
      }
    } catch (e, s) {
      debugPrint("Failed to post comment: $e");
      debugPrint("STACKTRACE: $s");
      showToast("Error posting comment: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final commentsAsync = ref.watch(commentsProvider(widget.postId));

    return Container(
      // Fixed height
      height: screenHeight * 0.7,
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 35,
            height: 3,
            decoration: BoxDecoration(
              color: AppTheme.onSecondaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Comments Headline
          const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Text(
              "Comments",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          Divider(color: AppTheme.onPrimaryColor.withValues(alpha: 0.3)),

          // Comments List
          Expanded(
            child: commentsAsync.when(
              data: (comments) {
                if (comments.isEmpty) {
                  return const Center(child: Text("No comments yet"));
                }
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return CommentCard(
                      userId: comment.userId,
                      comment: comment.comment,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
            ),
          ),
          /*child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            children: const [
              CommentCard(
                username: 'User234',
                avatar: 'U',
                comment: 'This is nice',
              ),
              CommentCard(
                username: 'Flutterdev',
                avatar: 'F',
                comment: 'Great lines',
              ),
              // Add more comments...
            ],
          ),*/

          // Input field container
          Container(
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor,
              border: Border(
                top: BorderSide(
                  color: AppTheme.inverseSecondary.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
            ),
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 8.0,
              // Extra padding for persistent nav bar + keyboard
              bottom:
                  keyboardHeight > 0
                      ? keyboardHeight +
                          20 // Extra padding when keyboard is visible
                      : bottomPadding +
                          20, // Extra padding when keyboard is hidden
            ),
            child: Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: const InputDecoration(
                              hintText: "Add a comment...",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _postComment(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Color.fromARGB(255, 127, 107, 85),
                          ),
                          onPressed: _postComment,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget _buildComment({
//   required String username,
//   required String timeAgo,
//   required String comment,
//   required int likes,
//   required bool hasReplies,
// }) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const CircleAvatar(radius: 16),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               RichText(
//                 text: TextSpan(
//                   style: const TextStyle(color: Colors.black, fontSize: 14),
//                   children: [
//                     TextSpan(
//                       text: username,
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     const TextSpan(text: ' '),
//                     TextSpan(text: comment),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 children: [
//                   Text(
//                     timeAgo,
//                     style: TextStyle(color: Colors.grey[500], fontSize: 12),
//                   ),
//                   const SizedBox(width: 16),
//                   if (likes > 0)
//                     Text(
//                       '$likes ${likes == 1 ? 'like' : 'likes'}',
//                       style: TextStyle(
//                         color: Colors.grey[500],
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   const SizedBox(width: 16),
//                   Text(
//                     'Reply',
//                     style: TextStyle(
//                       color: Colors.grey[500],
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//               if (hasReplies) ...[
//                 const SizedBox(height: 8),
//                 GestureDetector(
//                   onTap: () {},
//                   child: Row(
//                     children: [
//                       Container(width: 24, height: 1, color: Colors.grey[300]),
//                       const SizedBox(width: 8),
//                       Text(
//                         'View replies (2)',
//                         style: TextStyle(
//                           color: Colors.grey[500],
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//         Column(
//           children: [
//             const SizedBox(height: 4),
//             Icon(Icons.favorite_border, size: 16, color: Colors.grey[600]),
//           ],
//         ),
//       ],
//     ),
//   );
// }
