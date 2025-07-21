import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCred;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseError(e));
    }
  }

  Future<UserCredential?> logInWithEmail(String email, String password) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCred;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseError(e));
    }
  }

  Exception _handleFirebaseError(FirebaseAuthException e) {
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

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
