import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  static const routeName = 'dashboard';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.surfaceVariant,
      body: Center(
        child: Text(
          'Dashboard Page',
          style: textTheme.headlineLarge!
              .copyWith(color: colorScheme.onBackground),
        ),
      ),
    );
  }
}
