import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

  //Update username
  Future<void> updateUsername(String uid, String newUsername) async {
    try {
      //Update Username in Users Document in Firebase
      await _firestoreInstance.collection('users').doc(uid).update({
        'username': newUsername.trim(),
      });

      //Update Username in Posts Document in Firebase
      final postSnapshots =
          await _firestoreInstance
              .collection('posts')
              .where('userId', isEqualTo: uid)
              .get();

      for (var postDoc in postSnapshots.docs) {
        await postDoc.reference.update({'username': newUsername.trim()});
      }
    } catch (e) {
      throw Exception('Failed to update username: $e');
    }
  }

  //Update Bio
  Future<void> updateUserBio(String uid, String newUserBio) async {
    try {
      await _firestoreInstance.collection('users').doc(uid).update({
        'bio': newUserBio.trim(),
      });
    } catch (e) {
      throw Exception('Failed to update bio: $e');
    }
  }
}
