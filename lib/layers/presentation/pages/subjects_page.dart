import 'package:flutter/material.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});
  static const routeName = 'subjects';

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
          'Subjects Page',
          style:
              textTheme.headlineLarge!.copyWith(color: colorScheme.onTertiary),
        ),
      ),
    );
  }
}
