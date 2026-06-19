import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../models/offer_model.dart';
import '../models/pagination_model.dart';

final offerServiceProvider = Provider<OfferService>((ref) {
  return OfferService(ref.read(dioProvider));
});

class OfferService {
  final Dio _dio;

  OfferService(this._dio);

  Future<PaginatedResult<Offer>> getOffers({
    int page = 1,
    int limit = 12,
    String? search,
    String? excludeOwnerId,
  }) async {
    try {
      final response = await _dio.get(
        '/ofertas',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (search != null && search.isNotEmpty) 'search': search,
          if (excludeOwnerId != null && excludeOwnerId.isNotEmpty)
            'excludeOwnerId': excludeOwnerId,
        },
      );
      if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> data = response.data;
        final List<dynamic> itemsJson = data['items'] ?? [];
        final items = itemsJson.map((json) => Offer.fromJson(json)).toList();
        final pagination = PaginationMetadata.fromJson(data['pagination'] ?? {});
        return PaginatedResult(items: items, pagination: pagination);
      } else {
        final List<dynamic> data = response.data;
        final items = data.map((json) => Offer.fromJson(json)).toList();
        return PaginatedResult(
          items: items,
          pagination: PaginationMetadata(
            page: 1,
            limit: items.length,
            totalItems: items.length,
            totalPages: 1,
            hasNextPage: false,
            hasPrevPage: false,
          ),
        );
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al obtener ofertas',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<List<Offer>> getMyOffers() async {
    try {
      final response = await _dio.get('/ofertas/me');
      final List<dynamic> data = response.data;
      return data.map((json) => Offer.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al obtener mis ofertas',
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
          'revenueRange': revenueRange,
          'creationYear': creationYear,
          'employeeRange': employeeRange,
          'companyDescription': companyDescription,
          'extendedDescription': extendedDescription,
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

  Future<List<Offer>> getFavoriteOffers() async {
    try {
      final response = await _dio.get('/ofertas/favorites');
      if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> data = response.data;
        final List<dynamic> itemsJson = data['items'] ?? [];
        return itemsJson.map((json) => Offer.fromJson(json)).toList();
      } else {
        final List<dynamic> data = response.data;
        return data.map((json) => Offer.fromJson(json)).toList();
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al obtener favoritos',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<int> addFavorite(String offerId) async {
    try {
      final response = await _dio.post('/ofertas/$offerId/favorite');
      return response.data['favoriteCount'] ?? 0;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al añadir a favoritos',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<int> removeFavorite(String offerId) async {
    try {
      final response = await _dio.delete('/ofertas/$offerId/favorite');
      return response.data['favoriteCount'] ?? 0;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al eliminar de favoritos',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
