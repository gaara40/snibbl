import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:storygram/core/helpers/toasts.dart';
import 'package:storygram/main.dart';

Future<void> handleGoogleUserAccountDeletion(
  BuildContext context,
  User user,
) async {
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  try {
    //Start Google Sign-In flow to reauthenticate//
    final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();

    if (googleUser == null) {
      showToast('Google sign-in cancelled. Account deletion aborted.');
      return;
    }

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    //Reauthenticate user
    await user.reauthenticateWithCredential(credential);

    final uid = user.uid;

    //Delete Firestore user document
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    } catch (e) {
      debugPrint('Firestore cleanup failed: $e');
    }

    //Delete Firebase Auth user
    await user.delete();

    //Revoke Google access
    await googleSignIn.disconnect();

    //Clear Firebase session
    await FirebaseAuth.instance.signOut();

    //Navigate back to login screen
    if (context.mounted) {
      Navigator.pop(context);

      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        '/loginScreen',
        (route) => false,
      );

      showToast('Account deleted successfully');
      debugPrint('Account deleted successfully');
    }
  } catch (e) {
    debugPrint('Error deleting Google account: $e');
    showToast('Failed to delete account. Please try again.');
  }
}
