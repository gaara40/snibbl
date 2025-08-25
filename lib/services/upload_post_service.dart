import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UploadPostService {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> uploadPost({
    required String userId,
    required String email,
    required String username,
    required double fontSize,
    required String fontStyle,
    required TextAlign textAlignment,
    required bool isBold,
    required String text,
  }) async {
    try {
      //sending data to firestore
      final docRef = await _firebaseFirestore.collection('posts').add({
        'userId': userId,
        'email': email,
        'username': username,
        'fontSize': fontSize,
        'fontStyle': fontStyle,
        'textAlignment': textAlignment.toString(),
        'isBold': isBold,
        'post': text,
        'createdAt': Timestamp.now(),
        'likeCount': 0,
      });

      return docRef.id;
    } catch (e) {
      debugPrint('Error uploading post: $e');
      rethrow;
    }
  }
}
