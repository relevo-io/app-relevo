import 'dart:ui';
import 'package:flutter/material.dart';

class GlassmorphicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;

  const GlassmorphicAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer.withValues(
                  alpha: 0.65,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(
                    alpha: isDark ? 0.25 : 0.45,
                  ),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  leading ?? (Navigator.canPop(context)
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: () => Navigator.maybePop(context),
                        )
                      : const SizedBox(width: 40)),
                  const SizedBox(width: 8),
                  if (title != null)
                    Expanded(
                      child: DefaultTextStyle(
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ) ?? const TextStyle(),
                        child: title!,
                      ),
                    )
                  else
                    const Spacer(),
                  if (actions != null) ...[
                    ...actions!,
                    const SizedBox(width: 8),
                  ] else
                    const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
