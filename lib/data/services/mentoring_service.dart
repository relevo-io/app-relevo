import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../models/mentoring_module_model.dart';
import '../models/mentoring_progress_model.dart';

final mentoringServiceProvider = Provider<MentoringService>((ref) {
  return MentoringService(ref.read(dioProvider));
});

class MentoringService {
  final Dio _dio;

  MentoringService(this._dio);

  Future<List<MentoringModule>> getModules() async {
    try {
      final response = await _dio.get('/mentoring/modules');
      final List<dynamic> data = response.data;
      return data.map((json) => MentoringModule.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al obtener los módulos de mentoring',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<MentoringProgress> getProgress() async {
    try {
      final response = await _dio.get('/mentoring/progress');
      return MentoringProgress.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al obtener el progreso de mentoring',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<MentoringProgress> completeModule(String moduleId) async {
    try {
      final response = await _dio.post('/mentoring/progress/complete/$moduleId');
      return MentoringProgress.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al completar el módulo de mentoring',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<String> getMarkdownContent(String route, String contentKey, String lang) async {
    try {
      final response = await _dio.get(
        '/mentoring/content/$route/$contentKey',
        queryParameters: {'lang': lang},
        options: Options(responseType: ResponseType.plain),
      );
      return response.data ?? '';
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final errorData = e.response?.data;
        if (errorData is Map) {
          throw Exception(
            errorData['message'] ?? 'Error al obtener el contenido de mentoring',
          );
        } else {
          throw Exception(errorData.toString());
        }
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
