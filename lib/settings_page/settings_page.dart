import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/global_providers/auth_providers.dart';
import 'package:storygram/helpers/logout_dialog.dart';
import 'package:storygram/helpers/toasts.dart';
import 'package:storygram/main.dart';
import 'package:storygram/settings_page/widgets.dart/setting_tile_card.dart';
import 'package:storygram/themes/app_theme.dart';
import 'package:storygram/widgets/username_text_widget.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authServices = ref.read(authServiceProvider);

    //Logout Logic
    Future<void> logoutLogic() async {
      try {
        await authServices.signOut();
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          '/loginScreen',
          (route) => false,
        );
      } catch (e) {
        showToast('Error signing out: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.secondaryColor,
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 6,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(height: 10),
            // Section 1: Profile
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: const Text(
                    "Profile",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                SettingTileCard(
                  icon: Icons.person_outline,
                  title: 'Username',
                  subTitle: UsernameTextWidget(14, FontWeight.w500),
                  trailingText: 'Edit',
                  onTap: () {},
                ),

                SettingTileCard(
                  icon: Icons.info_outline,
                  title: 'Bio',
                  subTitle: Text(
                    'Your bio',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  trailingText: 'Edit',
                  onTap: () {},
                ),
              ],
            ),

            SizedBox(height: 20),

            // Section 2: Account
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: const Text(
                    "Account",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),

                SettingTileCard(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  onTap: () {},
                ),

                SettingTileCard(
                  icon: Icons.delete_forever_outlined,
                  title: 'Permanently Delete Account',
                  onTap: () {},
                ),

                SettingTileCard(
                  icon: Icons.logout_outlined,
                  title: 'Logout',
                  onTap: () => showLogoutDialog(context, logoutLogic),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
