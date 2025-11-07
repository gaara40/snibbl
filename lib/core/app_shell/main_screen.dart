import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:storygram/features/activities/presentation/activity_screen.dart';
import 'package:storygram/features/posts/presentation/add_snibbl_screen.dart';
import 'package:storygram/features/posts/presentation/home_screen.dart';
import 'package:storygram/features/profile/presentation/profile_screen.dart';
import 'package:storygram/screens/search_explore_screen.dart';
import 'package:storygram/core/themes/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      backgroundColor: AppTheme.bottomNavBarColor,
      screens: const [
        HomeScreen(),
        SearchExploreScreen(),
        AddSnibblScreen(),
        ActivityScreen(),
        ProfileScreen(),
      ],
      items: [
        //Home Tab
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: 'Home',
          activeColorPrimary: AppTheme.inversePrimary,
          inactiveColorPrimary: AppTheme.primaryColor,
        ),

        //Search Tab
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.search),
          title: 'Search',
          activeColorPrimary: AppTheme.inversePrimary,
          inactiveColorPrimary: AppTheme.primaryColor,
        ),

        //Add Snibbl
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.add),
          title: 'Add Snibble',
          activeColorPrimary: AppTheme.inversePrimary,
          inactiveColorPrimary: AppTheme.primaryColor,
        ),

        //Activity Tab
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.favorite),
          title: 'Activity',
          activeColorPrimary: AppTheme.inversePrimary,
          inactiveColorPrimary: AppTheme.primaryColor,
        ),

        //Profile Tab
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: 'Profile',
          activeColorPrimary: AppTheme.inversePrimary,
          inactiveColorPrimary: AppTheme.primaryColor,
        ),
      ],

      navBarStyle: NavBarStyle.style13,

      resizeToAvoidBottomInset: false, // This is crucial!
      confineToSafeArea: false, // Set to false for better control
      stateManagement: true,

      // Additional settings that might help:
      handleAndroidBackButtonPress: true,
    );
  }
}
