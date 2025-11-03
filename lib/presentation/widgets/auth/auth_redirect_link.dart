import 'package:flutter/material.dart';

class AuthRedirectLink extends StatelessWidget {
  final String promptText;
  final String linkText;
  final VoidCallback onPressed;

  const AuthRedirectLink({
    super.key,
    required this.promptText,
    required this.linkText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(promptText),
        TextButton(
          onPressed: onPressed,
          // TextButtonのスタイルは AppTheme で設定済み
          child: Text(linkText),
        ),
      ],
    );
  }
}
