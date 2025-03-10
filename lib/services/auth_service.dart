import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';
import 'user_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userDataKey = 'user_data';
  
  // Simula almacenamiento local
  static String? _authToken;
  static String? _userId;
  static UserModel? _currentUser;

  // Verifica si el usuario está autenticado
  static bool get isAuthenticated => _authToken != null;

  // Obtiene el token actual
  static String? get token => _authToken;

  // Obtiene el ID del usuario actual
  static String? get userId => _userId;

  // Obtiene el usuario actual
  static UserModel? get currentUser => _currentUser;

  // Inicializa el estado de autenticación desde SharedPreferences
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString(_tokenKey);
    _userId = prefs.getString(_userIdKey);
    final userDataString = prefs.getString(_userDataKey);
    
    if (userDataString != null) {
      try {
        final userData = json.decode(userDataString);
        _currentUser = UserModel.fromJson(userData);
      } catch (e) {
        // Si hay error al decodificar, limpiamos los datos
        await logout();
      }
    }
  }

  // Intenta autenticar al usuario
  static Future<AuthResponse> login(AuthCredentials credentials) async {
    try {
      // Autenticar usuario usando UserService
      final user = await UserService.authenticateUser(credentials.email, credentials.password);
      
      if (user != null) {
        // Generar token simulado
        final String token = base64Encode(utf8.encode('${user.id}:${DateTime.now().millisecondsSinceEpoch}'));
        
        // Guardar datos en memoria
        _authToken = token;
        _userId = user.id;
        _currentUser = user;

        // Guardar en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        await prefs.setString(_userIdKey, user.id);
        await prefs.setString(_userDataKey, json.encode(user.toJson()));

        return AuthResponse.success(
          token: token,
          userId: user.id,
        );
      }
      
      return AuthResponse.error('Credenciales inválidas');
    } catch (e) {
      return AuthResponse.error(e.toString());
    }
  }

  // Cierra la sesión del usuario
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userDataKey);
    _authToken = null;
    _userId = null;
    _currentUser = null;
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