import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/constants/assets.dart';
import 'package:storygram/global_providers/auth_providers.dart';
import 'package:storygram/widgets/activity_item.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authServices = ref.read(authServiceProvider);

    final currentUserId = authServices.currentUserId();

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
                height: 50,
                child: Image.asset(AppAssets.appNameLogo, fit: BoxFit.contain),
              ),
            ),

            SizedBox(height: 10),

            Expanded(
              //FEED
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  6,
                  4,
                  6,
                  kBottomNavigationBarHeight + 4,
                ),
                child: ActivityItem(currentUserId!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
