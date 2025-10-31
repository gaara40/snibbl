import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storygram/settings_page/helpers/email_pass_acc_delete.dart';
import 'package:storygram/settings_page/helpers/google_user_acc_delete.dart';
import 'package:storygram/settings_page/helpers/provider_data.dart';

void showDeleteAccountDialog(BuildContext context, User user) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text('Permanently Delete Account'),
        content: Text(
          'This will permanently delete your account and all associated data.\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (isEmailPassSignedIn(user)) {
                await handleEmailPassAccountDeletion(context, user);
              } else if (isGoogleSignedIn(user)) {
                await handleGoogleUserAccountDeletion(context, user);
              }
            },
            child: Text('Proceed'),
          ),
        ],
      );
    },
  );
}
