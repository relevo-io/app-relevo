import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_relevo/data/providers/chat_providers.dart';
import 'package:flutter_relevo/data/models/rating_model.dart';
import 'package:flutter_relevo/l10n/app_localizations.dart';
import 'package:flutter_relevo/widgets/glassmorphic_app_bar.dart';

class UserRatingsScreen extends ConsumerWidget {
  const UserRatingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingsAsync = ref.watch(userRatingsProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassmorphicAppBar(
        title: Text(
          l10n.profileRatingsTitle,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      body: ratingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            err.toString(),
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
        data: (response) {
          final ratings = response.ratings;
          
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              24.0,
              MediaQuery.of(context).padding.top + 92.0,
              24.0,
              24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Summary cards side-by-side
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        context,
                        title: l10n.profileRatingsAsBuyer,
                        summary: response.asInterested,
                        icon: Icons.shopping_bag_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        context,
                        title: l10n.profileRatingsAsSeller,
                        summary: response.asOwner,
                        icon: Icons.storefront_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // List section
                if (ratings.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star_outline_rounded,
                            size: 64,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.profileRatingsEmpty,
                            style: GoogleFonts.inter(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ratings.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final rating = ratings[index];
                      return _buildRatingCard(context, rating, locale);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required RatingSummary summary,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : Colors.white.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                summary.average > 0 ? summary.average.toStringAsFixed(1) : '-',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final double starVal = index + 1.0;
                  final double score = summary.average;
                  return Icon(
                    score >= starVal
                        ? Icons.star_rounded
                        : (score >= starVal - 0.5 ? Icons.star_half_rounded : Icons.star_outline_rounded),
                    color: Colors.amber[700],
                    size: 14,
                  );
                }),
              ),
              const SizedBox(height: 6),
              Text(
                '(${summary.count})',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingCard(BuildContext context, Rating rating, String locale) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final formattedDate = rating.createdAt != null
        ? timeago.format(rating.createdAt!, locale: locale)
        : '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      rating.senderName.isNotEmpty ? rating.senderName : 'Relevo User',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating.score ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: Colors.amber[700],
                        size: 16,
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      rating.ratedRole == 'OWNER' ? 'Seller' : 'Buyer',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              if (rating.comment != null && rating.comment!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  rating.comment!,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.4,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
