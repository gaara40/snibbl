import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/firebase_options.dart';
import 'package:storygram/launcher/splash_launcher.dart';
import 'package:storygram/screens/forgot_pwd_screen.dart';
import 'package:storygram/screens/home_screen.dart';
import 'package:storygram/screens/login_screen.dart';
import 'package:storygram/screens/signup_screen.dart';
import 'package:storygram/themes/app_theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();

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
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const Splashlauncher(),
        '/loginScreen': (context) => const LoginScreen(),
        '/signUpScreen': (context) => const SignupScreen(),
        '/forgotPwdScreen': (context) => const ForgotPwdScreen(),
        '/homeScreen': (context) => const HomeScreen(),
      },
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
    );
  }
}
