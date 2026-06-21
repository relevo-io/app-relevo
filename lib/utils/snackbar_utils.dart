import 'package:flutter/material.dart';

void showRelevoSnackBar(
  BuildContext context, {
  required String message,
  IconData? icon,
  Color? iconColor,
  bool isError = false,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  // Choose icon based on state
  final resolvedIcon = icon ?? (isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded);

  // Choose icon color based on state
  final resolvedIconColor = iconColor ?? (isError ? theme.colorScheme.error : theme.colorScheme.primary);

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(resolvedIcon, color: resolvedIconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isDark 
                    ? const Color(0xFFDAE2FD) 
                    : const Color(0xFF191C1E),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
