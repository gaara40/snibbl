import 'package:flutter/material.dart';
import 'package:storygram/widgets/comment_section.dart';

void onTapComment(BuildContext context) {
  // Getting the navigator context to avoid PersistentTabView interference
  showModalBottomSheet(
    context: Navigator.of(context, rootNavigator: true).context,
    useSafeArea: false,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
    builder: (ctx) {
      return CommentSection();
    },
  );
}

void showComments(BuildContext context) {
  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const CommentSection(),
  );
}
