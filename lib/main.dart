import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_dashboard/core/theme/app_text_theme.dart';
import 'package:pharmacy_dashboard/core/theme/color_schemes.dart';
import 'package:pharmacy_dashboard/router.dart';

import 'layers/presentation/blocs/auth/auth_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return MaterialApp.router(
            routerConfig: MyRouter.getRouter(state),
            title: 'DO IT RIGHT',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: false,
              colorScheme: lightColorScheme,
              textTheme: appTextTheme,
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: lightColorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              scrollbarTheme: const ScrollbarThemeData().copyWith(
                  thumbColor: MaterialStateProperty.resolveWith(
                (states) {
                  if (states.contains(MaterialState.hovered) ||
                      states.contains(MaterialState.pressed)) {
                    return Colors.grey.shade700;
                  }
                  return Colors.grey;
                },
              )),
            ),
            darkTheme: ThemeData(
              useMaterial3: false,
              colorScheme: darkColorScheme,
              textTheme: appTextTheme,
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: darkColorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            themeMode: ThemeMode.light,
          );
        },
      ),
    );
  }
}
