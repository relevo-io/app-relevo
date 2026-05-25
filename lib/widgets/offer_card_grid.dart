import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../data/models/offer_model.dart';

class OfferCardGrid extends StatelessWidget {
  final Offer offer;

  const OfferCardGrid({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder with Heart button
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: Icon(Icons.storefront_outlined, size: 50, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.favorite_border, size: 20, color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatRevenue(offer.revenueRange),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  offer.companyDescription,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  offer.publishedAt != null 
                      ? timeago.format(offer.publishedAt!, locale: 'es') 
                      : 'Ahora',
                  style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatRevenue(String? range) {
    if (range == null) return 'Consulta';
    switch (range) {
      case 'UNDER_100K': return '100.000 €';
      case 'BETWEEN_100K_500K': return '500.000 €';
      case 'BETWEEN_500K_1M': return '1.000.000 €';
      case 'BETWEEN_1M_5M': return '5.000.000 €';
      case 'OVER_5M': return '8.500.000 €';
      default: return 'Detalles';
    }
  }
}
