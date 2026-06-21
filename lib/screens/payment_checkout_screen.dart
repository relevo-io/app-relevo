import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../data/models/payment_model.dart';
import '../data/services/payment_service.dart';
import '../l10n/app_localizations.dart';

class PaymentCheckoutScreen extends ConsumerStatefulWidget {
  const PaymentCheckoutScreen({
    super.key,
    required this.checkoutUrl,
    required this.paymentSessionId,
    required this.kind,
  });

  final String checkoutUrl;
  final String paymentSessionId;
  final PaymentKind kind;

  @override
  ConsumerState<PaymentCheckoutScreen> createState() =>
      _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends ConsumerState<PaymentCheckoutScreen> {
  static const _maxPollingAttempts = 150;

  WebViewController? _webViewController;
  bool _isLaunchingExternal = false;
  bool _isPolling = false;
  String? _errorMessage;
  int _pollingAttempts = 0;

  bool get _usesEmbeddedCheckout {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  void initState() {
    super.initState();

    if (_usesEmbeddedCheckout) {
      _configureWebView();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _launchExternalCheckout();
      });
    }
  }

  void _configureWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);
            if (_handleReturnUri(uri)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  bool _handleReturnUri(Uri? uri) {
    if (uri == null) return false;

    final paymentSessionId = uri.queryParameters['paymentSessionId'];
    if (paymentSessionId != widget.paymentSessionId) {
      return false;
    }

    final canceled = uri.queryParameters['canceled'] == '1';
    if (canceled) {
      Navigator.of(context).pop(
        CheckoutSessionStatus(
          status: PaymentStatus.canceled,
          kind: widget.kind,
        ),
      );
      return true;
    }

    unawaited(_pollUntilResolved());
    return true;
  }

  Future<void> _launchExternalCheckout() async {
    setState(() {
      _isLaunchingExternal = true;
      _errorMessage = null;
    });

    final uri = Uri.parse(widget.checkoutUrl);
    final launched = await launchUrl(
      uri,
      mode: kIsWeb
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );

    if (!mounted) return;

    setState(() {
      _isLaunchingExternal = false;
      if (!launched) {
        _errorMessage = AppLocalizations.of(context)!.paymentCheckoutOpenError;
      }
    });

    if (launched) {
      unawaited(_pollUntilResolved());
    }
  }

  Future<void> _pollUntilResolved() async {
    if (_isPolling || !mounted) return;

    setState(() {
      _isPolling = true;
      _errorMessage = null;
    });

    final paymentService = ref.read(paymentServiceProvider);

    try {
      while (mounted && _pollingAttempts < _maxPollingAttempts) {
        final status = await paymentService.getCheckoutSessionStatus(
          widget.paymentSessionId,
        );
        _pollingAttempts += 1;

        if (!mounted) return;

        if (status.isResolved) {
          Navigator.of(context).pop(status);
          return;
        }

        await Future<void>.delayed(const Duration(seconds: 2));
      }

      if (!mounted) return;

      setState(() {
        _errorMessage = AppLocalizations.of(
          context,
        )!.paymentCheckoutStatusError;
        _isPolling = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorMessage = AppLocalizations.of(
          context,
        )!.paymentCheckoutStatusError;
        _isPolling = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_usesEmbeddedCheckout && _webViewController != null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.paymentCheckoutTitle)),
        body: Stack(
          children: [
            WebViewWidget(controller: _webViewController!),
            if (_isPolling)
              Container(
                color: Colors.black45,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        l10n.paymentCheckoutChecking,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.paymentCheckoutTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.open_in_new_rounded, size: 56),
              const SizedBox(height: 16),
              Text(
                l10n.paymentCheckoutExternalTitle,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.paymentCheckoutExternalDescription,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (_isLaunchingExternal || _isPolling) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 12),
                Text(
                  _isLaunchingExternal
                      ? l10n.paymentCheckoutOpening
                      : l10n.paymentCheckoutChecking,
                  textAlign: TextAlign.center,
                ),
              ],
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _isLaunchingExternal
                    ? null
                    : _launchExternalCheckout,
                child: Text(l10n.paymentCheckoutOpen),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _isPolling ? null : _pollUntilResolved,
                child: Text(l10n.paymentCheckoutCheckNow),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(
                    CheckoutSessionStatus(
                      status: PaymentStatus.canceled,
                      kind: widget.kind,
                    ),
                  );
                },
                child: Text(l10n.notificationsCancel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
