import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storygram/features/auth/guest_users/show_guest_login_sheet.dart';
import 'package:storygram/features/comments/presentation/comment_section.dart';

void onTapCommentBtn(
  BuildContext context, {
  required String postId,
  required String currentUserId,
  required String username,
}) async {
  // Check if user is anonymous/guest
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null && currentUser.isAnonymous) {
    await showGuestLoginSheet(context);
    return;
  }

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
