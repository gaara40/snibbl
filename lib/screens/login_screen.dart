import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:storygram/components/social_login_button.dart';
import 'package:storygram/constants/assets.dart';
import 'package:storygram/themes/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //LOGO
                SizedBox(
                  height: 180,
                  child: Center(
                    child: Image.asset(
                      AppAssets.appNameLogo,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                //WELCOME BACK MESSAGE
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                            //USERNAME TEXTFIELD
                            TextFormField(
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
                                labelStyle: TextStyle(
                                  color: AppTheme.onPrimaryColor,
                                ),
                                labelText: 'Username',
                                prefixIcon: Icon(Icons.email_outlined),
                                prefixIconColor: AppTheme.onPrimaryColor,
                              ),
                              keyboardType: TextInputType.name,
                            ),
                            SizedBox(height: 12),

                            //PASSWORD TEXTFIELD
                            TextFormField(
                              obscureText: _obscureText,
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
                                labelStyle: TextStyle(
                                  color: AppTheme.onPrimaryColor,
                                ),
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
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: theme.textTheme.displaySmall
                                        ?.copyWith(
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

                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  foregroundColor: AppTheme.onPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () {},
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
                          Text.rich(
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
                                        ..onTap = () {
                                          //goto guest screen/ home screen
                                        },
                                  style: theme.textTheme.displayMedium
                                      ?.copyWith(
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
                                fontSize: 15,
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //GOOGLE SIGN-IN
                          SocialLoginButton(
                            logoAssetPath: AppAssets.googleLogo,
                            onTap: () {
                              //google sign-in method
                            },
                          ),

                          SizedBox(width: 15),

                          //APPLE SIGN-IN
                          SocialLoginButton(
                            logoAssetPath: AppAssets.appleLogo,

                            onTap: () {
                              //apple sign-in method
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 100),

                      //NEW USER SIGNUP
                      Center(
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
                                      },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
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
