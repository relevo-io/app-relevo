// ignore_for_file: avoid_web_libraries_in_flutter
// ignore_for_file: deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

Widget getOfferMap({required String region}) {
  final String location = region.trim().isEmpty ? 'Espana' : region.trim();
  final String viewType = 'map-iframe-${location.hashCode}';
  final String url = 'https://maps.google.com/maps?q=${Uri.encodeComponent("$location, Espana")}&z=12&output=embed';

  // Register view factory for web
  // ignore: undefined_prefixed_name
  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    return html.IFrameElement()
      ..src = url
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%';
  });

  return Container(
    height: 220,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.grey.withValues(alpha: 0.3),
        width: 1,
      ),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: HtmlElementView(viewType: viewType),
    ),
  );
}
