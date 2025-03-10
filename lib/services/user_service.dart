import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user_model.dart';

class UserService {
  static Future<List<UserModel>> loadAllUsers() async {
    try {
      // Cargar archivo JSON
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Convertir la lista de usuarios
      final List<dynamic> usersJson = jsonData['users'];
      return usersJson.map((user) => UserModel.fromJson(user)).toList();
    } catch (e) {
      throw Exception('Error al cargar los datos de usuarios: $e');
    }
  }

  static Future<UserModel> findUserByEmail(String email) async {
    try {
      final users = await loadAllUsers();
      return users.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
        orElse: () => throw Exception('Usuario no encontrado'),
      );
    } catch (e) {
      throw Exception('Error al buscar usuario: $e');
    }
  }

  static Future<UserModel> authenticateUser(String email, String password) async {
    try {
      final user = await findUserByEmail(email);
      if (user.password == password) {
        return user;
      }
      throw Exception('Contraseña incorrecta');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
} 