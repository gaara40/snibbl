import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/core/helpers/toasts.dart';
import 'package:storygram/features/auth/providers/auth_providers.dart';
import 'package:storygram/main.dart';

Future<void> handleEmailLogin({
  required BuildContext context,
  required WidgetRef ref,
  required String email,
  required String password,
  required VoidCallback onStart,
  required VoidCallback onEnd,
  required GlobalKey<FormState> formKey,
}) async {
  FocusScope.of(context).unfocus();

  //Validate form
  if (!formKey.currentState!.validate()) {
    return;
  }

  //Start Loading
  onStart();

  //try logging in
  try {
    final authServices = ref.read(authServiceProvider);
    final userCred = await authServices.logInWithEmail(email, password);

    if (userCred?.user == null) {
      return;
    }

    final emailAddr = authServices.currentUserEmail;
    showToast('Welcome $emailAddr');

    await Future.delayed(Duration(seconds: 2));

    if (context.mounted) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        '/mainScreen',
        (route) => false,
      );
    }
  } catch (e) {
    debugPrint('Login Failed: $e');

    if (context.mounted) {
      showToast(e.toString().replaceFirst('Exception: ', ''));
    }
  } finally {
    //Finish Loading
    onEnd();
  }
}

Future<void> handleEmailSignup({
  required BuildContext context,
  required WidgetRef ref,
  required String email,
  required String password,
  required String username,
  required VoidCallback onStart,
  required VoidCallback onEnd,
  required GlobalKey<FormState> formKey,
}) async {
  FocusScope.of(context).unfocus();

  //Validate form
  if (!formKey.currentState!.validate()) {
    return;
  }

  //Start Loading
  onStart();

  try {
    final authServices = ref.read(authServiceProvider);
    final userCred = await authServices.signUpWithEmail(
      email,
      password,
      username,
    );

    if (userCred?.user == null) {
      return;
    }

    final emailAddr = authServices.currentUserEmail;
    showToast('Welcome $emailAddr');

    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        '/mainScreen',
        (route) => false,
      );
    }
  } catch (e) {
    debugPrint('SignUp Failed: $e');
    if (context.mounted) {
      showToast(e.toString().replaceFirst('Exception: ', ''));
    }
  } finally {
    //Finish Loading
    onEnd();
  }
}

Future<void> handleGoogleSignIn({
  required BuildContext context,
  required WidgetRef ref,
  required VoidCallback onStart,
  required VoidCallback onEnd,
}) async {
  final authServices = ref.read(authServiceProvider);

  // Start loading
  onStart();

  try {
    final googleUser = await authServices.signInWithGoogle();

    if (googleUser == null) {
      // User cancelled
      return;
    }

    if (!context.mounted) return;

    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      '/mainScreen',
      (route) => false,
    );

    final name = googleUser.displayName;
    showToast(
      name != null && name.isNotEmpty ? 'Welcome $name!' : 'Welcome to Snibbl!',
    );
  } catch (e) {
    if (context.mounted) {
      showToast(e.toString().replaceFirst('Exception: ', ''));
    }
  } finally {
    // Finish loading
    onEnd();
  }
}
