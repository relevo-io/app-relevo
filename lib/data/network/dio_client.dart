import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  return DioClient(const FlutterSecureStorage(), ref: ref).dio;
});

class DioClient {
  final FlutterSecureStorage _storage;
  final Ref? _ref;
  late final Dio dio;

  DioClient(this._storage, {Ref? ref}) : _ref = ref {
    dio = Dio(
      BaseOptions(
        baseUrl: Platform.isAndroid
            ? 'http://10.0.2.2:4000/api'
            : 'http://localhost:4000/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    dio.interceptors.add(AuthInterceptor(_storage, dio, _ref));
  }
}

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Dio dio;
  final Ref? ref;

  AuthInterceptor(this.storage, this.dio, this.ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.read(key: 'access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    final locale = ref?.read(languageStateProvider);
    if (locale != null) {
      options.headers['Accept-Language'] = locale.languageCode;
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // If 401 Unauthorized and not already trying to login/refresh
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains('/auth/')) {
      final success = await _refreshToken();
      if (success) {
        // Retry the failed request with the new token
        final opts = err.requestOptions;
        final token = await storage.read(key: 'access_token');
        opts.headers['Authorization'] = 'Bearer $token';

        try {
          final cloneReq = await dio.fetch(opts);
          return handler.resolve(cloneReq);
        } catch (e) {
          return handler.reject(err);
        }
      } else {
        // Refresh failed, clean session
        await storage.deleteAll();
        // Notificamos al authProvider para que limpie el estado y la UI redirija al login
        ref?.read(authProvider.notifier).logout();
      }
    }
    return handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await storage.read(key: 'refresh_token');
      if (refreshToken == null) return false;

      // Use a new Dio instance to avoid interceptor loops
      final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
      final response = await refreshDio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];

        if (newAccessToken != null && newRefreshToken != null) {
          await storage.write(key: 'access_token', value: newAccessToken);
          await storage.write(key: 'refresh_token', value: newRefreshToken);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
