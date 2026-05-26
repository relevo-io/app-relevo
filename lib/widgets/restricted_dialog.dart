import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';

void showRestrictedDialog(BuildContext context) {
  final theme = Theme.of(context);
  final l10n = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: theme.colorScheme.surface,
      title: Row(
        children: [
          Icon(
            Icons.lock_outline_rounded,
            color: theme.colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.restrictedAlertTitle,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
          ),
        ],
      ),
      content: Text(
        l10n.restrictedAlertDesc,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          fontSize: 14,
          height: 1.4,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(l10n.profileRegisterButton),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(l10n.profileLoginButton),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
