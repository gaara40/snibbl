import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Exception handleFirebaseLoginError(FirebaseAuthException e) {
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