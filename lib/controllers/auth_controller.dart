import 'package:flutter/material.dart';
import '../models/auth_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'coupon_controller.dart';
import 'token_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  bool _isCheckingAuth = false;
  String _userType = 'user';  // Por defecto es usuario regular
  bool? _isStore;
  String? _name;
  String? _image;
  Map<String, dynamic>? _userData;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  String get userType => _userType;
  bool? get isStore => _isStore;
  String? get name => _name;
  String? get image => _image;

  Future<void> init() async {
    print('Iniciando AuthController...');
    await checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.init();
      _isAuthenticated = AuthService.isAuthenticated;
      
      if (_isAuthenticated) {
        // Load user/store data from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final userType = prefs.getString('user_type');
        final userData = userType == 'store' 
            ? prefs.getString('store_data')
            : prefs.getString('user_data');

        if (userData != null) {
          final data = json.decode(userData);
          _userType = userType ?? 'user';
          _isStore = _userType == 'store';
          _name = data['name'];
          _image = data['image'];
          print('Session recovered for: $_name (${_isStore == true ? 'Store' : 'User'})');
        } else {
          _isAuthenticated = false;
        }
      }
    } catch (e) {
      print('Error checking auth status: $e');
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await AuthService.login(AuthCredentials(
        email: email,
        password: password,
      ));

      _isAuthenticated = response.success;
      
      if (_isAuthenticated) {
        await checkAuthStatus(); // Esto cargará los datos guardados
      } else {
        _error = response.error;
      }
    } catch (e) {
      print('Error en login: $e');
      _error = 'Error inesperado: $e';
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _isAuthenticated;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.logout();
      _isAuthenticated = false;
      _error = null;
      _isStore = null;
      _name = null;
      _image = null;
      _userData = null;
    } catch (e) {
      _error = 'Error al cerrar sesión: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 