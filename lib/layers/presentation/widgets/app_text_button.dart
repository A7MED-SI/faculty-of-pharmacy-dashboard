import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final VoidCallback onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: colorScheme.secondaryContainer,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Text(
        text,
        style: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
