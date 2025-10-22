import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/global_providers/auth_providers.dart';
import 'package:storygram/global_providers/userservices_provider.dart';
import 'package:storygram/helpers/logout_dialog.dart';
import 'package:storygram/helpers/toasts.dart';
import 'package:storygram/main.dart';
import 'package:storygram/settings_page/widgets/edit_overlay.dart';
import 'package:storygram/settings_page/widgets/setting_tile_card.dart';
import 'package:storygram/themes/app_theme.dart';
import 'package:storygram/widgets/username_text_widget.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _showEditUsername = false;
  bool _showEditBio = false;

  @override
  Widget build(BuildContext context) {
    final authServices = ref.read(authServiceProvider);

    //Current user ID
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Logout Logic
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

    return Stack(
      children: [
        Scaffold(
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
                const SizedBox(height: 10),
                // Section 1: Profile
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SettingTileCard(
                      icon: Icons.person_outline,
                      title: 'Username',
                      subTitle: UsernameTextWidget(14, FontWeight.w500),
                      trailingText: 'Edit',
                      onTap: () {
                        setState(() {
                          _showEditUsername = true;
                        });
                      },
                    ),
                    SettingTileCard(
                      icon: Icons.info_outline,
                      title: 'Bio',
                      subTitle: const Text(
                        'Your bio',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      trailingText: 'Edit',
                      onTap: () {
                        setState(() {
                          _showEditBio = true;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Section 2: Account
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Text(
                        "Account",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
        ),

        AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child:
              //Username Editing Overlay
              _showEditUsername
                  ? EditOverlay(
                    key: const ValueKey('edit_username_overlay'),

                    onCancelTap: () {
                      setState(() {
                        _showEditUsername = false;
                      });
                    },
                    onSave: (value) {
                      if (value.trim().isEmpty) {
                        showToast('Username cannot be empty');
                        return;
                      }
                      ref
                          .read(userServicesProvider)
                          .updateUsername(currentUserId, value.trim());
                      debugPrint('Username is saved as: $value');
                      setState(() {
                        _showEditUsername = false;
                      });
                    },
                    title: 'Edit Username',
                    hintText: 'What should we call you?',
                    labelText: 'New Username',
                  )
                  //Bio Editing Overlay
                  : _showEditBio
                  ? EditOverlay(
                    key: const ValueKey('edit_bio_overlay'),

                    isEditBio: true,

                    onCancelTap: () {
                      setState(() {
                        _showEditBio = false;
                      });
                    },
                    onSave: (value) {
                      debugPrint('Bio is saved as :$value');
                      setState(() {
                        _showEditBio = false;
                      });
                    },
                    title: 'Edit Bio',
                    hintText: 'A few words that describe you…',
                    labelText: 'Your Bio',
                  )
                  : const SizedBox.shrink(key: ValueKey('edit_overlay_empty')),
        ),
      ],
    );
  }
}
