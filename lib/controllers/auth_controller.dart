import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  bool _isCheckingAuth = false;
  String _userType = 'user'; // Por defecto es usuario regular
  bool? _isStore;
  String? _name;
  String? _image;
  bool _justLoggedOut = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  String get userType => _userType;
  bool? get isStore => _isStore;
  String? get name => _name;
  String? get image => _image;
  bool get justLoggedOut => _justLoggedOut;

  Future<void> init() async {
    debugPrint('Iniciando AuthController...');
    await checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    if (_isCheckingAuth) return;

    _isCheckingAuth = true;
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.init();
      _isAuthenticated = AuthService.isAuthenticated;

      if (_isAuthenticated) {
        final prefs = await SharedPreferences.getInstance();
        final userType = prefs.getString('user_type');
        final userData =
            userType == 'store'
                ? prefs.getString('store_data')
                : prefs.getString('user_data');

        if (userData != null) {
          final data = json.decode(userData);
          _userType = userType ?? 'user';
          _isStore = _userType == 'store';
          _name = data['name'];
          _image = data['image'];
          debugPrint(
            'Sesión recuperada para: $_name (${_isStore == true ? 'Tienda' : 'Usuario'})',
          );
        } else {
          _isAuthenticated = false;
          await AuthService.logout();
        }
      }
    } catch (e) {
      debugPrint('Error verificando estado de autenticación: $e');
      _isAuthenticated = false;
      await AuthService.logout();
    } finally {
      _isCheckingAuth = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String? email, String? password) async {
    if (email == null ||
        email.isEmpty ||
        password == null ||
        password.isEmpty) {
      _error = 'El correo y la contraseña son requeridos';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await AuthService.login(
        AuthCredentials(email: email, password: password),
      );

      if (response.success &&
          response.token != null &&
          response.userId != null) {
        await checkAuthStatus();

        if (!_isAuthenticated) {
          _error = 'Error al cargar datos de usuario';
          _isLoading = false;
          notifyListeners();
          return false;
        }

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _error = response.error ?? 'Credenciales inválidas';
      _isLoading = false;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _justLoggedOut = true;
    notifyListeners();

    try {
      await AuthService.logout();
      _isStore = null;
      _name = null;
      _image = null;
    } catch (e) {
      _error = 'Error al cerrar sesión: $e';
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  void resetLogoutFlag() {
    _justLoggedOut = false;
  }
}
