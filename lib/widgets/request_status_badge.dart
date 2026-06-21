import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';

class RequestStatusBadge extends StatelessWidget {
  final String status;
  final bool isMini;

  const RequestStatusBadge({
    super.key,
    required this.status,
    this.isMini = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color bgColor;
    Color textColor;
    String label = '';

    // Standardize colors across app states
    switch (status) {
      case 'PENDING':
        bgColor = isDark ? const Color(0x33FF9800) : const Color(0xFFFFF3CD);
        textColor = isDark ? const Color(0xFFFFB74D) : const Color(0xFF856404);
        break;
      case 'ACCEPTED':
        bgColor = isDark ? const Color(0x3310B981) : const Color(0xFFD4EDDA);
        textColor = isDark ? const Color(0xFF34D399) : const Color(0xFF155724);
        break;
      case 'REJECTED':
      default:
        bgColor = isDark ? const Color(0x33EF5350) : const Color(0xFFF8D7DA);
        textColor = isDark ? const Color(0xFFE57373) : const Color(0xFF721C24);
        break;
    }

    final localeCode = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context);

    // Resolve labels (short vs full-length based on isMini)
    if (isMini) {
      if (status == 'PENDING') {
        label = 'Pend.';
      } else if (status == 'ACCEPTED') {
        label = localeCode == 'es' ? 'Acep.' : 'Acc.';
      } else if (status == 'REJECTED') {
        label = 'Den.';
      }
    } else {
      if (l10n != null) {
        if (status == 'PENDING') {
          label = l10n.inboxStatusPending;
        } else if (status == 'ACCEPTED') {
          label = l10n.inboxStatusAccepted;
        } else if (status == 'REJECTED') {
          label = l10n.inboxStatusRejected;
        }
      } else {
        label = status;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMini ? 8 : 10,
        vertical: isMini ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(isMini ? 6 : 8),
        border: isMini
            ? Border.all(
                color: textColor.withValues(alpha: 0.2),
                width: 0.8,
              )
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: isMini ? 10 : 11,
          fontWeight: isMini ? FontWeight.w800 : FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
