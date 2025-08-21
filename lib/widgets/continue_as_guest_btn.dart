import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ContinueAsGuestBtn extends StatelessWidget {
  final VoidCallback handleLogin;
  const ContinueAsGuestBtn({super.key, required this.handleLogin});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text.rich(
          TextSpan(
            text: "Continue as a ",
            style: theme.textTheme.displaySmall?.copyWith(fontSize: 14),
            children: [
              TextSpan(
                text: "Guest",
                recognizer: TapGestureRecognizer()..onTap = handleLogin,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
        // SizedBox(width: 6),
        // Tooltip(
        //   message:
        //       "As readers, guest users can enjoy posts. Interacting with posts requires a login.",
        //   child: Icon(Icons.info_outline, size: 14),
        // ),
      ],
    );
  }
}
