import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/constants/assets.dart';
import 'package:storygram/widgets/posts_feed.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.all(4),
                child: PostsFeed(onTap: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
