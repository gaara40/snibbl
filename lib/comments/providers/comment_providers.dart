import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/comments/data/comment_repository.dart';
import 'package:storygram/comments/model/comment_model.dart';

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepository();
});

/// StreamProvider → Live fetching of comments
final commentsProvider = StreamProvider.family<List<CommentModel>, String>((
  ref,
  postId,
) {
  final repo = ref.watch(commentRepositoryProvider);
  return repo.getComments(postId);
});

/// FutureProvider → Posting new comments
final postCommentProvider = FutureProvider.family<void, Map<String, dynamic>>((
  ref,
  params,
) async {
  final repo = ref.watch(commentRepositoryProvider);
  await repo.postComment(params['postId'], params['comment']);
});
