import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:storygram/components/social_login_button.dart';
import 'package:storygram/constants/assets.dart';
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
  bool _obscureText = true;
  bool _loading = false;
  bool _guestLoading = false;

  //controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //handle login
  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: 'Please try again',
        backgroundColor: AppTheme.primaryColor,
      );
      return;
    }

    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    final auth = ref.read(authServiceProvider);

    try {
      await auth.logInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (mounted) {
        final email = auth.currentUserEmail();
        Fluttertoast.showToast(
          msg: 'Welcome $email',
          backgroundColor: AppTheme.primaryColor,
        );
      }

      await Future.delayed(Duration(seconds: 2));
    } catch (e) {
      if (mounted) {
        final errorMessage =
            e is Exception
                ? e.toString().replaceFirst('Exception: ', '')
                : e.toString();

        Fluttertoast.showToast(
          msg: errorMessage,
          backgroundColor: AppTheme.primaryColor,
        );
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  //handle guest login
  Future<void> _handleGuestLogin() async {
    setState(() {
      _guestLoading = true;
    });

    final navigator = Navigator.of(context);
    final authServices = ref.read(authServiceProvider);

    final success = await authServices.continueAsGuest();

    if (success) {
      await Future.delayed(Duration(milliseconds: 1000));
      await FirebaseAuth.instance.currentUser?.reload(); // Force reload again

      final updatedName = FirebaseAuth.instance.currentUser?.displayName;
      debugPrint('Navigating with display name: $updatedName');

      navigator.pushNamedAndRemoveUntil('/homeScreen', (route) => false);
    } else {
      setState(() {
        _guestLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppTheme.surfaceColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //LOGO
                SizedBox(
                  height: 220,
                  child: Center(
                    child: Image.asset(
                      AppAssets.appNameLogo,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

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
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          fillColor: AppTheme.secondaryColor,
                          filled: true,
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: AppTheme.inversePrimary,
                              width: 2.5,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: AppTheme.onSecondaryColor,
                            ),
                          ),
                          labelStyle: TextStyle(color: AppTheme.onPrimaryColor),
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email_outlined),
                          prefixIconColor: AppTheme.onPrimaryColor,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required.';
                          } else if (!RegExp(
                            r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value.trim())) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),

                      //PASSWORD TEXTFIELD
                      TextFormField(
                        controller: _passwordController,

                        decoration: InputDecoration(
                          fillColor: AppTheme.secondaryColor,
                          filled: true,
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: AppTheme.inversePrimary,
                              width: 2.5,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: AppTheme.onSecondaryColor,
                            ),
                          ),
                          labelStyle: TextStyle(color: AppTheme.onPrimaryColor),
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: AppTheme.onPrimaryColor,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        obscureText: _obscureText,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required.';
                          } else if (value.trim().length < 6) {
                            return 'Password must be at least 6 characters.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 5),

                      //FORGOT PASSWORD
                      Padding(
                        padding: const EdgeInsets.only(top: 5, right: 5),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              // goto forgot password screen
                              Navigator.pushNamed(context, '/forgotPwdScreen');
                            },
                            child: Text(
                              'Forgot Password?',
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      //LOGIN BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 60,

                        child:
                            _loading
                                ? Center(child: CircularProgressIndicator())
                                : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: AppTheme.onPrimaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: _handleLogin,
                                  child: Text(
                                    'Login',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 18),

                //CONTINUE AS GUEST TEXT
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _guestLoading
                        ? Center(child: CircularProgressIndicator())
                        : Text.rich(
                          TextSpan(
                            text: "Continue as a ",
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: "Guest",
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = _handleGuestLogin,
                                style: theme.textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                    // SizedBox(width: 6),
                    // Tooltip(
                    //   message:
                    //       "As readers, guest users can enjoy and like posts. Creating or saving posts requires an account.",
                    //   child: Icon(Icons.info_outline, size: 14),
                    // ),
                  ],
                ),

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

                //social logins
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //GOOGLE SIGN-IN
                    SocialLoginButton(
                      logoAssetPath: AppAssets.googleLogo,
                      onTap: () {
                        //google sign-in method
                        AuthServices().signInWithGoogle();
                      },
                    ),

                    SizedBox(width: 18),
                  ],
                ),

                SizedBox(height: 80),

                //NEW USER SIGNUP
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Signup',
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    //goto Signup Screen
                                    Navigator.pushNamed(
                                      context,
                                      '/signUpScreen',
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
