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
      // Print for debugging
      print('Intentando autenticar: $email');
      
      // Load JSON directly
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> usersJson = jsonData['users'] as List<dynamic>;
      
      // Search user by email and password
      for (var userJson in usersJson) {
        if (userJson['email'] == email && userJson['password'] == password) {
          print('Usuario encontrado: ${userJson['name']}');
          print('Tokens: ${userJson['tokens']}');
          print('Cupones: ${(userJson['coupons'] as List).length}');
          print('Recompensas: ${(userJson['rewards_history'] as List).length}');
          
          // Create user model with all data
          return UserModel.fromJson(userJson);
        }
      }
      
      print('Usuario no encontrado o contraseña incorrecta');
      return null;
    } catch (e) {
      print('Error autenticando usuario: $e');
      return null;
    }
  }

  static Future<UserModel?> getUserById(String userId) async {
    try {
      final users = await getAllUsers();
      
      // Search user by ID
      for (var user in users) {
        if (user.id == userId) {
          return user;
        }
      }
      
      return null; // User not found
    } catch (e) {
      print('Error obteniendo usuario por ID: $e');
      return null;
    }
  }
} 