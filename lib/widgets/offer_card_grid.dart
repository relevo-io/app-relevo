import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../data/models/offer_model.dart';
import '../data/providers/auth_provider.dart';
import 'restricted_dialog.dart';

class OfferCardGrid extends ConsumerWidget {
  final Offer offer;

  const OfferCardGrid({super.key, required this.offer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authProvider).value;
    final isLoggedIn = user != null;
    final isMyOffer = isLoggedIn && offer.owner == user.id;

    return GestureDetector(
      onTap: isLoggedIn ? null : () => showRestrictedDialog(context),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.35),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          offer.sector.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                      if (!isMyOffer)
                        Icon(
                          isLoggedIn
                              ? Icons.favorite_border
                              : Icons.lock_outline_rounded,
                          size: 16,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: isLoggedIn ? 0.5 : 0.3,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    offer.companyDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
              if (isLoggedIn)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.formattedRevenue,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      offer.publishedAt != null
                          ? timeago.format(offer.publishedAt!, locale: 'es')
                          : 'Ahora',
                      style: TextStyle(
                        fontSize: 9,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
