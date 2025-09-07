import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storygram/comments/model/comment_model.dart';

class CommentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream comments for a specific post
  Stream<List<CommentModel>> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => CommentModel.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }

  /// Post a new comment
  Future<void> postComment(String postId, CommentModel comment) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(comment.toMap());
  }
}
