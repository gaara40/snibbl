import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

  //Update username

  Future<void> updateUsername(String uid, String newUsername) async {
    try {
      await _firestoreInstance.collection('users').doc(uid).update({
        'username': newUsername.trim(),
      });
    } catch (e) {
      throw Exception('Failed to update username: $e');
    }
  }
}
