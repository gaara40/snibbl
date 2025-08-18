import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/components/continue_as_guest_btn.dart';
import 'package:storygram/components/email_text_field.dart';
import 'package:storygram/components/forgot_password_btn.dart';
import 'package:storygram/components/loading_button.dart';
import 'package:storygram/components/loading_overlay.dart';
import 'package:storygram/components/new_account_btn.dart';
import 'package:storygram/components/password_text_field.dart';
import 'package:storygram/components/snibble_logo.dart';
import 'package:storygram/components/social_login_button.dart';
import 'package:storygram/constants/assets.dart';
import 'package:storygram/helpers/toasts.dart';
import 'package:storygram/main.dart';
import 'package:storygram/providers/auth_providers.dart';
import 'package:storygram/services/auth_services.dart';
import 'package:storygram/themes/app_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _loading = false;
  bool _guestLoading = false;

  AuthServices get _authServices => ref.read(authServiceProvider);

  //controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //togglePasswordVisibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  //handle login
  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      showToast('Please try again');
      return;
    }

    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    //try logging in
    try {
      final userCred = await _authServices.logInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (userCred != null && userCred.user != null) {
        debugPrint('Logged in successfully');
        if (!mounted) return;

        final email = _authServices.currentUserEmail();
        showToast('Welcome $email');
      }
      await Future.delayed(Duration(seconds: 2));

      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        '/mainScreen',
        (route) => false,
      );
    } catch (e) {
      //catch firebase errors
      if (mounted) {
        final errorMessage =
            e is Exception
                ? e.toString().replaceFirst('Exception: ', '')
                : e.toString();

        showToast(errorMessage);
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  //handle guest login
  Future<void> _handleGuestLogin() async {
    if (mounted) {
      setState(() {
        _guestLoading = true;
      });
    }

    try {
      //try logging in as guest
      final userCred = await _authServices.continueAsGuest();

      if (userCred != null && userCred.user != null) {
        final currentUser = FirebaseAuth.instance.currentUser;
        final currentUserUid = currentUser?.displayName;
        final displayName = currentUserUid.toString();
        debugPrint('Signed in as $displayName');
        if (!mounted) return;
        showToast('Signed in as $displayName');
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          '/mainScreen',
          (route) => false,
        );
      }
    } catch (e) {
      //show firebase errors
      if (mounted) {
        final errorMessage = e.toString().replaceFirst('Exception:', '');
        showToast(errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() {
          _guestLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SizedBox.expand(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 50),

                    //LOGO
                    SnibbleLogo(),

                    SizedBox(height: 40),

                    //WELCOME BACK MESSAGE
                    Text(
                      'Welcome Back 👋',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 18),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          //EMAIL TEXTFIELD
                          EmailTextField(controller: _emailController),

                          SizedBox(height: 12),

                          //PASSWORD TEXTFIELD
                          PasswordTextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            toggleVisibility: _togglePasswordVisibility,
                          ),

                          SizedBox(height: 5),

                          //FORGOT PASSWORD
                          ForgotPasswordBtn(),

                          SizedBox(height: 20),

                          //LOGIN BUTTON
                          LoadingButton(
                            onPressed: _handleLogin,
                            text: 'Login',
                            loading: _loading,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 18),

                    //GUEST LOGIN
                    ContinueAsGuestBtn(handleLogin: _handleGuestLogin),

                    SizedBox(height: 18),

                    //DIVIDER
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: AppTheme.primaryColor,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'OR',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    //google signin
                    SocialLoginButton(
                      logoAssetPath: AppAssets.googleLogo,
                      onTap: AuthServices().signInWithGoogle,
                    ),

                    SizedBox(height: 80),

                    //NEW USER SIGNUP
                    NewAccountBtn(
                      onTap: () {
                        navigatorKey.currentState!.pushNamed('/signupScreen');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child:
                  _guestLoading
                      ? const LoadingOverlay(
                        key: ValueKey('overlay'),
                        message: 'Signing in as a guest...',
                      )
                      : const SizedBox.shrink(key: ValueKey('overlay-empty')),
            ),
          ),
        ],
      ),
    );
  }
}
