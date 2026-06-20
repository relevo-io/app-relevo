typedef OfferDraftPayload = Map<String, dynamic>;

enum PaymentKind {
  offerPublication('offer_publication'),
  proActivation('pro_activation');

  const PaymentKind(this.apiValue);

  final String apiValue;
}

enum PaymentStatus {
  pending('pending'),
  processing('processing'),
  completed('completed'),
  failed('failed'),
  canceled('canceled');

  const PaymentStatus(this.apiValue);

  final String apiValue;

  static PaymentStatus fromApi(String value) {
    return PaymentStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => PaymentStatus.pending,
    );
  }
}

class CreateCheckoutSessionPayload {
  const CreateCheckoutSessionPayload({
    required this.kind,
    this.offerDraft,
    this.returnUrlBase,
  });

  final PaymentKind kind;
  final OfferDraftPayload? offerDraft;
  final String? returnUrlBase;

  Map<String, dynamic> toJson() {
    return {
      'kind': kind.apiValue,
      if (offerDraft != null) 'offerDraft': offerDraft,
      if (returnUrlBase != null) 'returnUrlBase': returnUrlBase,
    };
  }
}

class CheckoutSessionResponse {
  const CheckoutSessionResponse({
    required this.checkoutUrl,
    required this.paymentSessionId,
  });

  final String checkoutUrl;
  final String paymentSessionId;

  factory CheckoutSessionResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutSessionResponse(
      checkoutUrl: json['checkoutUrl']?.toString() ?? '',
      paymentSessionId: json['paymentSessionId']?.toString() ?? '',
    );
  }
}

class CheckoutSessionStatus {
  const CheckoutSessionStatus({
    required this.status,
    required this.kind,
    this.createdOfferId,
    this.proActive,
    this.proExpiresAt,
  });

  final PaymentStatus status;
  final PaymentKind kind;
  final String? createdOfferId;
  final bool? proActive;
  final DateTime? proExpiresAt;

  bool get isResolved =>
      status == PaymentStatus.completed ||
      status == PaymentStatus.failed ||
      status == PaymentStatus.canceled;

  factory CheckoutSessionStatus.fromJson(Map<String, dynamic> json) {
    return CheckoutSessionStatus(
      status: PaymentStatus.fromApi(json['status']?.toString() ?? ''),
      kind:
          (json['kind']?.toString() ?? '') ==
              PaymentKind.offerPublication.apiValue
          ? PaymentKind.offerPublication
          : PaymentKind.proActivation,
      createdOfferId: json['createdOfferId']?.toString(),
      proActive: json['proActive'] as bool?,
      proExpiresAt: json['proExpiresAt'] != null
          ? DateTime.tryParse(json['proExpiresAt'].toString())
          : null,
    );
  }
}
