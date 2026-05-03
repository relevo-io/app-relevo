import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class LanguageProvider extends ChangeNotifier {
  Locale? _currentLocale;
  final UserService _userService = UserService();

  Locale? get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('languageCode');

    if (savedLanguageCode != null) {
      _currentLocale = Locale(savedLanguageCode);
      notifyListeners();
    }
  }

  void setLanguageWithoutSync(String languageCode) {
    _currentLocale = Locale(languageCode);
    notifyListeners();
    _saveToPrefs(languageCode);
  }

  Future<void> changeLanguage(String languageCode, {String? userId}) async {
    if (_currentLocale?.languageCode == languageCode) return;

    _currentLocale = Locale(languageCode);
    notifyListeners();

    await _saveToPrefs(languageCode);

    if (userId != null) {
      try {
        await _userService.updateLanguage(userId, languageCode);
      } catch (e) {
        debugPrint('Error sincronitzant idioma amb el backend: $e');
      }
    }
  }

  Future<void> _saveToPrefs(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }
}
