import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseFirestore = FirebaseFirestore.instance;

  //current user
  User? get currentUser => _firebaseAuth.currentUser;

  //current user email
  String get currentUserEmail =>
      _firebaseAuth.currentUser?.email ?? 'guest_user';

  //current user ID
  String get currentUserId => _firebaseAuth.currentUser?.uid ?? 'guest_user';

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

  //signup guest user helper to delete any existing guest user
  Future<void> deleteGuestIfAny() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.isAnonymous) {
      final uid = user.uid;

      // Delete Firestore guest doc (optional)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .delete()
          .catchError((_) {});

      // Try deleting the anonymous auth account
      try {
        await user.delete();
      } catch (_) {
        //If token is stale, force sign-out
        await FirebaseAuth.instance.signOut();
      }
    }
  }

  //signup fresh user with email and password handling guest users
  Future<UserCredential> signUpGuest(
    String email,
    String password,
    String username,
  ) async {
    await deleteGuestIfAny();

    final cred = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firebaseFirestore.collection('users').doc(cred.user!.uid).set({
      'email': email,
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return cred;
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

  //login with email and password handling guest users
  Future<UserCredential?> logInWithEmailGuest(
    String email,
    String password,
  ) async {
    try {
      final current = _firebaseAuth.currentUser;

      if (current != null && current.isAnonymous) {
        // Try deleting the anonymous account; if it fails, sign it out
        try {
          await current.delete();
        } catch (e) {
          debugPrint(
            'Failed to delete anonymous user before sign-in: $e; signing out instead.',
          );
          try {
            await _firebaseAuth.signOut();
          } catch (e2) {
            debugPrint('Failed to sign out anonymous user: $e2');
          }
        }
      }

      final userCred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCred;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseLoginError(e);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // STEP 1 — If user is guest, delete them completely
    final current = _firebaseAuth.currentUser;

    if (current != null && current.isAnonymous) {
      try {
        final guestUid = current.uid;

        // Delete Firestore guest doc (if exists)
        await _firebaseFirestore
            .collection('users')
            .doc(guestUid)
            .delete()
            .catchError((_) {});

        // Try deleting guest auth account
        await current.delete();
      } catch (e) {
        debugPrint('Failed to delete guest user: $e');
        await _firebaseAuth.signOut(); // fallback
      }
    }

    // STEP 2 — Begin Google sign-in flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // STEP 3 — Final Google sign-in using fresh state
    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    // STEP 4 — Create Firestore doc only if new Google user
    final user = userCredential.user;

    if (user != null) {
      final doc = _firebaseFirestore.collection('users').doc(user.uid);
      final snap = await doc.get();

      if (!snap.exists) {
        await doc.set({
          'uid': user.uid,
          'email': user.email,
          'username': user.displayName ?? '',
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
