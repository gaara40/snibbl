import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class NewAccountBtn extends StatelessWidget {
  final VoidCallback onTap;
  const NewAccountBtn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Center(
          child: Text.rich(
            TextSpan(
              text: "Don't have an account? ",
              style: theme.textTheme.displaySmall?.copyWith(fontSize: 14),
              children: [
                TextSpan(
                  text: 'Signup',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
