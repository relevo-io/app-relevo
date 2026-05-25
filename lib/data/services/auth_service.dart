import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

final authServiceProvider = Provider<UserService>((ref) {
  return UserService(ref.read(dioProvider));
});

class UserService {
  final Dio _dio;

  UserService(this._dio);

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Error de login');
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? language,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        'fullName': fullName,
        'email': email,
        'password': password,
        'roles': [role],
      };
      
      if (language != null) {
        requestData['language'] = language;
      }

      await _dio.post(
        '/usuarios',
        data: requestData,
      );
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Error en el registro');
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<void> updateLanguage(String userId, String languageCode) async {
    try {
      await _dio.patch(
        '/usuarios/$userId',
        data: {'language': languageCode},
      );
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Error actualizando idioma');
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<void> updateTheme(String userId, String theme) async {
    try {
      await _dio.patch(
        '/usuarios/$userId',
        data: {'theme': theme},
      );
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Error actualitzant tema');
      }
      throw Exception('Error de connexió: ${e.message}');
    }
  }
  Future<User> getMe() async {
    try {
      final response = await _dio.get('/auth/me');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Error obteniendo perfil');
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
