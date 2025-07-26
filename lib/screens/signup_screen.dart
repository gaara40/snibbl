import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:storygram/constants/assets.dart';
import 'package:storygram/providers/auth_providers.dart';
import 'package:storygram/themes/app_theme.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _loading = false;

  //controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
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
      await auth.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      //logging out user immediately to force login
      await auth.signOut();

      Fluttertoast.showToast(
        msg: 'SignIn Successful. Please Login',
        backgroundColor: AppTheme.primaryColor,
      );

      await Future.delayed(Duration(seconds: 2));

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/loginScreen',
          (route) => false,
        );
      }
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
                  'Let’s get started 🚀',
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
                      SizedBox(height: 28),

                      //SIGNUP BUTTON
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
                                  onPressed: () {
                                    _handleSignUp();
                                  },
                                  child: Text(
                                    'Signup',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
