import 'package:flutter/material.dart';
import '../models/auth_model.dart';
import '../services/auth_service.dart';

// Controller to handle user registration logic
class RegisterController extends ChangeNotifier {
  // Internal controller state
  bool _isLoading = false; // Indicates if an operation is in progress
  String? _error; // Stores error message if any occurs

  // Getters to access state from outside the class
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Main method to register a new user
  Future<bool> register({
    required String name,
    required String address,
    required String birthdate,
    required bool isStore,
    required String email,
    required String password,
  }) async {
    try {
      // Start registration process
      _isLoading = true;
      _error = null;
      notifyListeners();

      debugPrint('Iniciando registro para: $email');

      final credentials = AuthCredentials.register(
        name: name,
        address: address,
        birthDate: birthdate,
        email: email,
        password: password,
        isStore: isStore,
      );

      final response = await AuthService.register(credentials);
      debugPrint(
        'Respuesta del registro: ${response.success} - ${response.error}',
      );

      if (response.success) {
        debugPrint('✅ Registro exitoso para: $email');
        _isLoading = false;
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response.error ?? 'Error desconocido al registrar';
        debugPrint('❌ Error en registro: $_error');
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error: $e';
      debugPrint('❌ Error en registro: $_error');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
