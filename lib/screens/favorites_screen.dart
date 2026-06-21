import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/providers/offers_provider.dart';
import '../widgets/offer_card_grid.dart';
import '../widgets/offers_shimmer.dart';

import '../widgets/glassmorphic_app_bar.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteOffersProvider);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final String titleText = locale == 'ca'
        ? 'Els meus preferits'
        : locale == 'es'
        ? 'Mis favoritos'
        : 'My Favorites';

    final String emptyText = locale == 'ca'
        ? 'No tens cap oferta preferida encara.'
        : locale == 'es'
        ? 'No tienes ninguna oferta favorita todavía.'
        : 'You do not have any favorite offers yet.';

    final String errorText = locale == 'ca'
        ? 'Error al carregar els preferits'
        : locale == 'es'
        ? 'Error al cargar los favoritos'
        : 'Error loading favorites';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassmorphicAppBar(
        title: Text(
          titleText,
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(favoriteOffersProvider);
          try {
            await ref.read(favoriteOffersProvider.future);
          } catch (_) {}
        },
        color: theme.colorScheme.secondary,
        child: favoritesAsync.when(
          loading: () => Padding(
            padding: EdgeInsets.fromLTRB(
              16.0,
              MediaQuery.of(context).padding.top + 92.0,
              16.0,
              16.0,
            ),
            child: OffersShimmer(),
          ),
          error: (err, stack) => Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                24.0,
                MediaQuery.of(context).padding.top + 92.0,
                24.0,
                24.0,
              ),
              child: Text(
                '$errorText: $err',
                style: TextStyle(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          data: (offers) {
            if (offers.isEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height - 150,
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(
                    32.0,
                    MediaQuery.of(context).padding.top + 92.0,
                    32.0,
                    32.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border_rounded,
                        size: 64,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        emptyText,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                16.0,
                MediaQuery.of(context).padding.top + 92.0,
                16.0,
                16.0,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                return OfferCardGrid(offer: offers[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
