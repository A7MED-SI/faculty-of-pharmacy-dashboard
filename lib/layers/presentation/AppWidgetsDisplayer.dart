import 'package:flutter/material.dart';

class AppWidgetsDisplayer {
  AppWidgetsDisplayer._();

  static displayErrorSnackBar(
      {required BuildContext context, required String message}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final snackBar = SnackBar(
      content: Text(
        message,
        style: textTheme.titleSmall?.copyWith(
          color: colorScheme.onErrorContainer,
        ),
      ),
      backgroundColor: colorScheme.errorContainer,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static displaySuccessSnackBar(
      {required BuildContext context, required String message}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final snackBar = SnackBar(
      content: Text(
        message,
        style: textTheme.titleSmall?.copyWith(
          color: colorScheme.onTertiaryContainer,
        ),
      ),
      backgroundColor: colorScheme.tertiaryContainer,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
