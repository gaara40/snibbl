import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/firebase_authentication/auth_gate.dart';
import 'package:storygram/firebase_options.dart';
import 'package:storygram/screens/forgot_pwd_screen.dart';
import 'package:storygram/screens/login_screen.dart';
import 'package:storygram/screens/signup_screen.dart';
import 'package:storygram/screens/splash_screen.dart';
import 'package:storygram/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/authGate': (context) => AuthGate(),
        '/loginScreen': (context) => const LoginScreen(),
        '/signUpScreen': (context) => const SignupScreen(),
        '/forgotPwdScreen': (context) => const ForgotPwdScreen(),
      },
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
    );
  }
}
