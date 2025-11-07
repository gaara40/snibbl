import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:storygram/core/helpers/toasts.dart';
import 'package:storygram/main.dart';

Future<void> handleGoogleUserAccountDeletion(
  BuildContext context,
  User user,
) async {
  try {
    //Start Google Sign-In flow to reauthenticate//

    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Sign-in Silently or ask for sign-in if required
    GoogleSignInAccount? googleUser =
        await googleSignIn.signInSilently() ?? await googleSignIn.signIn();

    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    //Reauthenticate user
    await user.reauthenticateWithCredential(credential);

    //Delete Firebase user account
    await user.delete();

    //Sign out from both Google & Firebase
    await GoogleSignIn().signOut();
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
