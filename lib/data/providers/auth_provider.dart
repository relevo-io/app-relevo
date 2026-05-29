import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  final _storage = const FlutterSecureStorage();

  @override
  FutureOr<User?> build() async {
    return _checkAuth();
  }

  Future<User?> _checkAuth() async {
    final token = await _storage.read(key: 'access_token');
    if (token != null && token.isNotEmpty) {
      try {
        final userService = ref.read(authServiceProvider);
        final user = await userService.getMe();
        return user;
      } catch (e) {
        // Token might be invalid or expired and refresh failed
        await _storage.deleteAll();
        return null;
      }
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final userService = ref.read(authServiceProvider);
      final response = await userService.login(email, password);

      await _storage.write(key: 'access_token', value: response.accessToken);
      if (response.refreshToken != null) {
        await _storage.write(
          key: 'refresh_token',
          value: response.refreshToken!,
        );
      }
      state = AsyncValue.data(response.usuario);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? language,
  }) async {
    state = const AsyncValue.loading();
    try {
      final userService = ref.read(authServiceProvider);
      await userService.register(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        language: language,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String fullName,
    String? location,
    String? bio,
    String? professionalBackground,
    List<String>? preferredRegions,
  }) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    state = const AsyncValue.loading();
    try {
      final userService = ref.read(authServiceProvider);
      await userService.updateProfile(
        currentUser.id,
        fullName: fullName,
        location: location,
        bio: bio,
        professionalBackground: professionalBackground,
        preferredRegions: preferredRegions,
      );
      final updatedUser = await userService.getMe();
      state = AsyncValue.data(updatedUser);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    await _storage.deleteAll();
    state = const AsyncValue.data(null);
  }
}
