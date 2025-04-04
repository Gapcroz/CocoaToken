import 'package:flutter/material.dart';

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

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Real API implementation will go here when available
      // For now, we only validate email format
      if (!email.contains('@')) {
        throw Exception('Formato de email inválido');
      }

      // Simulate successful registration
      debugPrint('Usuario registrado: $name, $email');

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
