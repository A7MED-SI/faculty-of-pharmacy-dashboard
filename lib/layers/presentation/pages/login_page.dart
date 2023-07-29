// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/core/constants/images/app_images.dart';
import 'package:pharmacy_dashboard/core/layout/adaptive.dart';
import 'package:pharmacy_dashboard/core/validations/validations.dart';
import 'package:pharmacy_dashboard/layers/presentation/AppWidgetsDisplayer.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/loading_widget.dart';
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
  late final ValueNotifier<bool> passWordShowNotifier;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    passWordShowNotifier = ValueNotifier(false);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
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
          AppWidgetsDisplayer.dispalyErrorSnackBar(
            context: context,
            message: state.errorMessage ??
                'يرجي التأكد من المعلومات والمحاولة مرة أخرى',
          );
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
                      width: isDesktop ? 450 : 300,
                      child: Form(
                        key: _formKey,
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(scrollbars: false),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 140,
                                  child: Image(
                                    image:
                                        const AssetImage(AppImages.logoImage),
                                    color: colorScheme.onBackground,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'DO IT RIGHT',
                                  style: textTheme.headlineLarge?.copyWith(
                                    color: colorScheme.onBackground,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.ltr,
                                ),
                                const SizedBox(height: 40),
                                TextFormField(
                                  controller: _usernameController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  autofocus: true,
                                  textInputAction: TextInputAction.next,
                                  cursorColor: colorScheme.onBackground,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'يجب إدخال اسم المستخدم';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'اسم المستخدم',
                                    labelStyle: textTheme.bodyLarge?.copyWith(
                                      color: colorScheme.onBackground,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                ValueListenableBuilder(
                                    valueListenable: passWordShowNotifier,
                                    builder: (context, showText, _) {
                                      return TextFormField(
                                        controller: _passwordController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        cursorColor: colorScheme.onBackground,
                                        obscureText: !showText,
                                        validator: (value) {
                                          if (value == null ||
                                              !Validations.passwordValidation(
                                                  password: value)) {
                                            return 'كلمة المرور يجب أن تتألف من 6 محارف على الأقل';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'كلمة المرور',
                                            labelStyle:
                                                textTheme.bodyLarge?.copyWith(
                                              color: colorScheme.onBackground,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 15,
                                            ),
                                            suffix: TextButton(
                                              onPressed: () {
                                                passWordShowNotifier.value =
                                                    !passWordShowNotifier.value;
                                              },
                                              child: Text(
                                                showText ? 'Hide' : 'Show',
                                                style: textTheme.bodyLarge
                                                    ?.copyWith(
                                                  color: colorScheme.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )),
                                      );
                                    }),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: () {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
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
                    ),
            ),
          ),
        );
      },
    );
  }
}
