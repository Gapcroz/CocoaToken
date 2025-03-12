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
  static bool _isInitialized = false;

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
    if (_isInitialized) return;
    
    try {
      // Dividir la inicialización en partes más pequeñas
      final prefs = await SharedPreferences.getInstance();
      
      // Cargar token y userId primero
      _authToken = prefs.getString(_tokenKey);
      _userId = prefs.getString(_userIdKey);
      
      // Pequeña pausa para no bloquear el hilo principal
      await Future.delayed(const Duration(milliseconds: 10));
      
      // Cargar datos de usuario después
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
      
      _isInitialized = true;
    } catch (e) {
      // Si hay error, limpiamos los datos
      await logout();
      _isInitialized = false;
    }
  }

  // Intenta autenticar al usuario
  static Future<AuthResponse> login(AuthCredentials credentials) async {
    try {
      // Imprimir para depuración
      print('Intentando login con: ${credentials.email}');
      
      // Autenticar usuario usando UserService
      final user = await UserService.authenticateUser(credentials.email, credentials.password);
      
      if (user != null) {
        // Verificar que el usuario tenga todos los datos
        print('Usuario autenticado: ${user.name}');
        print('Tokens: ${user.tokens}');
        print('Cupones: ${user.coupons.length}');
        print('Recompensas: ${user.rewardsHistory.length}');
        
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
      print('Error en login: $e');
      return AuthResponse.error(e.toString());
    }
  }

  // Cierra la sesión del usuario
  static Future<void> logout() async {
    print("Logging out and clearing all data");
    
    // Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userDataKey);
    
    // Clear memory variables
    _authToken = null;
    _userId = null;
    _currentUser = null;
    _isInitialized = false;
    
    print("Session closed and data cleared");
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

  // Método alternativo para actualizar los datos del usuario
  static Future<void> refreshUserData() async {
    if (!isAuthenticated || _userId == null || _currentUser == null) return;
    
    try {
      // Simplemente verificamos que el usuario actual tenga datos válidos
      if (_currentUser != null && _currentUser!.id == _userId) {
        // Los datos del usuario ya están cargados, no necesitamos hacer nada más
        return;
      }
      
      // Si llegamos aquí, algo está mal con los datos del usuario
      // Intentamos cargar los datos desde SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userDataKey);
      
      if (userDataString != null) {
        try {
          final userData = json.decode(userDataString);
          _currentUser = UserModel.fromJson(userData);
        } catch (e) {
          // Si hay error al decodificar, limpiamos los datos
          await logout();
        }
      } else {
        // Si no hay datos en SharedPreferences, cerramos sesión
        await logout();
      }
    } catch (e) {
      print('Error al actualizar datos del usuario: $e');
    }
  }

  static Future<List<UserModel>> getAllUsers() async {
    try {
      // Cargar datos de usuario desde el archivo JSON
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      print('JSON cargado: $jsonString');
      
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      final List<dynamic> usersJson = jsonData['users'] as List<dynamic>;
      print('Usuarios encontrados en JSON: ${usersJson.length}');
      
      return usersJson.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      print('Error cargando usuarios: $e');
      return [];
    }
  }
} 