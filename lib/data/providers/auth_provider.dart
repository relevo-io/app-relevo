import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  
  User? _currentUser;
  bool _isLoading = false;
  String? _token;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('access_token');
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final response = await _userService.login(email, password);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', response.accessToken);
      
      _token = response.accessToken;
      _currentUser = response.usuario;
      
      _setLoading(false);
      return true;
      
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    _setLoading(true);
    try {
      await _userService.register(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
      );
      // Hacemos login automático con los mismos datos
      return await login(email, password);
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    
    _token = null;
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
