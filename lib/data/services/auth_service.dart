import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../models/auth_response_model.dart';

class UserService {
  final Dio _dio = ApiClient().dio;

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
  }) async {
    try {
      await _dio.post(
        '/usuarios',
        data: {
          'fullName': fullName,
          'email': email,
          'password': password,
          'roles': [role],
        },
      );
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Error en el registro');
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
