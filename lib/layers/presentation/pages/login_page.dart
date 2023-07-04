// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/core/layout/adaptive.dart';
import 'package:pharmacy_dashboard/core/widgets/loading_widget.dart';
import 'package:pharmacy_dashboard/layers/presentation/blocs/auth/auth_bloc.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const routeName = 'login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    log('refreshed');
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // ignore: unused_local_variable
    final isDesktop = isDisplayDesktop(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          final snackBar = SnackBar(
            content: Text(
              'يرجي التأكد من المعلومات والمحاولة مرة أخري',
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
            ),
            backgroundColor: colorScheme.errorContainer,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: colorScheme.surfaceVariant,
            body: Center(
              child: state.status == AuthStatus.loading
                  ? const LoadingWidget()
                  : SizedBox(
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
                            controller: _usernameController,
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
                            controller: _passwordController,
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
                              context.read<AuthBloc>().add(LoginSubmitted(
                                    password: _passwordController.text,
                                    username: _usernameController.text,
                                  ));
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
        );
      },
    );
  }
}
