import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user_model.dart';

class UserService {
  static Future<UserModel> loadUserData() async {
    try {
      // Carga el archivo JSON
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Convierte el JSON a un modelo de usuario
      return UserModel.fromJson(jsonData['user']);
    } catch (e) {
      throw Exception('Error al cargar los datos del usuario: $e');
    }
  }
} 