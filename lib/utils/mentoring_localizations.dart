import '../l10n/app_localizations.dart';

extension MentoringLocalizations on AppLocalizations {
  String translateMentoringKey(String key) {
    final normalized = key.replaceAll('.', '_');
    switch (normalized) {
      // Seller Module 1
      case 'mentoring_seller_m1_title': return mentoring_seller_m1_title;
      case 'mentoring_seller_m1_description': return mentoring_seller_m1_description;
      case 'mentoring_seller_m1_i1_title': return mentoring_seller_m1_i1_title;
      // Seller Module 2
      case 'mentoring_seller_m2_title': return mentoring_seller_m2_title;
      case 'mentoring_seller_m2_description': return mentoring_seller_m2_description;
      case 'mentoring_seller_m2_i1_title': return mentoring_seller_m2_i1_title;
      // Seller Module 3
      case 'mentoring_seller_m3_title': return mentoring_seller_m3_title;
      case 'mentoring_seller_m3_description': return mentoring_seller_m3_description;
      case 'mentoring_seller_m3_i1_title': return mentoring_seller_m3_i1_title;
      // Seller Module 4
      case 'mentoring_seller_m4_title': return mentoring_seller_m4_title;
      case 'mentoring_seller_m4_description': return mentoring_seller_m4_description;
      case 'mentoring_seller_m4_i1_title': return mentoring_seller_m4_i1_title;
      // Seller Module 5
      case 'mentoring_seller_m5_title': return mentoring_seller_m5_title;
      case 'mentoring_seller_m5_description': return mentoring_seller_m5_description;
      case 'mentoring_seller_m5_i1_title': return mentoring_seller_m5_i1_title;
      // Seller Module 6
      case 'mentoring_seller_m6_title': return mentoring_seller_m6_title;
      case 'mentoring_seller_m6_description': return mentoring_seller_m6_description;
      case 'mentoring_seller_m6_i1_title': return mentoring_seller_m6_i1_title;

      // Buyer Module 1
      case 'mentoring_buyer_m1_title': return mentoring_buyer_m1_title;
      case 'mentoring_buyer_m1_description': return mentoring_buyer_m1_description;
      case 'mentoring_buyer_m1_i1_title': return mentoring_buyer_m1_i1_title;
      // Buyer Module 2
      case 'mentoring_buyer_m2_title': return mentoring_buyer_m2_title;
      case 'mentoring_buyer_m2_description': return mentoring_buyer_m2_description;
      case 'mentoring_buyer_m2_i1_title': return mentoring_buyer_m2_i1_title;
      // Buyer Module 3
      case 'mentoring_buyer_m3_title': return mentoring_buyer_m3_title;
      case 'mentoring_buyer_m3_description': return mentoring_buyer_m3_description;
      case 'mentoring_buyer_m3_i1_title': return mentoring_buyer_m3_i1_title;
      // Buyer Module 4
      case 'mentoring_buyer_m4_title': return mentoring_buyer_m4_title;
      case 'mentoring_buyer_m4_description': return mentoring_buyer_m4_description;
      case 'mentoring_buyer_m4_i1_title': return mentoring_buyer_m4_i1_title;
      // Buyer Module 5
      case 'mentoring_buyer_m5_title': return mentoring_buyer_m5_title;
      case 'mentoring_buyer_m5_description': return mentoring_buyer_m5_description;
      case 'mentoring_buyer_m5_i1_title': return mentoring_buyer_m5_i1_title;
      // Buyer Module 6
      case 'mentoring_buyer_m6_title': return mentoring_buyer_m6_title;
      case 'mentoring_buyer_m6_description': return mentoring_buyer_m6_description;
      case 'mentoring_buyer_m6_i1_title': return mentoring_buyer_m6_i1_title;
      // Buyer Module 7
      case 'mentoring_buyer_m7_title': return mentoring_buyer_m7_title;
      case 'mentoring_buyer_m7_description': return mentoring_buyer_m7_description;
      case 'mentoring_buyer_m7_i1_title': return mentoring_buyer_m7_i1_title;

      default:
        return key;
    }
  }
}
