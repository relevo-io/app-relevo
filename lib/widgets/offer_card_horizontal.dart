import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/models/offer_model.dart';
import '../data/providers/auth_provider.dart';
import '../data/providers/solicitud_provider.dart';
import '../data/providers/offers_provider.dart';
import '../screens/offer_details_screen.dart';
import '../theme/relevo_theme.dart';
import 'request_status_badge.dart';
import 'restricted_dialog.dart';

class OfferCardHorizontal extends ConsumerWidget {
  final Offer offer;

  const OfferCardHorizontal({super.key, required this.offer});

  String _getSectorImageUrl(String sector) {
    final cleanSector = sector.toLowerCase().trim();
    if (cleanSector.contains('hostelería') || cleanSector.contains('hosteleria') || cleanSector.contains('restaurant') || cleanSector.contains('café') || cleanSector.contains('bakery')) {
      return 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&auto=format&fit=crop&q=60';
    } else if (cleanSector.contains('comercio') || cleanSector.contains('retail') || cleanSector.contains('boutique') || cleanSector.contains('tienda')) {
      return 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=500&auto=format&fit=crop&q=60';
    } else if (cleanSector.contains('industria') || cleanSector.contains('manufacturing') || cleanSector.contains('cnc') || cleanSector.contains('taller')) {
      return 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=500&auto=format&fit=crop&q=60';
    } else if (cleanSector.contains('salud') || cleanSector.contains('medical') || cleanSector.contains('clinic') || cleanSector.contains('estética') || cleanSector.contains('health')) {
      return 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=500&auto=format&fit=crop&q=60';
    } else if (cleanSector.contains('servicio') || cleanSector.contains('logistics') || cleanSector.contains('ecommerce') || cleanSector.contains('oficina')) {
      return 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?w=500&auto=format&fit=crop&q=60';
    }
    return 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=500&auto=format&fit=crop&q=60'; // Default office building
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authProvider).value;
    final isLoggedIn = user != null;
    final isMyOffer = isLoggedIn && offer.owner == user.id;
    final isDark = theme.brightness == Brightness.dark;

    final priceColor = theme.colorScheme.primary;
    final localeCode = Localizations.localeOf(context).languageCode;

    final sentRequestsAsync = isLoggedIn ? ref.watch(sentRequestsProvider) : null;
    final sentRequests = sentRequestsAsync?.value ?? [];
    final existingRequestList = sentRequests.where((r) => r.opportunity.id == offer.id);
    final existingRequest = existingRequestList.isNotEmpty ? existingRequestList.first : null;

    return GestureDetector(
      onTap: isLoggedIn
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OfferDetailsScreen(offer: offer),
                ),
              )
          : () => showRestrictedDialog(context),
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 12),
        child: RelevoCard(
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header image area
              Expanded(
                flex: 4,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      _getSectorImageUrl(offer.sector),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.business,
                          color: theme.colorScheme.onSurface.withOpacity(0.3),
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    // Sector badge
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: theme.colorScheme.outline.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          offer.sector.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    // Favorite/Lock Icon
                    if (!isMyOffer)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: () async {
                            if (isLoggedIn) {
                              await ref.read(favoriteOfferIdsProvider.notifier).toggleFavorite(offer.id);
                            } else {
                              showRestrictedDialog(context);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface.withOpacity(0.85),
                              shape: BoxShape.circle,
                            ),
                            child: Consumer(
                              builder: (context, ref, child) {
                                final favoriteIdsAsync = isLoggedIn ? ref.watch(favoriteOfferIdsProvider) : null;
                                final isFavorite = favoriteIdsAsync?.value?.contains(offer.id) ?? false;
                                return Icon(
                                  isLoggedIn
                                      ? (isFavorite ? Icons.favorite : Icons.favorite_border)
                                      : Icons.lock_outline_rounded,
                                  size: 12,
                                  color: isFavorite
                                      ? Colors.redAccent
                                      : theme.colorScheme.onSurface.withOpacity(0.7),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Card contents
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        offer.companyDescription,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontSize: 11,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Divider(height: 6, thickness: 0.5),
                      if (isLoggedIn)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              offer.formattedRevenueShort,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: priceColor,
                              ),
                            ),
                            if (existingRequest != null)
                              RequestStatusBadge(status: existingRequest.status, isMini: true),
                          ],
                        )
                      else
                        Center(
                          child: Text(
                            localeCode == 'ca'
                                ? 'Inicia sessió'
                                : localeCode == 'en'
                                    ? 'Log in'
                                    : 'Inicia sesión',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 9,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

