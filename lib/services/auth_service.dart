import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';
import 'user_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  
  // Simulates local storage
  static String? _authToken;
  static String? _userId;

  // Checks if user is authenticated
  static bool get isAuthenticated => _authToken != null;

  // Gets current token
  static String? get token => _authToken;

  // Gets current user ID
  static String? get userId => _userId;

  // Initialize authentication state from SharedPreferences
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString(_tokenKey);
    _userId = prefs.getString(_userIdKey);
  }

  // Attempts to authenticate user
  static Future<AuthResponse> login(AuthCredentials credentials) async {
    try {
      // Load user data from JSON
      final UserModel user = await UserService.loadUserData();

      // Verify credentials
      if (user.email.toLowerCase() == credentials.email.toLowerCase()) {
        // Verify password from JSON
        if (credentials.password == user.password) {
          // Generate simulated token
          final String token = base64Encode(utf8.encode('${user.id}:${DateTime.now().millisecondsSinceEpoch}'));
          
          // Save token and user ID
          _authToken = token;
          _userId = user.id;

          // Save to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, token);
          await prefs.setString(_userIdKey, user.id);

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

  // Logs out the user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    _authToken = null;
    _userId = null;
  }

  // Validates credentials
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