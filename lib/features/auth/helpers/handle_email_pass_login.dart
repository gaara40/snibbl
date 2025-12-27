import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/core/helpers/handle_firebase_login_error.dart';
import 'package:storygram/core/helpers/toasts.dart';
import 'package:storygram/features/auth/providers/auth_providers.dart';
import 'package:storygram/main.dart';

Future<void> handleEmailPassLogin({
  required BuildContext context,
  required WidgetRef ref,
  required String email,
  required String password,
  required VoidCallback onStart,
  required VoidCallback onEnd,
}) async {
  //Start Loading
  onStart();

  //try logging in
  try {
    final authServices = ref.watch(authServiceProvider);
    final userCred = await authServices.logInWithEmailGuest(email, password);

    if (userCred != null && userCred.user != null) {
      final email = authServices.currentUserEmail;
      showToast('Welcome $email');
    }
    await Future.delayed(Duration(seconds: 2));

    if (context.mounted) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        '/mainScreen',
        (route) => false,
      );
    }
  } on FirebaseAuthException catch (e) {
    debugPrint('Firebase error code: ${e.code}');
    final exception = handleFirebaseLoginError(e);

    if (context.mounted) {
      showToast(exception.toString().replaceFirst('Exception: ', ''));
    }
  } finally {
    onEnd();
  }
}

Future<void> handleEmailPassSignup({
  required BuildContext context,
  required WidgetRef ref,
  required String email,
  required String password,
  required String username,
  required VoidCallback onStart,
  required VoidCallback onEnd,
}) async {
  onStart();

  try {
    final authServices = ref.watch(authServiceProvider);
    final userCred = await authServices.signUpGuest(email, password, username);

    if (userCred.user != null) {
      final emailAddr = authServices.currentUserEmail;
      showToast('Welcome $emailAddr');
    }

    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        '/mainScreen',
        (route) => false,
      );
    }
  } on FirebaseAuthException catch (e) {
    debugPrint('Firebase error code: ${e.code}');
    final exception = handleFirebaseLoginError(e);

    if (context.mounted) {
      showToast(exception.toString().replaceFirst('Exception: ', ''));
    }
  } finally {
    onEnd();
  }
}
