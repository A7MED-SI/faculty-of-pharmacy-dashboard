import 'package:flutter/material.dart';

class ErrorSnackBar extends StatelessWidget {
  const ErrorSnackBar({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SnackBar(
      content: Text(
        text,
        style: textTheme.titleSmall?.copyWith(
          color: colorScheme.onErrorContainer,
        ),
      ),
      backgroundColor: colorScheme.errorContainer,
    );
  }
}
