import 'package:flutter/material.dart';
import 'package:storygram/widgets/comment_section.dart';

void onTapCommentBtn(
  BuildContext context, {
  required String postId,
  required String currentUserId,
  required String username,
}) {
  showModalBottomSheet(
    context: Navigator.of(context, rootNavigator: true).context,
    useSafeArea: false,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
    builder: (ctx) {
      return CommentSection(postId, currentUserId, username);
    },
  );
}
