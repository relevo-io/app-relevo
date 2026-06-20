import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../data/models/offer_model.dart';
import '../data/providers/auth_provider.dart';
import '../data/providers/solicitud_provider.dart';
import '../data/providers/offers_provider.dart';
import '../screens/offer_details_screen.dart';
import '../theme/relevo_theme.dart';
import 'request_status_badge.dart';
import 'restricted_dialog.dart';
import 'premium_invite_dialog.dart';

class OfferCardGrid extends ConsumerWidget {
  final Offer offer;
  final bool isLocked;

  const OfferCardGrid({super.key, required this.offer, this.isLocked = false});

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

    final age = offer.creationYear != null
        ? '${DateTime.now().year - offer.creationYear!} ${localeCode == 'ca' ? 'Anys' : localeCode == 'en' ? 'Years' : 'Años'}'
        : '-';

    return GestureDetector(
      onTap: isLocked
          ? () => showPremiumInviteDialog(context, isLoggedIn: isLoggedIn)
          : (isLoggedIn
              ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OfferDetailsScreen(offer: offer),
                    ),
                  )
              : () => showRestrictedDialog(context)),
      child: RelevoCard(
        elevation: 2,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Image
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
                      // Sector Badge
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: theme.colorScheme.outline.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            offer.getLocalizedSector(localeCode).toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      // Favorite or Lock Badge
                      if (!isMyOffer)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () async {
                              if (isLoggedIn) {
                                await ref.read(favoriteOfferIdsProvider.notifier).toggleFavorite(offer.id);
                              } else {
                                showRestrictedDialog(context);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
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
                                    size: 14,
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
                // Card Content
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          offer.companyDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontSize: 12,
                            height: 1.3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isLoggedIn && existingRequest != null) ...[
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RequestStatusBadge(status: existingRequest.status, isMini: true),
                          ),
                        ],
                        const SizedBox(height: 4),
                        const Divider(height: 8, thickness: 0.5),
                        if (isLoggedIn) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (localeCode == 'ca' ? 'Facturació' : localeCode == 'en' ? 'Revenue' : 'Facturación').toUpperCase(),
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        fontSize: 8,
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      offer.formattedRevenue,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: priceColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (localeCode == 'ca' ? 'Antiguitat' : localeCode == 'en' ? 'Age' : 'Antigüedad').toUpperCase(),
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        fontSize: 8,
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      age,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ] else
                          // Guest View placeholder
                          Center(
                            child: Text(
                              localeCode == 'ca'
                                  ? 'Inicia sessió per veure detalls'
                                  : localeCode == 'en'
                                      ? 'Log in to view details'
                                      : 'Inicia sesión para ver detalles',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 10,
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
            if (isLocked)
              Positioned.fill(
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.08),
                      child: const Center(
                        child: Icon(
                          Icons.lock_outline_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

