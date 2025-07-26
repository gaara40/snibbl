import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/providers/auth_providers.dart';
import 'package:storygram/screens/home_screen.dart';
import 'package:storygram/screens/login_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateProvider);
    if (userAsync.isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (userAsync.value != null) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
