import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.onRefreshPressed,
  });

  final VoidCallback onRefreshPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'حدث خطأ ما يرجى المحاولة مرة أخرى',
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(colorScheme.primary),
              padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 12)),
            ),
            onPressed: onRefreshPressed,
            child: Icon(
              Icons.refresh,
              color: colorScheme.onPrimary,
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}
