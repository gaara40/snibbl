import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:storygram/global_providers/auth_providers.dart';
import 'package:storygram/themes/app_theme.dart';
import 'package:storygram/widgets/snibble_logo.dart';

class ForgotPwdScreen extends ConsumerStatefulWidget {
  const ForgotPwdScreen({super.key});

  @override
  ConsumerState<ForgotPwdScreen> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPwdScreen> {
  final _formKey = GlobalKey<FormState>();

  //controller
  final _emailController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: 'Please enter the details',
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
      auth.forgotPassword(_emailController.text.trim());

      Fluttertoast.showToast(
        msg: 'Password reset link sent successfully',
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
      throw Exception(e);
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
                  "🔒 Forgot your password?",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    "Relax, we’ve got you covered. \nType in your registered email and we’ll send you the reset link.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
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

                      SizedBox(height: 28),

                      //SEND RESET LINK BUTTON
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
                                  onPressed: _sendResetLink,
                                  child: Text(
                                    'Send Reset Link',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: 18,
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
