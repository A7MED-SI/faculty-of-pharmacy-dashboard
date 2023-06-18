import 'package:flutter/material.dart';

class AdsPage extends StatelessWidget {
  const AdsPage({super.key});
  static const routeName = 'ads';

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
          'Ads Page',
          style:
              textTheme.headlineLarge!.copyWith(color: colorScheme.onTertiary),
        ),
      ),
    );
  }
}