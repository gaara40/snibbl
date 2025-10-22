import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:storygram/themes/app_theme.dart';

class EditOverlay extends StatelessWidget {
  const EditOverlay({
    super.key,

    required this.onCancelTap,
    required this.onSave,
    required this.title,
    required this.hintText,
    required this.labelText,

    this.isEditBio = false,
  });

  final String title;
  final String hintText;
  final String labelText;

  final bool isEditBio;

  final VoidCallback onCancelTap;
  final ValueChanged<String> onSave;

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    return SizedBox.expand(
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),

          //Edit Username Card
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Center(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: onCancelTap,
                              child: Icon(Icons.cancel),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        maxLength: isEditBio ? 80 : 20,

                        controller: textController,
                        decoration: InputDecoration(
                          hintText: hintText,
                          labelText: labelText,
                          hintStyle: TextStyle(
                            color: AppTheme.onPrimaryColor.withValues(
                              alpha: 0.7,
                            ),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          onSave(textController.text);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
