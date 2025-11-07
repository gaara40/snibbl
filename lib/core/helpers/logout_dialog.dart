import 'package:flutter/material.dart';
import 'package:storygram/core/themes/app_theme.dart';

void showLogoutDialog(BuildContext context, VoidCallback logoutLogic) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          //Cancel Option
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
            },
            child: Text(
              "No",
              style: TextStyle(color: AppTheme.onSecondaryColor),
            ),
          ),

          //Logout Option
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();

              logoutLogic();
            },
            child: Text(
              "Yes",
              style: TextStyle(color: AppTheme.onSecondaryColor),
            ),
          ),
        ],
      );
    },
  );
}
