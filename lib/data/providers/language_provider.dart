import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_provider.dart';
import '../services/auth_service.dart';

part 'language_provider.g.dart';

@Riverpod(keepAlive: true)
class LanguageState extends _$LanguageState {
  static const _languageKey = 'languageCode';

  @override
  Locale build() {
    _loadSavedLanguage();

    ref.listen(authProvider, (previous, next) {
      next.whenData((user) {
        if (user != null && user.language != null) {
          final backendLocale = Locale(user.language!);
          if (state != backendLocale) {
            state = backendLocale;
            _saveToPrefs(user.language!);
          }
        }
      });
    });

    return const Locale('es');
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString(_languageKey);

    if (savedLanguageCode != null) {
      state = Locale(savedLanguageCode);
    }
  }

  void setLanguageWithoutSync(String languageCode) {
    state = Locale(languageCode);
    _saveToPrefs(languageCode);
  }

  Future<void> changeLanguage(String languageCode, {String? userId}) async {
    if (state.languageCode == languageCode) return;

    state = Locale(languageCode);
    await _saveToPrefs(languageCode);

    if (userId != null) {
      try {
        await ref.read(authServiceProvider).updateLanguage(userId, languageCode);
      } catch (e) {
        debugPrint('Error sincronitzant idioma amb el backend: $e');
      }
    }
  }

  Future<void> _saveToPrefs(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
}
