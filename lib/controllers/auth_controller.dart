import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../models/auth_model.dart';
import '../services/auth_service.dart';
import 'dart:async';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  bool _isCheckingAuth = false;
  String _userType = 'user'; // Default is regular user
  bool? _isStore;
  String? _name;
  String? _image;
  bool _justLoggedOut = false;
  bool _isInitialized = false;
  SharedPreferences? _prefs;
  Timer? _errorTimer;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  String get userType => _userType;
  bool? get isStore => _isStore;
  String? get name => _name;
  String? get image => _image;
  bool get justLoggedOut => _justLoggedOut;

  Future<void> _initializeAsync() async {
    if (_isInitialized) return;

    try {
      final token = RootIsolateToken.instance;
      if (token == null) return;

      // Initialize SharedPreferences only once
      _prefs ??= await SharedPreferences.getInstance();

      await compute<RootIsolateToken, void>((token) async {
        BackgroundIsolateBinaryMessenger.ensureInitialized(token);
        await AuthService.init();
      }, token);

      await checkAuthStatus();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error en inicialización: $e');
    }
  }

  Future<void> checkAuthStatus() async {
    if (_isCheckingAuth) return;
    _isCheckingAuth = true;

    bool shouldNotify = false;
    try {
      _isLoading = true;
      shouldNotify = true;
      notifyListeners();

      _isAuthenticated = AuthService.isAuthenticated;
      if (_isAuthenticated) {
        _prefs ??= await SharedPreferences.getInstance();
        final userType = _prefs!.getString('user_type');
        final userData =
            userType == 'store'
                ? _prefs!.getString('store_data')
                : _prefs!.getString('user_data');

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
          await _handleLogout();
        }
      }
    } catch (e) {
      _isAuthenticated = false;
      await _handleLogout();
    } finally {
      _isCheckingAuth = false;
      _isLoading = false;
      if (shouldNotify) notifyListeners();
    }
  }

  void _setError(String? error) {
    _errorTimer?.cancel();
    _error = error;
    if (error != null) {
      _errorTimer = Timer(const Duration(seconds: 3), () {
        _error = null;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  Future<bool> login(String? email, String? password) async {
    if (!_isInitialized) {
      await _initializeAsync();
    }

    if (email == null ||
        email.isEmpty ||
        password == null ||
        password.isEmpty) {
      _setError('El correo y la contraseña son requeridos');
      return false;
    }

    if (_isLoading) return false;

    try {
      _isLoading = true;
      notifyListeners();

      final response = await AuthService.login(
        AuthCredentials(email: email, password: password),
      );

      if (response.success &&
          response.token != null &&
          response.userId != null) {
        await checkAuthStatus();
        if (!_isAuthenticated) {
          _setError('Error al cargar datos de usuario');
          return false;
        }
        return true;
      }

      _setError(response.error ?? 'Credenciales inválidas');
      _isAuthenticated = false;
      return false;
    } catch (e) {
      _setError(e.toString());
      _isAuthenticated = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _handleLogout();
    _justLoggedOut = true;
    notifyListeners();
  }

  Future<void> _handleLogout() async {
    try {
      await AuthService.logout();
      _isStore = null;
      _name = null;
      _image = null;
      _isAuthenticated = false;
    } catch (e) {
      _setError('Error in logout: $e');
      debugPrint(_error!);
    }
  }

  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  void resetLogoutFlag() {
    if (_justLoggedOut) {
      _justLoggedOut = false;
    }
  }

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Perform heavy initializations here
      await Future.delayed(Duration.zero); // Allow UI to render
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing AuthController: $e');
    }
  }
}
