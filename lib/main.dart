import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/firebase_options.dart';
import 'package:storygram/core/app_start/splash_launcher.dart';
import 'package:storygram/features/activities/presentation/activity_screen.dart';
import 'package:storygram/features/auth/presentation/forgot_pwd_screen.dart';
import 'package:storygram/features/posts/presentation/home_screen.dart';
import 'package:storygram/features/auth/presentation/login_screen.dart';
import 'package:storygram/core/app_shell/main_screen.dart';
import 'package:storygram/features/profile/presentation/profile_screen.dart';
import 'package:storygram/screens/search_explore_screen.dart';
import 'package:storygram/features/auth/presentation/signup_screen.dart';
import 'package:storygram/core/themes/app_theme.dart';

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
        '/mainScreen': (context) => const MainScreen(),
        '/searchExploreScreen': (context) => const SearchExploreScreen(),
        '/activityScreen': (context) => const ActivityScreen(),
        '/profileScreen': (context) => const ProfileScreen(),
        '/homeScreen': (context) => const HomeScreen(),
      },
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
    );
  }
}
