import 'package:flutter/material.dart';

class AdminsPage extends StatelessWidget {
  const AdminsPage({super.key});
  static const routeName = 'Admins';

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
          'Admins Page',
          style:
              textTheme.headlineLarge!.copyWith(color: colorScheme.onTertiary),
        ),
      ),
    );
  }
}
