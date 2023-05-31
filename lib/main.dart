import 'package:flutter/material.dart';
import 'package:pharmacy_dashboard/core/theme/app_text_theme.dart';
import 'package:pharmacy_dashboard/core/theme/color_schemes.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: lightColorScheme,
        textTheme: appTextTheme,
      ),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: ThemeMode.light,
      home: const HomePage(),
    );
  }
}
