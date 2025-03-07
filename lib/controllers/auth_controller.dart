import 'package:flutter/material.dart';
import '../models/auth_model.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credentials = AuthCredentials(
        email: email,
        password: password,
      );

      final response = await AuthService.login(credentials);

      _isAuthenticated = response.success;
      _error = response.error;
      
      if (!response.success && response.error != null) {
        _error = response.error;
      }
    } catch (e) {
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