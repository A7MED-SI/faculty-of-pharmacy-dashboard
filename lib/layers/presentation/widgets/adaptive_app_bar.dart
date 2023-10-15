import 'package:flutter/material.dart';

class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdaptiveAppBar({
    super.key,
    this.isDesktop = false,
  });

  final bool isDesktop;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      automaticallyImplyLeading: !isDesktop,
      iconTheme: IconThemeData(
        color: colorScheme.onBackground,
      ),
      centerTitle: true,
      title: SelectableText(
        "Omega",
        style: textTheme.bodyLarge?.copyWith(
          color: colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: colorScheme.background,
    );
  }
}
