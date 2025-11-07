import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/features/posts/providers/post_provider.dart';
import 'package:storygram/core/themes/app_theme.dart';
import 'package:storygram/features/profile/presentation/widgets/profile_post_card.dart';

class ProfilePostItem extends ConsumerStatefulWidget {
  const ProfilePostItem(this.postId, {super.key});

  final String postId;

  @override
  ConsumerState<ProfilePostItem> createState() => _ProfilePostItemState();
}

class _ProfilePostItemState extends ConsumerState<ProfilePostItem> {
  @override
  Widget build(BuildContext context) {
    final postSnapshot = ref.watch(postProvider(widget.postId));

    if (postSnapshot.isLoading) {
      return Container(
        decoration: BoxDecoration(
          color: AppTheme.loadingCardColor.withValues(alpha: 0.5),
          border: Border.all(color: AppTheme.inverseSecondary),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      );
    }

    if (!postSnapshot.hasValue || !postSnapshot.value!.exists) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error fetching post',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final data = postSnapshot.value!.data() as Map<String, dynamic>;

    return GestureDetector(
      child: ProfilePostTile(
        text: data['post'] ?? 'Nothing to read here:(',
        fontSize: (data['fontSize'] ?? 18).toDouble(),
        fontStyle: data['fontStyle'] ?? 'poppins',
        textAlignment: _mapAlignment(data['textAlignment']),
        isBold: data['isBold'] ?? false,
      ),
    );
  }

  TextAlign _mapAlignment(String? textAlign) {
    switch (textAlign) {
      case "TextAlign.center":
      case "center":
        return TextAlign.center;

      case "TextAlign.right":
      case "right":
        return TextAlign.right;

      case "TextAlign.justify":
      case "justify":
        return TextAlign.justify;

      case "TextAlign.left":
      case "left":
      default:
        return TextAlign.left;
    }
  }
}
