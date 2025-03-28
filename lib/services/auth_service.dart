import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';
import '../models/store_model.dart';
import '../isolates/auth_isolate.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  // Static storage keys for SharedPreferences
  static const String _tokenKey = 'auth_token';
  static const String _userTypeKey = 'user_type';
  static const String _userDataKey = 'user_data';
  static const String _storeDataKey = 'store_data';
  static const String _userIdKey = 'user_id';

  // Session management variables
  static String? _authToken;
  static String? _userId;
  static UserModel? _currentUser;
  static bool _isInitialized = false;

  static final List<Function> _authStateListeners = [];

  static void addAuthStateListener(Function listener) {
    _authStateListeners.add(listener);
  }

  static void removeAuthStateListener(Function listener) {
    _authStateListeners.remove(listener);
  }

  static void _notifyListeners() {
    for (var listener in _authStateListeners) {
      listener();
    }
  }

  // Authentication state getters
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
      final userData =
          userType == 'store'
              ? prefs.getString(_storeDataKey)
              : prefs.getString(_userDataKey);

      if (userData != null) {
        final data = json.decode(userData);
        if (userType == 'store') {
          debugPrint('Datos de tienda recuperados');
        } else {
          _currentUser = UserModel.fromJson(data);
          debugPrint('Datos de usuario recuperados');
        }
      }
    } catch (e) {
      debugPrint('Error verificando estado de autenticación: $e');
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
      debugPrint('Intentando login con: ${credentials.email}');

      final String jsonString = await rootBundle.loadString(
        'assets/data/user_data.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final validationResult = await AuthIsolate.validateCredentials({
        'users': jsonData['tables']['users'],
        'stores': jsonData['tables']['stores'],
        'email': credentials.email,
        'password': credentials.password,
        'rootIsolateToken': RootIsolateToken.instance!,
      });

      if (!validationResult['found']) {
        return AuthResponse.error(
          validationResult['error'] ?? 'Credenciales inválidas',
        );
      }

      final userData = validationResult['data'];
      final isStore = validationResult['isStore'];

      if (!isStore) {
        // Proceso de usuario normal
        try {
          final userModel = UserModel.fromJson(userData);
          final String token = base64Encode(
            utf8.encode(
              '${userModel.id}:${DateTime.now().millisecondsSinceEpoch}',
            ),
          );

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, token);
          await prefs.setString(_userIdKey, userModel.id);
          await prefs.setString(_userTypeKey, 'user');
          await prefs.setString(_userDataKey, json.encode(userData));

          _authToken = token;
          _userId = userModel.id;
          _currentUser = userModel;

          debugPrint('Login exitoso para usuario: ${userModel.name}');
          return AuthResponse.success(token: token, userId: userModel.id);
        } catch (e) {
          debugPrint('Error procesando datos de usuario: $e');
          return AuthResponse.error('Error procesando datos de usuario');
        }
      } else {
        // Proceso de tienda
        final String storeId = userData['id']?.toString() ?? '';
        final String token = base64Encode(
          utf8.encode('$storeId:${DateTime.now().millisecondsSinceEpoch}'),
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        await prefs.setString(_userIdKey, storeId);
        await prefs.setString(_userTypeKey, 'store');
        await prefs.setString(_storeDataKey, json.encode(userData));

        _authToken = token;
        _userId = storeId;

        debugPrint('Login exitoso para tienda: ${userData['name']}');
        return AuthResponse.success(token: token, userId: storeId);
      }
    } catch (e) {
      debugPrint('Error detallado en login: $e');
      return AuthResponse.error('Error en el proceso de login: $e');
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

      _authToken = null;
      _userId = null;
      _currentUser = null;
      _isInitialized = false;

      debugPrint('Session closed correctly');
      _notifyListeners();
    } catch (e) {
      debugPrint('Error in logout: $e');
    }
  }

  // Alternative method to update user data
  static Future<void> refreshUserData() async {
    if (_authToken == null || _userId == null || _currentUser == null) return;

    try {
      await checkAuthState();
    } catch (e) {
      debugPrint('Error updating data: $e');
    }
  }

  static Future<List<UserModel>> getAllUsers() async {
    try {
      // Load user data from JSON file
      final String jsonString = await rootBundle.loadString(
        'assets/data/user_data.json',
      );

      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Updated to access table structure
      final List<dynamic> usersJson =
          jsonData['tables']['users'] as List<dynamic>;
      debugPrint('Users found in JSON: ${usersJson.length}');

      return usersJson.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading users: $e');
      return [];
    }
  }

  // Method to get all stores
  static Future<List<dynamic>> getAllStores() async {
    try {
      // Load data from JSON file
      final String jsonString = await rootBundle.loadString(
        'assets/data/user_data.json',
      );

      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Access stores table
      final List<dynamic> storesJson =
          jsonData['tables']['stores'] as List<dynamic>;
      debugPrint('Stores found in JSON: ${storesJson.length}');

      return storesJson;
    } catch (e) {
      debugPrint('Error loading stores: $e');
      return [];
    }
  }

  // Method to authenticate stores
  static Future<StoreModel?> authenticateStore(
    String email,
    String password,
  ) async {
    try {
      final stores = await getAllStores();

      for (var store in stores) {
        if (store['email'] == email && store['password'] == password) {
          return StoreModel.fromJson(store);
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error authenticating store: $e');
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
      debugPrint('Error getting user data: $e');
      return null;
    }
  }
}
