import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/global_providers/username_provider.dart';
import 'package:storygram/themes/app_theme.dart';

class UsernameTextWidget extends ConsumerWidget {
  const UsernameTextWidget(this.fontSize, this.fontWeight, {super.key});

  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameAsync = ref.watch(usernameProvider);

    return usernameAsync.when(
      data:
          (username) => Text(
            username,
            style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
          ),
      error: (e, _) => const Text('error'),
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

class LogoUsername extends ConsumerWidget {
  const LogoUsername(this.fontSize, this.fontWeight, {super.key});

  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameAsync = ref.watch(usernameProvider);

    return usernameAsync.when(
      data: (username) {
        final firstLetter =
            username.isNotEmpty ? username[0].toUpperCase() : "?";
        return Text(
          firstLetter,
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        );
      },
      error: (e, _) => const Text('error'),
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
