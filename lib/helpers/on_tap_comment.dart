import 'package:flutter/material.dart';
import 'package:storygram/themes/app_theme.dart';
import 'package:storygram/widgets/comment_overlay.dart';

void onTapComment(BuildContext context) {
  showModalBottomSheet(
    useSafeArea: true,
    backgroundColor: AppTheme.secondaryColor,
    isScrollControlled: true,
    context: context,

    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 5,
        ),
        child: CommentOverlay(),
      );
    },
  );
}

void showComments(BuildContext context) {
  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const InstagramCommentsWidget(),
  );
}
