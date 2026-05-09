import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/models/offer_model.dart';

class OfferCardHorizontal extends StatelessWidget {
  final Offer offer;

  const OfferCardHorizontal({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(
              child: Icon(Icons.business, size: 50, color: Colors.grey[300]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.verified, size: 14, color: Colors.black),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        offer.sector.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  offer.companyDescription,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatRevenue(offer.revenueRange),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
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
      case 'UNDER_100K': return '< 100k€';
      case 'BETWEEN_100K_500K': return '500k€';
      case 'BETWEEN_500K_1M': return '1M€';
      case 'BETWEEN_1M_5M': return '5M€';
      case 'OVER_5M': return '> 5M€';
      default: return 'Detalles';
    }
  }
}
