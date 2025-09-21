import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/helpers/logout_dialog.dart';
import 'package:storygram/helpers/toasts.dart';
import 'package:storygram/widgets/user_posts_count.dart';
import 'package:storygram/main.dart';
import 'package:storygram/global_providers/auth_providers.dart';
import 'package:storygram/themes/app_theme.dart';
import 'package:storygram/widgets/app_bar_logo.dart';
import 'package:storygram/widgets/my_snibbls_tab.dart';
import 'package:storygram/widgets/profile_posts_tab_item.dart';
import 'package:storygram/widgets/saved_posts_tab.dart';
import 'package:storygram/widgets/user_saved_posts_count.dart';
import 'package:storygram/widgets/username_text_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  //Posts Tab Index
  int selectedIndexTab = 0;

  //Logout Logic
  void logoutLogic() async {
    final authServices = ref.read(authServiceProvider);
    try {
      // Sign Out
      await authServices.signOut();

      if (!mounted) return;
      // Navigate Back To Login
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            //Custom AppBar
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //App Logo
                const AppBarLogo(),

                Spacer(),

                //Logout Button
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      // Logout Button
                      IconButton(
                        icon: Icon(Icons.logout, size: 25),
                        onPressed: () {
                          showLogoutDialog(context, logoutLogic);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            Center(
              //User Profile Icon
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryColor, width: 2.5),
                ),
                child: Center(child: LogoUsername(30, FontWeight.bold)),
              ),
            ),

            SizedBox(height: 5),

            //Username Of The User
            Center(child: UsernameTextWidget(25, FontWeight.bold)),

            //Short Bio Of The User
            Center(
              child: Text(
                '"Here comes the bio of user"',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: AppTheme.onSecondaryColor.withValues(alpha: 0.8),
                ),
              ),
            ),

            SizedBox(height: 18),

            //User Stats
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: [UserPostsCount(), Text("Snibbl's")]),
                  SizedBox(width: 40),
                  Container(width: 1, height: 30, color: AppTheme.primaryColor),
                  SizedBox(width: 40),
                  Column(children: [Text('0'), Text("Liked")]),
                  SizedBox(width: 40),
                  Container(width: 1, height: 30, color: AppTheme.primaryColor),
                  SizedBox(width: 40),
                  Column(children: [SavedPostsCount(), Text("Saved")]),
                ],
              ),
            ),

            SizedBox(height: 25),

            //Different Tabs For Viewing Posts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //CurrentUser's Posts
                  ProfilePostsTabItem(
                    label: "My Snibbl's",
                    isSelected: selectedIndexTab == 0,
                    onTap:
                        () => setState(() {
                          selectedIndexTab = 0;
                        }),
                  ),

                  SizedBox(width: 5),

                  //Posts Liked By CurrentUser
                  ProfilePostsTabItem(
                    label: "Liked ",
                    isSelected: selectedIndexTab == 1,
                    onTap:
                        () => setState(() {
                          selectedIndexTab = 1;
                        }),
                  ),

                  SizedBox(width: 5),

                  //Posts Saved By CurrentUser
                  ProfilePostsTabItem(
                    label: "Saved",
                    isSelected: selectedIndexTab == 2,
                    onTap:
                        () => setState(() {
                          selectedIndexTab = 2;
                        }),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4),

            //Displaying Currents User's Posts
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  6,
                  4,
                  6,
                  kBottomNavigationBarHeight + 4,
                ),
                child:
                    selectedIndexTab == 0
                        ? const MySnibblsTab()
                        : selectedIndexTab == 1
                        ? const Center(
                          child: Text(
                            'Liked Posts will appear here\n🚀 This feature will be available soon 🚀',
                            textAlign: TextAlign.center,
                          ),
                        )
                        : const SavedPostsTab(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
