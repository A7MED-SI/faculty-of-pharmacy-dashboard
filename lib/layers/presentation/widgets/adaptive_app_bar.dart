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
    final themeData = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: !isDesktop,
      title: isDesktop ? null : const SelectableText("Appbar"),
      backgroundColor: themeData.colorScheme.primary,
      bottom: isDesktop
          ? PreferredSize(
              preferredSize: const Size.fromHeight(26),
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                margin: const EdgeInsetsDirectional.fromSTEB(72, 0, 0, 22),
                child: SelectableText(
                  "Appbar",
                  style: themeData.textTheme.titleLarge!.copyWith(
                    color: Colors.black,
                  ),
                ),
              ),
            )
          : null,
      actions: const [],
    );
  }
}
