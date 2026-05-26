import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_provider.dart';
import '../services/auth_service.dart';

part 'theme_provider.g.dart';

@Riverpod(keepAlive: true)
class ThemeState extends _$ThemeState {
  static const _themeKey = 'theme_preference';

  @override
  ThemeMode build() {
    // Inicialización asíncrona pero devolvemos un valor inicial síncrono
    _loadInitialTheme();

    // Escuchar cambios en el usuario para sincronizar el tema desde el backend
    ref.listen(authProvider, (previous, next) {
      next.whenData((user) {
        if (user != null && user.theme != null) {
          final backendTheme = user.theme == 'dark'
              ? ThemeMode.dark
              : ThemeMode.light;
          if (state != backendTheme) {
            state = backendTheme;
            _saveToPrefs(user.theme!);
          }
        }
      });
    });

    return ThemeMode.light;
  }

  Future<void> _loadInitialTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);

    if (savedTheme != null) {
      state = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    state = newTheme;

    final themeStr = newTheme == ThemeMode.dark ? 'dark' : 'light';
    await _saveToPrefs(themeStr);

    // Sincronizar con backend si hay usuario logeado
    final authState = ref.read(authProvider);
    final user = authState.value;

    if (user != null) {
      try {
        await ref.read(authServiceProvider).updateTheme(user.id, themeStr);
      } catch (e) {
        debugPrint('Error sincronitzant tema amb el backend: $e');
      }
    }
  }

  Future<void> _saveToPrefs(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme);
  }
}
