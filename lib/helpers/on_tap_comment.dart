import 'package:flutter/material.dart';

void onTapComment(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        content: Text('Coming soon...', style: TextStyle(fontSize: 18)),
      );
    },
  );
}
