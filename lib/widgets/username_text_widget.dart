import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/global_providers/username_provider.dart';
import 'package:storygram/themes/app_theme.dart';

class UsernameTextWidget extends ConsumerWidget {
  const UsernameTextWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameAsync = ref.watch(usernameProvider);

    return usernameAsync.when(
      data: (username) => Text(username),
      error: (e, _) => const Text('error_occured'),
      loading:
          () => Container(
            decoration: BoxDecoration(
              color: AppTheme.loadingCardColor.withValues(alpha: 0.5),
              border: Border.all(color: AppTheme.inverseSecondary),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
    );
  }
}
