import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final _auth = FirebaseAuth.instance;

  //current user email
  currentUserEmail() {
    return _auth.currentUser!.email;
  }

  //current guest user display name
  guestDisplayName() {
    return _auth.currentUser!.displayName;
  }

  //signup with email and password
  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCred;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseLoginError(e));
    }
  }

  //login with email and password
  Future<UserCredential?> logInWithEmail(String email, String password) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCred;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseLoginError(e));
    }
  }

  //Google Sign-in
  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return;

    final GoogleSignInAuthentication gAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  //reset password
  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  //Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  //Continue as guest
  Future<bool> continueAsGuest() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();

      User? user = userCredential.user;

      if (user != null) {
        if (user.displayName == null || user.displayName!.isEmpty) {
          final guestDisplayName = 'guest${user.uid.substring(0, 5)}';

          await user.updateDisplayName(guestDisplayName);
          await user.reload();
          user = _auth.currentUser;
        }

        debugPrint('Signed in as ${user?.displayName}');
        return true;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Guest sign-in failed: $e');
      debugPrint('Guest sign-in failed : $e');
    }
    return false;
  }

  //handle exception errors
  Exception _handleFirebaseLoginError(FirebaseAuthException e) {
    debugPrint('Firebase error code: ${e.code}');
    switch (e.code) {
      case 'invalid-email':
        return Exception('The email address is not valid.');
      case 'user-disabled':
        return Exception('This account has been disabled.');
      case 'user-not-found':
        return Exception('No user found with this email.');
      case 'wrong-password':
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS':
        return Exception('Incorrect password or email. Please try again.');
      case 'too-many-requests':
        return Exception('Too many requests. Please try again later.');
      case 'user-token-expired':
        return Exception('Session expired. Please log in again.');
      case 'network-request-failed':
        return Exception('No internet connection. Please check your network.');
      case 'email-already-in-use':
        return Exception('This email is already registered. Try Logging In.');
      case 'weak-password':
        return Exception('Password should be at least 6 characters.');
      case 'operation-not-allowed':
        return Exception('Email/password sign-in is not enabled.');
      default:
        return Exception('Something went wrong. Please try again.');
    }
  }
}
