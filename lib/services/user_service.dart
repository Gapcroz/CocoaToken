import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user_model.dart';

class UserService {
  static Future<List<UserModel>> getAllUsers() async {
    try {
      // Load user data from JSON file
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      final List<dynamic> usersJson = jsonData['users'] as List<dynamic>;
      
      // Print for debugging
      print('Usuarios encontrados: ${usersJson.length}');
      
      return usersJson.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      print('Error cargando usuarios: $e');
      return [];
    }
  }

  static Future<UserModel?> authenticateUser(String email, String password) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Actualizado para acceder a la estructura de tablas
      final List<dynamic> usersJson = jsonData['tables']['users'] as List<dynamic>;
      
      for (var userJson in usersJson) {
        if (userJson['email'] == email && userJson['password'] == password) {
          return UserModel.fromJson(userJson);
        }
      }
      
      return null;
    } catch (e) {
      print('Error autenticando usuario: $e');
      return null;
    }
  }

  static Future<UserModel?> getUserById(String userId) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Actualizado para la nueva estructura
      final List<dynamic> usersJson = jsonData['tables']['users'] as List<dynamic>;
      
      for (var userJson in usersJson) {
        if (userJson['id'] == userId) {
          return UserModel.fromJson(userJson);
        }
      }
      
      return null;
    } catch (e) {
      print('Error obteniendo usuario por ID: $e');
      return null;
    }
  }
} 