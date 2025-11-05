import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String userId;

  final String comment;
  final DateTime timestamp;

  CommentModel({
    required this.id,
    required this.userId,

    required this.comment,
    required this.timestamp,
  });

  // From Firebase document
  factory CommentModel.fromMap(Map<String, dynamic> data, String id) {
    return CommentModel(
      id: id,
      userId: data['userId'] ?? '',

      comment: data['comment'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // To Firebase document
  Map<String, dynamic> toMap() {
    return {'userId': userId, 'comment': comment, 'timestamp': timestamp};
  }
}
