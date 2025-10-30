import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storygram/helpers/toasts.dart';
import 'package:storygram/themes/app_theme.dart';

void showChangePasswordDialog(BuildContext context, User user) {
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmNewPassController = TextEditingController();

  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Change Password'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Old Password
              TextField(
                controller: oldPassController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: TextStyle(
                    color: AppTheme.onPrimaryColor.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              //New Password
              TextField(
                controller: newPassController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(
                    color: AppTheme.onPrimaryColor.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              //Confirm New Password
              TextField(
                controller: confirmNewPassController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  labelStyle: TextStyle(
                    color: AppTheme.onPrimaryColor.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          //Cancel the dialog
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.onPrimaryColor),
            ),
          ),

          //Save changes
          ElevatedButton(
            onPressed: () async {
              final oldPass = oldPassController.text.trim();
              final newPass = newPassController.text.trim();
              final confirmNewPass = confirmNewPassController.text.trim();

              if (newPass.isEmpty || oldPass.isEmpty) {
                showToast('All fields are required');
                return;
              }

              if (newPass != confirmNewPass) {
                showToast('New passwords do not match');
                return;
              }

              if (newPass.length < 6) {
                showToast('Password must be at least 6 characters long');
                return;
              }

              try {
                //Re-authenticate User
                final cred = EmailAuthProvider.credential(
                  email: user.email!,
                  password: oldPass,
                );

                await user.reauthenticateWithCredential(cred);

                //Update User password
                await user.updatePassword(newPass);

                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  showToast('Password changed successfully');
                }
              } on FirebaseAuthException catch (e) {
                showToast(e.message ?? 'Failed to change password');
              } catch (e) {
                showToast('Failed to change password: $e');
              }
            },
            child: const Text(
              'Change',
              style: TextStyle(
                color: AppTheme.inversePrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
