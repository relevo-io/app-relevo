import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../models/alert_model.dart';

final alertServiceProvider = Provider<AlertService>((ref) {
  return AlertService(ref.read(dioProvider));
});

class AlertService {
  final Dio _dio;

  AlertService(this._dio);

  Future<List<Alert>> getAlerts() async {
    try {
      final response = await _dio.get('/alertas');
      final List<dynamic> data = response.data;
      return data.map((json) => Alert.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al obtener alertas',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<Alert> createAlert(String revenueRange) async {
    try {
      final response = await _dio.post(
        '/alertas',
        data: {'revenueRange': revenueRange},
      );
      return Alert.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al crear alerta',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<void> deleteAlert(String alertId) async {
    try {
      await _dio.delete('/alertas/$alertId');
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al eliminar alerta',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
