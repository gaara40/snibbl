import 'package:flutter/material.dart';
import 'package:storygram/themes/app_theme.dart';

class CommentOverlay extends StatelessWidget {
  const CommentOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor, // Moved here
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),

      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 35,
            height: 3,
            decoration: BoxDecoration(
              color: AppTheme.onSecondaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          //Comments Headline
          const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Text(
              "Comments",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          Divider(color: AppTheme.onPrimaryColor.withValues(alpha: 0.3)),

          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text("User123"),
                  subtitle: Text("Nice post!"),
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text("FlutterDev"),
                  subtitle: Text("🔥🔥🔥"),
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text("FlutterDev"),
                  subtitle: Text("🔥🔥🔥"),
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text("FlutterDev"),
                  subtitle: Text("🔥🔥🔥"),
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text("FlutterDev"),
                  subtitle: Text("🔥🔥🔥"),
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text("FlutterDev"),
                  subtitle: Text("🔥🔥🔥"),
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text("FlutterDev"),
                  subtitle: Text("🔥🔥🔥"),
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text("FlutterDev"),
                  subtitle: Text("🔥🔥🔥"),
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text("FlutterDev"),
                  subtitle: Text("🔥🔥🔥"),
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text("FlutterDev"),
                  subtitle: Text("🔥🔥🔥"),
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text("FlutterDev"),
                  subtitle: Text("🔥🔥🔥"),
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text("FlutterDev"),
                  subtitle: Text("🔥🔥🔥"),
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text("FlutterDev"),
                  subtitle: Text("🔥🔥🔥"),
                ),
              ],
            ),
          ),

          // Input field container - this will stay above the keyboard
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.inverseSecondary.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
            ),
            padding: const EdgeInsets.all(8.0),

            child: Row(
              children: [
                // CURRENT USER PROFILE ICON
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 10),

                // COMMENT INPUT FIELD CONTAINER
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        // TEXT FIELD
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Add a comment...",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        // SEND BUTTON
                        IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Color.fromARGB(255, 127, 107, 85),
                          ),
                          onPressed: () {
                            // Add send functionality later
                            debugPrint("Comment sent!");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InstagramCommentsWidget extends StatelessWidget {
  const InstagramCommentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Comments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.close, color: Colors.grey[600]),
              ],
            ),
          ),

          const Divider(height: 1),

          // Comments list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildComment(
                  username: 'john_doe',
                  timeAgo: '2h',
                  comment: 'Amazing shot! 🔥',
                  likes: 12,
                  hasReplies: true,
                ),
                _buildComment(
                  username: 'sarah_smith',
                  timeAgo: '1h',
                  comment:
                      'Love the colors in this photo. Where was this taken?',
                  likes: 8,
                  hasReplies: false,
                ),

                _buildComment(
                  username: 'travel_addict',
                  timeAgo: '30m',
                  comment: 'This makes me want to book a trip right now ✈️',
                  likes: 25,
                  hasReplies: true,
                ),
                _buildComment(
                  username: 'photographer_mike',
                  timeAgo: '15m',
                  comment: 'Great composition! What camera did you use?',
                  likes: 5,
                  hasReplies: false,
                ),
                _buildComment(
                  username: 'wanderlust_girl',
                  timeAgo: '10m',
                  comment: 'Adding this to my bucket list! 😍',
                  likes: 7,
                  hasReplies: false,
                ),
              ],
            ),
          ),

          // Comment input section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                const CircleAvatar(radius: 16),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComment({
    required String username,
    required String timeAgo,
    required String comment,
    required int likes,
    required bool hasReplies,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(
                        text: username,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(text: comment),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      timeAgo,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    if (likes > 0)
                      Text(
                        '$likes ${likes == 1 ? 'like' : 'likes'}',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    const SizedBox(width: 16),
                    Text(
                      'Reply',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (hasReplies) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 1,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'View replies (2)',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 4),
              Icon(Icons.favorite_border, size: 16, color: Colors.grey[600]),
            ],
          ),
        ],
      ),
    );
  }
}
