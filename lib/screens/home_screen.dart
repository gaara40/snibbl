import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:storygram/providers/auth_providers.dart';
import 'package:storygram/screens/login_screen.dart';
import 'package:storygram/services/auth_services.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  AuthServices get _authServices => ref.read(authServiceProvider);
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              try {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null && user.isAnonymous) {
                  await _authServices.signOut();
                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                    (route) => false,
                  );
                  return;
                }
                await _authServices.signOut();
              } catch (e) {
                Fluttertoast.showToast(msg: 'Error signing out: $e');
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: Text('Hello $displayName')),
    );
  }
}
