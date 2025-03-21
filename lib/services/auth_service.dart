import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';
import '../models/store_model.dart';
import 'user_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userDataKey = 'user_data';
  static const String _storeDataKey = 'store_data';
  
  // Simulates local storage
  static String? _authToken;
  static String? _userId;
  static UserModel? _currentUser;
  static bool _isInitialized = false;
  static String? _currentStoreId;

  // Checks if the user is authenticated
  static bool get isAuthenticated => _authToken != null;

  // Gets the current token
  static String? get token => _authToken;

  // Gets the current user ID
  static String? get userId => _userId;

  // Gets the current user
  static UserModel? get currentUser => _currentUser;

  // Initializes authentication state from SharedPreferences
  static Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      // Split initialization into smaller parts
      final prefs = await SharedPreferences.getInstance();
      
      // Load token and userId first
      _authToken = prefs.getString(_tokenKey);
      _userId = prefs.getString(_userIdKey);
      
      // Small pause to not block the main thread
      await Future.delayed(const Duration(milliseconds: 10));
      
      // Load user data afterwards
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

  // Attempts to authenticate the user
  static Future<AuthResponse> login(AuthCredentials credentials) async {
    try {
      print('Intentando login con: ${credentials.email}');
      
      // Cargamos todo el archivo JSON
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Imprimimos la estructura para depuración
      print('Estructura del JSON: ${jsonData.keys}');
      
      // Buscamos primero en usuarios
      final List<dynamic> usersJson = jsonData['tables']['users'] as List<dynamic>;
      print('Usuarios encontrados: ${usersJson.length}');
      
      for (var userJson in usersJson) {
        if (userJson['email'] == credentials.email && 
            userJson['password'] == credentials.password) {
          
          // Usuario encontrado - imprimimos información detallada
          print('Usuario encontrado: ${userJson['name']}');
          print('Tokens: ${userJson['tokens']}');
          print('Datos de cupones: ${userJson['coupons']}');
          print('Recompensas: ${userJson['rewards_history']}');
          
          // Usuario encontrado
          final user = UserModel.fromJson(userJson);
          
          // Verificamos que el modelo se haya creado correctamente
          print('Usuario modelo creado:');
          print('Nombre: ${user.name}');
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
          await prefs.setString('user_type', 'user');

          return AuthResponse.success(
            token: token,
            userId: user.id,
          );
        }
      }
      
      // Si no encontramos en usuarios, buscamos en tiendas
      final List<dynamic> storesJson = jsonData['tables']['stores'] as List<dynamic>;
      for (var storeJson in storesJson) {
        if (storeJson['email'] == credentials.email && 
            storeJson['password'] == credentials.password) {
          
          // Tienda encontrada
          final String token = base64Encode(utf8.encode('${storeJson['id']}:${DateTime.now().millisecondsSinceEpoch}'));
          
          // Guardar datos en memoria
          _authToken = token;
          _userId = storeJson['id'];
          _currentUser = null;  // Podríamos usar un modelo de tienda si lo necesitamos

          // Guardar en SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, token);
          await prefs.setString(_userIdKey, storeJson['id']);
          await prefs.setString('store_data', json.encode(storeJson));
          await prefs.setString('user_type', 'store');

          return AuthResponse.success(
            token: token,
            userId: storeJson['id'],
          );
        }
      }
      
      // Si llegamos aquí, no encontramos credenciales válidas
      return AuthResponse.error('Credenciales inválidas');
    } catch (e) {
      print('Error en login: $e');
      return AuthResponse.error(e.toString());
    }
  }

  // Logs out the user
  static Future<void> logout() async {
    print("Logging out and clearing all data");
    
    // Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userDataKey);
    await prefs.remove(_storeDataKey);
    
    // Clear memory variables
    _authToken = null;
    _userId = null;
    _currentUser = null;
    _currentStoreId = null;
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

  // Alternative method to update user data
  static Future<void> refreshUserData() async {
    if (!isAuthenticated || _userId == null || _currentUser == null) return;
    
    try {
      // Simply verify that the current user has valid data
      if (_currentUser != null && _currentUser!.id == _userId) {
        // User data is already loaded, nothing more needs to be done
        return;
      }
      
      // If we reach this point, something is wrong with the user data
      // We try to load the data from SharedPreferences
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
} 