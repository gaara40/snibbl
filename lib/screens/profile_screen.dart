import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:storygram/constants/assets.dart';
import 'package:storygram/helpers/toasts.dart';
import 'package:storygram/main.dart';
import 'package:storygram/global_providers/auth_providers.dart';
import 'package:storygram/themes/app_theme.dart';
import 'package:storygram/widgets/profile_post_item.dart';
import 'package:storygram/widgets/saved_posts_widget.dart';
import 'package:storygram/widgets/username_text_widget.dart';

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
    //Current User Id
    final currentUser = FirebaseAuth.instance.currentUser;

    final userPostsQuery = FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: currentUser?.uid)
        .orderBy('createdAt', descending: true);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            //App Logo
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
                      // Saved Posts Button
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

                      // Logout Button
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

            SizedBox(height: 8),

            //Username Of The User
            Center(child: UsernameTextWidget(22, FontWeight.bold)),

            SizedBox(height: 2),

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
                  Column(children: [Text('10'), Text("Snibbl's")]),
                  SizedBox(width: 40),
                  Container(width: 1, height: 30, color: AppTheme.primaryColor),
                  SizedBox(width: 40),
                  Column(children: [Text('10'), Text("Liked")]),
                  SizedBox(width: 40),
                  Container(width: 1, height: 30, color: AppTheme.primaryColor),
                  SizedBox(width: 40),
                  Column(children: [Text('10'), Text("Saved")]),
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
                  Expanded(
                    //My Posts
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.tertiaryColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "My Snibbl's",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 5),

                  //Posts Liked By Me
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.tertiaryColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Liked by me",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 5),

                  //Posts Saved By Me
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.tertiaryColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Saved",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4),

            //Displaying Posts
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  6,
                  4,
                  6,
                  kBottomNavigationBarHeight + 4,
                ),
                child: StreamBuilder(
                  stream: userPostsQuery.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final postDocs = snapshot.data!.docs;

                    return GridView.builder(
                      itemCount: postDocs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                      ),
                      itemBuilder: (context, index) {
                        final postId = postDocs[index].id;
                        return ProfilePostItem(postId);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
