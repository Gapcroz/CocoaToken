import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';
import '../models/store_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Keep the keys static and final
  static const String _tokenKey = 'auth_token';
  static const String _userTypeKey = 'user_type';
  static const String _userDataKey = 'user_data';
  static const String _storeDataKey = 'store_data';
  static const String _userIdKey = 'user_id';
  static const String _baseUrl =
      'http://192.168.0.6:3000/api'; // Updated to use localhost

  // Session variables
  static String? _authToken;
  static String? _userId;
  static UserModel? _currentUser;
  static bool _isInitialized = false;
  static SharedPreferences? _prefs;

  static final List<Function> _authStateListeners = [];

  // Getters remain the same
  static bool get isAuthenticated => _authToken != null;
  static String? get token => _authToken;
  static String? get userId => _userId;
  static UserModel? get currentUser => _currentUser;

  static void addAuthStateListener(Function listener) {
    if (!_authStateListeners.contains(listener)) {
      _authStateListeners.add(listener);
    }
  }

  static void removeAuthStateListener(Function listener) {
    _authStateListeners.remove(listener);
  }

  static void _notifyListeners() {
    for (var listener in List<Function>.from(_authStateListeners)) {
      listener();
    }
  }

  static Future<void> checkAuthState() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();

      _authToken = _prefs!.getString(_tokenKey);
      _userId = _prefs!.getString(_userIdKey);

      final userType = _prefs!.getString(_userTypeKey);
      final userData =
          userType == 'store'
              ? _prefs!.getString(_storeDataKey)
              : _prefs!.getString(_userDataKey);

      if (userData != null) {
        final data = json.decode(userData);
        _currentUser = UserModel.fromJson({
          ...data,
          'isStore': userType == 'store',
        });
        debugPrint(
          'Usuario cargado: ${_currentUser?.name} (${_currentUser?.isStore == true ? 'Tienda' : 'Usuario'})',
        );
      }
    } catch (e) {
      debugPrint('Error en checkAuthState: $e');
      await logout();
    }
  }

  static Future<void> init() async {
    if (_isInitialized) return;
    await checkAuthState();
    _isInitialized = true;
  }

  static Future<AuthResponse> register(AuthCredentials credentials) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': credentials.name,
          'address': credentials.address,
          'birthDate': credentials.birthDate,
          'email': credentials.email,
          'password': credentials.password,
          'isStore': credentials.isStore,
        }),
      );

      final responseBody = json.decode(response.body);
      debugPrint('Respuesta del servidor: $responseBody');

      if (response.statusCode == 201) {
        final data = responseBody;
        _currentUser = UserModel.fromJson({
          'id': data['id'],
          'name': data['name'],
          'email': data['email'],
          'address': data['address'],
          'birthDate': data['birthDate'],
          'isStore': data['isStore'],
        });

        debugPrint(
          'Usuario registrado: ${_currentUser?.name} (${_currentUser?.isStore == true ? 'Tienda' : 'Usuario'})',
        );
        return AuthResponse.success(
          token: 'registered',
          userId: data['id'].toString(),
        );
      } else {
        final errorMessage = responseBody['message'] ?? 'Error en el registro';
        debugPrint(
          'Error en registro: $errorMessage (Status: ${response.statusCode})',
        );
        return AuthResponse.error(errorMessage);
      }
    } catch (e) {
      debugPrint('Error en register: $e');
      return AuthResponse.error('Error al conectar con el servidor: $e');
    }
  }

  static Future<AuthResponse> login(AuthCredentials credentials) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': credentials.email,
          'password': credentials.password,
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        final userId = data['userId'].toString();
        final user = data['user'];
        if (user == null) {
          return AuthResponse.error('Datos de usuario no encontrados');
        }
        final isStore = user['isStore'] ?? false;
        debugPrint('Datos del usuario recibidos del servidor: $user');
        debugPrint('isStore del servidor: $isStore');
        debugPrint('Tipo de isStore: ${isStore.runtimeType}');

        _prefs ??= await SharedPreferences.getInstance();

        final userToSave = {...user, 'isStore': isStore};
        debugPrint('Datos a guardar en SharedPreferences: $userToSave');

        await _prefs!.setString(_tokenKey, token);
        await _prefs!.setString(_userIdKey, userId);
        await _prefs!.setString(_userTypeKey, isStore ? 'store' : 'user');
        await _prefs!.setString(
          isStore ? _storeDataKey : _userDataKey,
          json.encode(userToSave),
        );
        _currentUser = UserModel.fromJson({...user, 'isStore': isStore});
        debugPrint('Usuario creado: ${_currentUser?.toJson()}');
        debugPrint('isStore del usuario creado: ${_currentUser?.isStore}');
        _authToken = token;
        _userId = userId;

        return AuthResponse.success(token: token, userId: userId);
      } else {
        final error =
            json.decode(response.body)['message'] ?? 'Error al iniciar sesión';
        return AuthResponse.error(error);
      }
    } catch (e) {
      return AuthResponse.error('Error al conectar con el servidor: $e');
    }
  }

  static Future<void> logout() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();

      await Future.wait([
        _prefs!.remove(_tokenKey),
        _prefs!.remove(_userIdKey),
        _prefs!.remove(_userTypeKey),
        _prefs!.remove(_userDataKey),
        _prefs!.remove(_storeDataKey),
      ]);

      _authToken = null;
      _userId = null;
      _currentUser = null;
      _isInitialized = false;

      _notifyListeners();
    } catch (e) {
      // Logout error does not need to be propagated
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

  // The remaining methods stay the same but using cached _prefs
  static Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      final userType = _prefs!.getString(_userTypeKey);

      if (userType == 'store') {
        final storeData = _prefs!.getString(_storeDataKey);
        return storeData != null ? json.decode(storeData) : null;
      } else {
        final userData = _prefs!.getString(_userDataKey);
        return userData != null ? json.decode(userData) : null;
      }
    } catch (e) {
      return null;
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

  Future<bool> loadUser() async {
    _prefs ??= await SharedPreferences.getInstance();
    final token = _prefs!.getString(_tokenKey);
    final userId = _prefs!.getString(_userIdKey);
    final userType = _prefs!.getString(_userTypeKey);
    debugPrint('Token encontrado: ${token != null}');
    debugPrint('UserId encontrado: ${userId != null}');
    debugPrint('UserType encontrado: $userType');

    if (token != null && userId != null) {
      _authToken = token;
      _userId = userId;

      final isStore = userType == 'store';
      final userDataKey = isStore ? _storeDataKey : _userDataKey;
      final userDataString = _prefs!.getString(userDataKey);
      debugPrint('Datos del usuario encontrados: $userDataString');

      if (userDataString != null) {
        try {
          final userData = json.decode(userDataString);
          debugPrint('Datos del usuario decodificados: $userData');
          _currentUser = UserModel.fromJson(userData);
          debugPrint('Usuario cargado: ${_currentUser?.toJson()}');
          debugPrint('isStore del usuario cargado: ${_currentUser?.isStore}');
          return true;
        } catch (e) {
          debugPrint('Error al decodificar datos del usuario: $e');
          return false;
        }
      }
    }
    return false;
  }
}
