import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const routeName = 'login';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: colorScheme.primary,
      child: Center(
        child: Text(
          'Login Page',
          style:
              textTheme.headlineLarge!.copyWith(color: colorScheme.onPrimary),
        ),
      ),
    );
  }
}
