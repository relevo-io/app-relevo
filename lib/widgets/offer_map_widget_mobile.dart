import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

Widget getOfferMap({required String region}) {
  return MobileOfferMap(region: region);
}

class MobileOfferMap extends StatefulWidget {
  final String region;
  const MobileOfferMap({super.key, required this.region});

  @override
  State<MobileOfferMap> createState() => _MobileOfferMapState();
}

class _MobileOfferMapState extends State<MobileOfferMap> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final String location = widget.region.trim().isEmpty ? 'Espana' : widget.region.trim();
    final String url = 'https://maps.google.com/maps?q=${Uri.encodeComponent("$location, Espana")}&z=12&output=embed';
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString('''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    html, body {
      margin: 0;
      padding: 0;
      width: 100%;
      height: 100%;
      overflow: hidden;
      background-color: transparent;
    }
    iframe {
      width: 100%;
      height: 100%;
      border: none;
    }
  </style>
</head>
<body>
  <iframe src="$url" allowfullscreen></iframe>
</body>
</html>
''');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
