import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:storygram/firebase_options.dart';
import 'package:storygram/screens/login_screen.dart';
import 'package:storygram/screens/splash_screen.dart';
import 'package:storygram/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        // '/authGate': (context) => const AuthGate(),
        '/loginScreen': (context) => const LoginScreen(),
      },
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
    );
  }
}
