import 'package:flutter/material.dart';
import 'package:storygram/themes/app_theme.dart';

class CommentSection extends StatefulWidget {
  const CommentSection({super.key});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      // Fixed height
      height: screenHeight * 0.7,
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
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

          // Comments Headline
          const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Text(
              "Comments",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          Divider(color: AppTheme.onPrimaryColor.withValues(alpha: 0.3)),

          // Comments List 
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                // Add more comments...
              ],
            ),
          ),

          // Input field container 
          Container(
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor,
              border: Border(
                top: BorderSide(
                  color: AppTheme.inverseSecondary.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
            ),
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 8.0,
              // Extra padding for persistent nav bar + keyboard
              bottom:
                  keyboardHeight > 0
                      ? keyboardHeight +
                          20 // Extra padding when keyboard is visible
                      : bottomPadding +
                          20, // Extra padding when keyboard is hidden
            ),
            child: Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: _focusNode,
                            decoration: const InputDecoration(
                              hintText: "Add a comment...",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (value) => () {},
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Color.fromARGB(255, 127, 107, 85),
                          ),
                          onPressed: () {},
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
                      Container(width: 24, height: 1, color: Colors.grey[300]),
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
