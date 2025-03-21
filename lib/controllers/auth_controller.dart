import 'package:flutter/material.dart';
import '../models/auth_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'coupon_controller.dart';
import 'token_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  bool _isCheckingAuth = false;
  String _userType = 'user';  // Por defecto es usuario regular

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  String get userType => _userType;
  bool get isStore => _userType == 'store';

  Future<void> checkAuthStatus() async {
    if (_isCheckingAuth) return;
    
    _isCheckingAuth = true;
    _isLoading = true;
    
    // Notificar solo si es necesario
    if (hasListeners) notifyListeners();

    try {
      // No llamamos a init() aquí, ya se llama en main.dart
      _isAuthenticated = AuthService.isAuthenticated;
    } catch (e) {
      _error = 'Error al verificar autenticación: $e';
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      _isCheckingAuth = false;
      
      // Notificar solo si es necesario
      if (hasListeners) notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // First ensure we're logged out
      await AuthService.logout();
      
      final credentials = AuthCredentials(
        email: email,
        password: password,
      );

      final response = await AuthService.login(credentials);

      _isAuthenticated = response.success;
      
      if (_isAuthenticated) {
        // Verificar el tipo de usuario que autenticamos
        final prefs = await SharedPreferences.getInstance();
        _userType = prefs.getString('user_type') ?? 'user';
      }
      
      if (!response.success && response.error != null) {
        _error = response.error;
      }
    } catch (e) {
      _error = 'Unexpected error: $e';
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
      // Just call logout in AuthService
      await AuthService.logout();
      _isAuthenticated = false;
      _error = null;
    } catch (e) {
      _error = 'Error logging out: $e';
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