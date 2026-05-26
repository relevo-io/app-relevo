import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../models/offer_model.dart';

final offerServiceProvider = Provider<OfferService>((ref) {
  return OfferService(ref.read(dioProvider));
});

class OfferService {
  final Dio _dio;

  OfferService(this._dio);

  Future<List<Offer>> getOffers() async {
    try {
      final response = await _dio.get('/ofertas');
      final List<dynamic> data = response.data;
      return data.map((json) => Offer.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al obtener ofertas',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
