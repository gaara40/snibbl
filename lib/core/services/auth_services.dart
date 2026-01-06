import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:storygram/core/helpers/handle_firebase_login_error.dart';

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
      throw handleFirebaseLoginError(e);
    }
  }

  //signup fresh user with email and password handling guest users
  Future<UserCredential> signUpGuest(
    String email,
    String password,
    String username,
  ) async {
    // await deleteGuestIfAny();

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
      throw handleFirebaseLoginError(e);
    }
  }

  //login with email and password handling guest users
  Future<UserCredential?> logInWithEmailGuest(
    String email,
    String password,
  ) async {
    try {
      final userCred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCred;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase error code: ${e.code}');
      rethrow;
    }
  }

  //Google sign-in
  Future<User?> signInWithGoogle() async {
    try {
      // STEP 1 - Initialize Google Sign-In
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '585648107348-qm1h823amdfe00mlf39a2tursrfgbu4d.apps.googleusercontent.com',
      );

      // STEP 2 - Begin Google sign-in flow
      final googleUser = await GoogleSignIn.instance.authenticate();

      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // STEP 3 - Final Google sign-in using fresh state
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      // STEP 4 - Create Firestore doc only if new Google user
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

      return user;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        debugPrint('Google sign-in canceled by user');
        return null;
      }
      rethrow;
    }
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
      await GoogleSignIn.instance.signOut();
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
      throw handleFirebaseLoginError(e);
    }
  }
}

//handle exception errors
