import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/payment_model.dart';
import '../network/dio_client.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService(ref.read(dioProvider));
});

class PaymentService {
  PaymentService(this._dio);

  final Dio _dio;

  Future<CheckoutSessionResponse> createCheckoutSession(
    CreateCheckoutSessionPayload payload,
  ) async {
    try {
      final response = await _dio.post(
        '/payments/checkout-session',
        data: payload.toJson(),
      );
      return CheckoutSessionResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al crear la sesión de pago',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<CheckoutSessionStatus> getCheckoutSessionStatus(
    String paymentSessionId,
  ) async {
    try {
      final response = await _dio.get(
        '/payments/checkout-session/$paymentSessionId/status',
      );
      return CheckoutSessionStatus.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ??
              'Error al comprobar el estado del pago',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<CheckoutSessionStatus> waitForResolvedStatus(
    String paymentSessionId, {
    int attempts = 8,
    Duration interval = const Duration(seconds: 2),
  }) async {
    late CheckoutSessionStatus latestStatus;

    for (var i = 0; i < attempts; i++) {
      if (i > 0) {
        await Future<void>.delayed(interval);
      }

      latestStatus = await getCheckoutSessionStatus(paymentSessionId);
      if (latestStatus.isResolved) {
        return latestStatus;
      }
    }

    return latestStatus;
  }
}
