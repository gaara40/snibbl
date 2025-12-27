import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/core/constants/assets.dart';
import 'package:storygram/features/auth/providers/auth_providers.dart';
import 'package:storygram/features/activities/presentation/widgets/activity_item.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authServices = ref.read(authServiceProvider);
    final currentUser = FirebaseAuth.instance.currentUser;

    final currentUserId = authServices.currentUserId;
    final isGuest = currentUser != null && currentUser.isAnonymous;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //LOGO
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: SizedBox(
                height: 45,
                child: Image.asset(AppAssets.appNameLogo, fit: BoxFit.contain),
              ),
            ),

            SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 8.0, 4.0),
              child: Text(
                'Activity',
                style: theme.textTheme.headlineSmall!.copyWith(fontSize: 16),
              ),
            ),

            Expanded(
              //FEED
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  6,
                  4,
                  6,
                  kBottomNavigationBarHeight + 4,
                ),
                child: isGuest
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Sign in to see who's interacting with your Snibbls!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ),
                      )
                    : ActivityItem(currentUserId),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
