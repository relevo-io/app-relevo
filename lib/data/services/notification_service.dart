import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../models/notification_model.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref.read(dioProvider));
});

class NotificationService {
  final Dio _dio;

  NotificationService(this._dio);

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _dio.get('/notificaciones');
      final List<dynamic> data = response.data;
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al obtener notificaciones',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<NotificationModel> markAsRead(String notificationId) async {
    try {
      final response = await _dio.patch('/notificaciones/$notificationId/read');
      return NotificationModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al marcar como leída',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
