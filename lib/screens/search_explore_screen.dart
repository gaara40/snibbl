import 'package:flutter/material.dart';
import 'package:storygram/features/auth/guest_users/show_guest_login_sheet.dart';

class SearchExploreScreen extends StatelessWidget {
  const SearchExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is Search Section'),
            ElevatedButton(
              onPressed: () {
                showGuestLoginSheet(context);
              },
              child: Text('Guest Login'),
            ),
          ],
        ),
      ),
    );
  }
}
