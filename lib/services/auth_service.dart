import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';
import 'user_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  
  // Simula almacenamiento local
  static String? _authToken;
  static String? _userId;

  // Verifica si el usuario está autenticado
  static bool get isAuthenticated => _authToken != null;

  // Obtiene el token actual
  static String? get token => _authToken;

  // Obtiene el ID del usuario actual
  static String? get userId => _userId;

  // Intenta autenticar al usuario
  static Future<AuthResponse> login(AuthCredentials credentials) async {
    try {
      // Carga los datos del usuario del JSON
      final UserModel user = await UserService.loadUserData();

      // Verifica las credenciales (en este caso, solo verifica el email)
      if (user.email.toLowerCase() == credentials.email.toLowerCase()) {
        // En un caso real, aquí verificarías la contraseña con hash
        if (credentials.password == '123456') { // Contraseña de prueba
          // Genera un token simulado
          final String token = base64Encode(utf8.encode('${user.id}:${DateTime.now().millisecondsSinceEpoch}'));
          
          // Guarda el token y el ID del usuario
          _authToken = token;
          _userId = user.id;

          return AuthResponse.success(
            token: token,
            userId: user.id,
          );
        }
        return AuthResponse.error('Contraseña incorrecta');
      }
      return AuthResponse.error('Usuario no encontrado');
    } catch (e) {
      return AuthResponse.error('Error de autenticación: $e');
    }
  }

  // Cierra la sesión del usuario
  static Future<void> logout() async {
    _authToken = null;
    _userId = null;
  }

  // Verifica si las credenciales son válidas
  static bool _validateCredentials(AuthCredentials credentials) {
    if (credentials.email.isEmpty || !credentials.email.contains('@')) {
      return false;
    }
    if (credentials.password.isEmpty || credentials.password.length < 6) {
      return false;
    }
    return true;
  }
} 