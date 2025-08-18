import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/helpers/toasts.dart';
import 'package:storygram/main.dart';
import 'package:storygram/providers/auth_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authServices = ref.read(authServiceProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              try {
                // sign out
                await authServices.signOut();

                if (!mounted) return;
                // navigate back to login
                navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  '/loginScreen',
                  (route) => false,
                );
              } catch (e) {
                showToast('Error signing out: $e');
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: Text('This is Profile Section')),
    );
  }
}
