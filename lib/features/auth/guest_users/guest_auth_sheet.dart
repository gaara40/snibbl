import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/core/constants/assets.dart';
import 'package:storygram/features/auth/helpers/auth_handlers.dart';
import 'package:storygram/features/auth/presentation/widgets/email_text_field.dart';
import 'package:storygram/features/auth/presentation/widgets/loading_button.dart';
import 'package:storygram/features/auth/presentation/widgets/password_text_field.dart';
import 'package:storygram/features/auth/presentation/widgets/social_login_button.dart';
import 'package:storygram/features/auth/presentation/widgets/username_text_field.dart';

class GuestAuthSheet extends ConsumerStatefulWidget {
  const GuestAuthSheet({super.key});

  @override
  ConsumerState<GuestAuthSheet> createState() => _GuestAuthSheetState();
}

class _GuestAuthSheetState extends ConsumerState<GuestAuthSheet> {
  final _formKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  bool isLoginLoading = false;
  bool isGoogleLoading = false;
  bool isLogin = false;

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void togglePassword() {
    setState(() => obscurePassword = !obscurePassword);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 18,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                const Text(
                  "Join Snibbl",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Sign up or log in to enjoy the full experience.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 25),

                // Email Field
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      EmailTextField(controller: emailController),

                      const SizedBox(height: 10),

                      // Password Field
                      PasswordTextField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        toggleVisibility: togglePassword,
                      ),
                      const SizedBox(height: 10),

                      // Username (only for signup)
                      if (!isLogin) ...[
                        UsernameTextField(controller: usernameController),
                        const SizedBox(height: 10),
                      ],

                      SizedBox(height: isLogin ? 15 : 0),
                      // Signup / Login Button
                      LoadingButton(
                        text: isLogin ? 'Login' : 'Signup',
                        onPressed: () {
                          isLogin
                              ? handleEmailLogin(
                                  context: context,
                                  ref: ref,
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  onStart: () {
                                    setState(() => isLoginLoading = true);
                                  },
                                  onEnd: () {
                                    setState(() => isLoginLoading = false);
                                  },
                                  formKey: _formKey,
                                )
                              : handleEmailSignup(
                                  context: context,
                                  ref: ref,
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  username: usernameController.text.trim(),
                                  onStart: () {
                                    setState(() => isLoginLoading = true);
                                  },
                                  onEnd: () {
                                    setState(() => isLoginLoading = false);
                                  },
                                  formKey: _formKey,
                                );
                        },
                        loading: isLoginLoading,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Google sign-in
                SocialLoginButton(
                  logoAssetPath: AppAssets.googleLogo,
                  isLoading: isGoogleLoading,
                  onTap: () {
                    handleGoogleSignIn(
                      context: context,
                      ref: ref,
                      onStart: () {
                        setState(() => isGoogleLoading = true);
                      },
                      onEnd: () {
                        setState(() => isGoogleLoading = false);
                      },
                    );
                  },
                  // onTap: () async {
                  //   final googleUserCred = await ref
                  //       .read(authServiceProvider)
                  //       .signInWithGoogle();

                  //   if (googleUserCred == null) {
                  //     //User cancelled sign-in
                  //     return;
                  //   } else {
                  //     if (!mounted) return;
                  //     navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  //       '/mainScreen',
                  //       (route) => false,
                  //     );
                  //     // Using a safe fallback for display name
                  //     final name = googleUserCred.displayName;
                  //     showToast(
                  //       name != null && name.isNotEmpty
                  //           ? 'Welcome $name!'
                  //           : 'Welcome to Snibbl!',
                  //     );
                  //   }
                  // },
                ),

                const SizedBox(height: 25),

                // Toggle between login/signup
                Text.rich(
                  TextSpan(
                    text: isLogin
                        ? "Don't have an account? "
                        : 'Already have an account? ',
                    children: [
                      //Actual button
                      TextSpan(
                        text: isLogin ? "Signup" : "Login",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Reset form and toggle
                            _formKey.currentState?.reset();

                            // Clear the inputs
                            emailController.clear();
                            passwordController.clear();
                            if (!isLogin) usernameController.clear();

                            // Toggle state
                            setState(() => isLogin = !isLogin);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        //Cancel Button
        Positioned(
          right: 12,
          top: 12,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.cancel, size: 22),
          ),
        ),
      ],
    );
  }
}
