import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String userId;
  final String username;
  final String comment;
  final DateTime timestamp;

  CommentModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.comment,
    required this.timestamp,
  });

  // From Firebase document
  factory CommentModel.fromMap(Map<String, dynamic> data, String id) {
    return CommentModel(
      id: id,
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      comment: data['comment'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // To Firebase document
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'comment': comment,
      'timestamp': timestamp,
    };
  }
}
