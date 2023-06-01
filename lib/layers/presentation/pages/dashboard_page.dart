import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  static const routeName = 'dashboard';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: colorScheme.secondary,
      child: Center(
        child: Text(
          'Dashboard Page',
          style:
              textTheme.headlineLarge!.copyWith(color: colorScheme.onSecondary),
        ),
      ),
    );
  }
}
