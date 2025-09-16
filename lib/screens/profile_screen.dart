import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:storygram/constants/assets.dart';
import 'package:storygram/helpers/toasts.dart';
import 'package:storygram/main.dart';
import 'package:storygram/global_providers/auth_providers.dart';
import 'package:storygram/themes/app_theme.dart';
import 'package:storygram/widgets/saved_posts_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  //Logout Logic
  void logoutLogic() async {
    final authServices = ref.read(authServiceProvider);
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
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    final email = currentUser!.email;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            //LOGO
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: SizedBox(
                    height: 45,
                    child: Image.asset(
                      AppAssets.appNameLogo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Row(
                    children: [
                      // SAVED POSTS BUTTON
                      IconButton(
                        icon: Icon(Icons.bookmark, size: 28),
                        onPressed: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: const SavedPostsWidget(),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                      ),

                      // LOGOUT BUTTON
                      IconButton(
                        icon: Icon(Icons.logout, size: 25),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Logout"),
                                content: Text(
                                  "Are you sure you want to logout?",
                                ),
                                actions: [
                                  //Cancel Option
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pop(); // close dialog
                                    },
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                        color: AppTheme.onSecondaryColor,
                                      ),
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
                                      style: TextStyle(
                                        color: AppTheme.onSecondaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Center(child: Text('Profile', style: TextStyle(fontSize: 15))),

            SizedBox(height: 18),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Main Content will come here
                    Center(child: Text('Current User: $email')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
