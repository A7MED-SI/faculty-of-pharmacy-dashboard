import 'package:flutter/material.dart';

class SemestersPage extends StatelessWidget {
  const SemestersPage({super.key});
  static const routeName = 'semesters';

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
          'Sem Page',
          style:
              textTheme.headlineLarge!.copyWith(color: colorScheme.onTertiary),
        ),
      ),
    );
  }
}
