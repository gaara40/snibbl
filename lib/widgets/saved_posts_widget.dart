import 'package:flutter/material.dart';
import 'package:storygram/widgets/saved_posts_tab.dart';

class SavedPostsWidget extends StatelessWidget {
  const SavedPostsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SavedPostsTab(),
        ),
      ),
    );
  }
}
