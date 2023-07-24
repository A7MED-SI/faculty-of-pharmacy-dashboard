import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        
        title: Text(
          "تأكيد الحذف",
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            text,
            style: textTheme.bodyLarge,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(false);
            },
            child: Text(
              'إلغاء',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.pop(true);
            },
            child: Text(
              'تأكيد',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
