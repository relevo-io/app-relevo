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

  Future<Offer> getOfferById(String id) async {
    try {
      final response = await _dio.get('/ofertas/$id');
      return Offer.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al obtener la oferta',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<Offer> createOffer({
    required String region,
    required String sector,
    String? revenueRange,
    int? creationYear,
    String? employeeRange,
    required String companyDescription,
    String? extendedDescription,
  }) async {
    try {
      final response = await _dio.post(
        '/ofertas',
        data: {
          'region': region,
          'sector': sector,
          'revenueRange': ?revenueRange,
          'creationYear': ?creationYear,
          'employeeRange': ?employeeRange,
          'companyDescription': companyDescription,
          'extendedDescription': ?extendedDescription,
        },
      );
      return Offer.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al crear la oferta',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
