import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:storygram/providers/auth_providers.dart';
import 'package:storygram/themes/app_theme.dart';
import 'package:storygram/widgets/email_text_field.dart';
import 'package:storygram/widgets/password_text_field.dart';
import 'package:storygram/widgets/snibble_logo.dart';
import 'package:storygram/widgets/username_text_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _loading = false;

  //controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  //togglePasswordVisibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
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
        _usernameController.text.trim(),
      );

      //logging out user immediately to force login
      await auth.signOut();

      Fluttertoast.showToast(
        msg: 'Signup Successful. Please Login',
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

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 50),
                //LOGO
                SnibbleLogo(),

                SizedBox(height: 40),

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
                      EmailTextField(controller: _emailController),

                      SizedBox(height: 12),

                      //PASSWORD TEXTFIELD
                      PasswordTextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        toggleVisibility: _togglePasswordVisibility,
                      ),

                      SizedBox(height: 12),

                      //USERNAME TEXTFIELD
                      UsernameTextField(controller: _usernameController),

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
