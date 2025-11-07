import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storygram/features/comments/data/comment_model.dart';

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

  Future<void> postComment(String postId, CommentModel comment) async {
    final postRef = _firestore.collection('posts').doc(postId);

    //Add comment
    final commentRef = await postRef
        .collection('comments')
        .add(comment.toMap());

    //Fetch post to know owner
    final postSnap = await postRef.get();
    if (!postSnap.exists) return;

    final postOwnerId = postSnap['userId'];

    //Don't create activity if user comments on their own post
    if (postOwnerId == comment.userId) return;

    //Creating deterministic activityId
    final activityId = '${postId}_${commentRef.id}';

    final userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(comment.userId)
            .get();

    final fromUsername = userDoc.data()?['username'] ?? 'unknown_user';

    // Adding activity
    await _firestore
        .collection('users')
        .doc(postOwnerId)
        .collection('activities')
        .doc(activityId)
        .set({
          'type': 'comment',
          'fromUserId': comment.userId,
          'fromUsername': fromUsername,
          'postId': postId,
          'commentId': commentRef.id,
          'message': '$fromUsername commented: ${comment.comment}',
          'createdAt': FieldValue.serverTimestamp(),
        });
  }
}
