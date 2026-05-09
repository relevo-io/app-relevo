import 'user_model.dart';

class AuthResponse {
  final String message;
  final String accessToken;
  final String? refreshToken;
  final User usuario;

  AuthResponse({
    required this.message,
    required this.accessToken,
    this.refreshToken,
    required this.usuario,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'] ?? '',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'],
      usuario: User.fromJson(json['usuario'] ?? {}),
    );
  }
}
