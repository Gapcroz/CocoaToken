import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/user_model.dart';

class UserService {
  static Future<List<UserModel>> getAllUsers() async {
    try {
      // Load and parse JSON data from assets
      final String jsonString = await rootBundle.loadString(
        'assets/data/user_data.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<dynamic> usersJson = jsonData['users'] as List<dynamic>;

      debugPrint('Usuarios encontrados: ${usersJson.length}');

      return usersJson.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error cargando usuarios: $e');
      return [];
    }
  }

  static Future<UserModel?> authenticateUser(
    String email,
    String password,
  ) async {
    try {
      // Load user data and check credentials
      final String jsonString = await rootBundle.loadString(
        'assets/data/user_data.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Access users table from data structure
      final List<dynamic> usersJson =
          jsonData['tables']['users'] as List<dynamic>;

      for (var userJson in usersJson) {
        if (userJson['email'] == email && userJson['password'] == password) {
          return UserModel.fromJson(userJson);
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error autenticando usuario: $e');
      return null;
    }
  }

  static Future<UserModel?> getUserById(String userId) async {
    try {
      // Fetch user data by ID from JSON
      final String jsonString = await rootBundle.loadString(
        'assets/data/user_data.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Get users list from tables structure
      final List<dynamic> usersJson =
          jsonData['tables']['users'] as List<dynamic>;

      for (var userJson in usersJson) {
        if (userJson['id'] == userId) {
          return UserModel.fromJson(userJson);
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error obteniendo usuario por ID: $e');
      return null;
    }
  }
}
