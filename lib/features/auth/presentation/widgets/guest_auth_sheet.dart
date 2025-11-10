import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:storygram/core/constants/assets.dart';
import 'package:storygram/core/helpers/toasts.dart';
import 'package:storygram/features/auth/presentation/widgets/email_text_field.dart';
import 'package:storygram/features/auth/presentation/widgets/loading_button.dart';
import 'package:storygram/features/auth/presentation/widgets/password_text_field.dart';
import 'package:storygram/features/auth/presentation/widgets/social_login_button.dart';
import 'package:storygram/features/auth/presentation/widgets/username_text_field.dart';

class GuestAuthSheet extends StatefulWidget {
  const GuestAuthSheet({super.key});

  @override
  State<GuestAuthSheet> createState() => _GuestAuthSheetState();
}

class _GuestAuthSheetState extends State<GuestAuthSheet> {
  bool obscurePassword = true;
  bool isLoading = false;
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
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
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

            // Signup / Login Button
            LoadingButton(
              text: isLogin ? 'Login' : 'Signup',
              onPressed: () {
                setState(() => isLoading = !isLoading);
                showToast(isLogin ? 'Logging in...' : 'Signing up...');
              },
              loading: isLoading,
            ),

            const SizedBox(height: 15),

            // Google sign-in
            SocialLoginButton(
              logoAssetPath: AppAssets.googleLogo,
              onTap: () => showToast('Google sign-in coming soon!'),
            ),

            const SizedBox(height: 25),

            // Toggle between login/signup
            Text.rich(
              TextSpan(
                text:
                    isLogin
                        ? "Don't have an account? "
                        : 'Already have an account? ',
                children: [
                  TextSpan(
                    text: isLogin ? "Signup" : "Login",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            setState(() => isLogin = !isLogin);
                          },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
