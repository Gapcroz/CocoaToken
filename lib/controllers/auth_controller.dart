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
    if (_isCheckingAuth) return; // Evitar múltiples verificaciones simultáneas
    
    _isCheckingAuth = true;
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.init();
      _isAuthenticated = AuthService.isAuthenticated;
      
      if (_isAuthenticated) {
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
          _userData = data;
          print('Sesión recuperada para: $_name (${_isStore == true ? 'Tienda' : 'Usuario'})');
        } else {
          _isAuthenticated = false;
          await AuthService.logout(); // Limpiar datos inconsistentes
        }
      }
    } catch (e) {
      print('Error verificando estado de autenticación: $e');
      _isAuthenticated = false;
      await AuthService.logout();
    } finally {
      _isCheckingAuth = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await AuthService.login(AuthCredentials(
        email: email,
        password: password,
      ));
      
      if (response.success) {
        await checkAuthStatus(); // Esto cargará todos los datos del usuario
        
        if (!_isAuthenticated) {
          setState(() {
            _error = 'Error al cargar datos de usuario';
            _isLoading = false;
          });
          return false;
        }
        
        setState(() {
          _isLoading = false;
        });
        return true;
      }

      setState(() {
        _error = response.error ?? 'Credenciales inválidas';
        _isLoading = false;
      });
      return false;
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      return false;
    }
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

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
} 