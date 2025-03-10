import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _error;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await AuthService.init();
      _isAuthenticated = AuthService.isAuthenticated;
    } catch (e) {
      _error = 'Error al verificar autenticación: $e';
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
} 