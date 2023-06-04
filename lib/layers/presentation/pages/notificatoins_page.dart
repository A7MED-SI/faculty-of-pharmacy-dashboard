import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  static const routeName = 'notifications';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: colorScheme.tertiary,
      child: Center(
        child: Text(
          'Notifications Page',
          style:
              textTheme.headlineLarge!.copyWith(color: colorScheme.onTertiary),
        ),
      ),
    );
  }
}
