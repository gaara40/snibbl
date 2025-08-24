import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseFirestore = FirebaseFirestore.instance;

  //current user email
  currentUserEmail() {
    return _firebaseAuth.currentUser!.email;
  }

  //signup with email and password
  Future<UserCredential?> signUpWithEmail(
    String email,
    String password,
    String username,
  ) async {
    try {
      final userCred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firebaseFirestore.collection('users').doc(userCred.user!.uid).set({
        'email': email,
        'username': username,
      });
      return userCred;
    } on FirebaseAuthException catch (e) {
      debugPrint('Error : $e');
      throw _handleFirebaseLoginError(e);
    }
  }

  //login with email and password
  Future<UserCredential?> logInWithEmail(String email, String password) async {
    try {
      final userCred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCred;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseLoginError(e);
    }
  }

  //Google Sign-in
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);

    final User? user = userCredential.user;

    if (user != null) {
      // Reference to Firestore
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      // Check if user already exists in Firestore
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        // Create a new document if it doesn't exist
        await userDoc.set({
          'uid': user.uid,
          'email': user.email,
          'username': user.displayName ?? "", // Google display name
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }

    return userCredential;
  }

  //reset password
  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  //Sign out
  Future<void> signOut() async {
    final user = _firebaseAuth.currentUser;

    try {
      if (user != null && user.isAnonymous) {
        //delete anonymous user's
        await user.delete();
        debugPrint('Anonymous user deleted');
      }

      await _firebaseAuth.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      debugPrint('Error during sign out: $e');
    }
  }

  //Guest Login
  Future<UserCredential?> continueAsGuest() async {
    try {
      final userCred = await FirebaseAuth.instance.signInAnonymously();

      var user = userCred.user;

      if (user != null) {
        //generating guest username
        final guestDisplayName =
            'guest${user.uid.substring(user.uid.length - 4)}';

        //checking if there's any username and setting the generated username
        if (user.displayName == null || user.displayName!.isEmpty) {
          await user.updateDisplayName(guestDisplayName);
          await user.reload();
        }
      }

      return userCred;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseLoginError(e);
    }
  }
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
