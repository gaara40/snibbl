import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/global_providers/user_bio_provider.dart';
import 'package:storygram/themes/app_theme.dart';

class UserBioTextWidget extends ConsumerWidget {
  const UserBioTextWidget(
    this.fontSize,
    this.fontWeight,
    this.fontStyle, {
    super.key,
  });

  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userBioAsync = ref.watch(userBioProvider);

    return userBioAsync.when(
      data:
          (username) => Text(
            '"$username"',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
            ),
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
