import 'package:flutter/material.dart';
import 'offer_map_widget_stub.dart'
    if (dart.library.html) 'offer_map_widget_web.dart'
    if (dart.library.io) 'offer_map_widget_mobile.dart';

class OfferMapWidget extends StatelessWidget {
  final String region;

  const OfferMapWidget({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    return getOfferMap(region: region);
  }
}
