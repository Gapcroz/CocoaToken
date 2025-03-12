import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user_model.dart';

class UserService {
  static Future<List<UserModel>> getAllUsers() async {
    try {
      // Cargar datos de usuario desde el archivo JSON
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      final List<dynamic> usersJson = jsonData['users'] as List<dynamic>;
      
      // Imprimir para depuración
      print('Usuarios encontrados: ${usersJson.length}');
      
      return usersJson.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      print('Error cargando usuarios: $e');
      return [];
    }
  }

  static Future<UserModel?> authenticateUser(String email, String password) async {
    try {
      // Imprimir para depuración
      print('Intentando autenticar: $email');
      
      // Cargar el JSON directamente
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> usersJson = jsonData['users'] as List<dynamic>;
      
      // Buscar usuario por email y contraseña
      for (var userJson in usersJson) {
        if (userJson['email'] == email && userJson['password'] == password) {
          print('Usuario encontrado: ${userJson['name']}');
          print('Tokens: ${userJson['tokens']}');
          print('Cupones: ${(userJson['coupons'] as List).length}');
          print('Recompensas: ${(userJson['rewards_history'] as List).length}');
          
          // Crear el modelo de usuario con todos los datos
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
      
      // Buscar usuario por ID
      for (var user in users) {
        if (user.id == userId) {
          return user;
        }
      }
      
      return null; // No se encontró el usuario
    } catch (e) {
      print('Error obteniendo usuario por ID: $e');
      return null;
    }
  }
} 