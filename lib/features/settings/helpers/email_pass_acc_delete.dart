import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storygram/core/helpers/toasts.dart';
import 'package:storygram/main.dart';

Future<void> handleEmailPassAccountDeletion(
  BuildContext context,
  User user,
) async {
  _showAccountDeleteDialog(context, user);
}

void _showAccountDeleteDialog(BuildContext context, User user) {
  showDialog(
    context: context,
    builder: (ctx) {
      final passController = TextEditingController();
      return AlertDialog(
        title: const Text('Confirm Account Deletion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This action is permanent and cannot be undone.\n\n'
              'Please enter your password to confirm.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final password = passController.text.trim();

              if (password.isEmpty) {
                showToast('Please enter your password');
                return;
              }

              try {
                // Reauthenticate user
                final cred = EmailAuthProvider.credential(
                  email: user.email!,
                  password: password,
                );
                await user.reauthenticateWithCredential(cred);

                // Delete user
                await user.delete();

                // Sign out and navigate
                await FirebaseAuth.instance.signOut();

                if (ctx.mounted) {
                  Navigator.pop(ctx);

                  navigatorKey.currentState!.pushNamedAndRemoveUntil(
                    '/loginScreen',
                    (route) => false,
                  );
                  showToast('Account deleted successfully');
                  debugPrint('Account deleted successfully');
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'requires-recent-login') {
                  showToast('Please log in again to delete your account.');
                } else {
                  showToast('Failed to delete account: ${e.message}');
                }
              } catch (e) {
                showToast('Unexpected error: $e');
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
}
