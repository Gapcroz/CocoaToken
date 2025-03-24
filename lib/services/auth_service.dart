import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';
import '../models/store_model.dart';
import 'user_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userTypeKey = 'user_type';
  static const String _userDataKey = 'user_data';
  static const String _storeDataKey = 'store_data';
  static const String _userIdKey = 'user_id';
  
  // Variables estáticas privadas
  static String? _authToken;
  static String? _userId;
  static UserModel? _currentUser;
  static bool _isInitialized = false;

  // Getters públicos
  static bool get isAuthenticated => _authToken != null;
  static String? get token => _authToken;
  static String? get userId => _userId;
  static UserModel? get currentUser => _currentUser;

  static Future<void> checkAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString(_tokenKey);
      _userId = prefs.getString(_userIdKey);
      
      final userType = prefs.getString(_userTypeKey);
      final userData = userType == 'store' 
          ? prefs.getString(_storeDataKey)
          : prefs.getString(_userDataKey);

      if (userData != null) {
        final data = json.decode(userData);
        if (userType == 'store') {
          print('Datos de tienda recuperados');
        } else {
          _currentUser = UserModel.fromJson(data);
          print('Datos de usuario recuperados');
        }
      }
    } catch (e) {
      print('Error en checkAuthState: $e');
      await logout();
    }
  }

  static Future<void> init() async {
    if (_isInitialized) return;
    await checkAuthState();
    _isInitialized = true;
  }

  static Future<AuthResponse> login(AuthCredentials credentials) async {
    try {
      print('Intentando login con: ${credentials.email}');
      
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Verificar en tiendas primero
      final List<dynamic> storesJson = jsonData['tables']['stores'] as List<dynamic>;
      for (var storeJson in storesJson) {
        if (storeJson['email'] == credentials.email && 
            storeJson['password'] == credentials.password) {
          
          print('Tienda encontrada: ${storeJson['name']}');
          
          // Generar token
          final String token = base64Encode(utf8.encode('${storeJson['id']}:${DateTime.now().millisecondsSinceEpoch}'));
          
          // Guardar en SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, token);
          await prefs.setString(_userIdKey, storeJson['id']);
          await prefs.setString(_userTypeKey, 'store');
          await prefs.setString(_storeDataKey, json.encode(storeJson));
          
          // Actualizar variables estáticas
          _authToken = token;
          _userId = storeJson['id'];
          
          print('Datos de tienda guardados');

          return AuthResponse.success(
            token: token,
            userId: storeJson['id'],
          );
        }
      }
      
      // Verificar usuarios
      final List<dynamic> usersJson = jsonData['tables']['users'] as List<dynamic>;
      for (var userJson in usersJson) {
        if (userJson['email'] == credentials.email && 
            userJson['password'] == credentials.password) {
          
          print('Usuario encontrado: ${userJson['name']}');
          
          // Generar token
          final String token = base64Encode(utf8.encode('${userJson['id']}:${DateTime.now().millisecondsSinceEpoch}'));
          
          // Guardar en SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, token);
          await prefs.setString(_userIdKey, userJson['id']);
          await prefs.setString(_userTypeKey, 'user');
          await prefs.setString(_userDataKey, json.encode(userJson));
          
          // Actualizar variables estáticas
          _authToken = token;
          _userId = userJson['id'];
          _currentUser = UserModel.fromJson(userJson);
          
          print('Datos de usuario guardados');

          return AuthResponse.success(
            token: token,
            userId: userJson['id'],
          );
        }
      }
      
      return AuthResponse.error('Credenciales inválidas');
    } catch (e) {
      print('Error en login: $e');
      return AuthResponse.error(e.toString());
    }
  }

  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_userTypeKey);
      await prefs.remove(_userDataKey);
      await prefs.remove(_storeDataKey);
      
      // Limpiar variables estáticas
      _authToken = null;
      _userId = null;
      _currentUser = null;
      _isInitialized = false;
      
      print('Sesión cerrada correctamente');
    } catch (e) {
      print('Error en logout: $e');
    }
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

  // Alternative method to update user data
  static Future<void> refreshUserData() async {
    if (_authToken == null || _userId == null || _currentUser == null) return;
    
    try {
      await checkAuthState();
    } catch (e) {
      print('Error al actualizar datos: $e');
    }
  }

  static Future<List<UserModel>> getAllUsers() async {
    try {
      // Cargar datos de usuario desde el archivo JSON
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Actualizado para acceder a la estructura de tablas
      final List<dynamic> usersJson = jsonData['tables']['users'] as List<dynamic>;
      print('Usuarios encontrados en JSON: ${usersJson.length}');
      
      return usersJson.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      print('Error cargando usuarios: $e');
      return [];
    }
  }

  // Método para obtener todas las tiendas
  static Future<List<dynamic>> getAllStores() async {
    try {
      // Cargar datos desde el archivo JSON
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Acceder a la tabla de tiendas
      final List<dynamic> storesJson = jsonData['tables']['stores'] as List<dynamic>;
      print('Tiendas encontradas en JSON: ${storesJson.length}');
      
      return storesJson;
    } catch (e) {
      print('Error cargando tiendas: $e');
      return [];
    }
  }

  // Método para autenticar tiendas
  static Future<StoreModel?> authenticateStore(String email, String password) async {
    try {
      final stores = await getAllStores();
      
      for (var store in stores) {
        if (store['email'] == email && store['password'] == password) {
          return StoreModel.fromJson(store);
        }
      }
      
      return null;
    } catch (e) {
      print('Error autenticando tienda: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userType = prefs.getString(_userTypeKey);
      
      if (userType == 'store') {
        final storeData = prefs.getString(_storeDataKey);
        return storeData != null ? json.decode(storeData) : null;
      } else {
        final userData = prefs.getString(_userDataKey);
        return userData != null ? json.decode(userData) : null;
      }
    } catch (e) {
      print('Error obteniendo datos del usuario: $e');
      return null;
    }
  }
} 