import 'package:flutter/material.dart';

import 'adaptive_app_bar.dart';
import 'list_drawer.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({
    super.key,
    required this.body,
  });
  final Widget body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdaptiveAppBar(),
      body: body,
      drawer: const ListDrawer(),
    );
  }
}
