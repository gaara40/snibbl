import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:storygram/screens/activity_screen.dart';
import 'package:storygram/screens/add_snibbl_screen.dart';
import 'package:storygram/screens/home_screen.dart';
import 'package:storygram/screens/profile_screen.dart';
import 'package:storygram/screens/search_explore_screen.dart';
import 'package:storygram/themes/app_theme.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PersistentTabController(initialIndex: 0);
    return PersistentTabView(
      context,
      controller: controller,
      backgroundColor: AppTheme.secondaryColor,
      screens: const [
        HomeScreen(),
        SearchExploreScreen(),
        AddSnibblScreen(),
        ActivityScreen(),
        ProfileScreen(),
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home),
          title: 'Home',
          activeColorPrimary: AppTheme.inversePrimary,
          inactiveColorPrimary: AppTheme.primaryColor,
        ),

        PersistentBottomNavBarItem(
          icon: Icon(Icons.search),
          title: 'Search',
          activeColorPrimary: AppTheme.inversePrimary,
          inactiveColorPrimary: AppTheme.primaryColor,
        ),

        PersistentBottomNavBarItem(
          icon: Icon(Icons.add),
          title: 'Add Snibble',
          activeColorPrimary: AppTheme.inversePrimary,
          inactiveColorPrimary: AppTheme.primaryColor,
        ),

        PersistentBottomNavBarItem(
          icon: Icon(Icons.favorite),
          title: 'Activity',
          activeColorPrimary: AppTheme.inversePrimary,
          inactiveColorPrimary: AppTheme.primaryColor,
        ),

        PersistentBottomNavBarItem(
          icon: Icon(Icons.person),
          title: 'Profile',
          activeColorPrimary: AppTheme.inversePrimary,
          inactiveColorPrimary: AppTheme.primaryColor,
        ),
      ],
      navBarStyle: NavBarStyle.style3,
    );
  }
}
