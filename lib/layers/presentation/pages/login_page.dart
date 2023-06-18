// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/core/layout/adaptive.dart';
import 'package:pharmacy_dashboard/layers/presentation/blocs/auth/auth_bloc.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/dashboard_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const routeName = 'login';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // ignore: unused_local_variable
    final isDesktop = isDisplayDesktop(context);

    return Material(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: colorScheme.surfaceVariant,
          child: Center(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.flutter_dash,
                    color: colorScheme.onSurfaceVariant,
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'DO IT RIGHT',
                    style: textTheme.headlineLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    textInputAction: TextInputAction.next,
                    cursorColor: colorScheme.onSurfaceVariant,
                    decoration: InputDecoration(
                      labelText: 'اسم المستخدم',
                      labelStyle: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    cursorColor: colorScheme.onSurfaceVariant,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      labelStyle: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(LoginSubmitted());
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 8,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'تسجيل الدخول',
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
