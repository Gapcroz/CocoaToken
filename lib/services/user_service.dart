import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user_model.dart';

class UserService {
  static Future<UserModel> loadUserData() async {
    try {
      // Load JSON file
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Convert JSON to user model
      return UserModel.fromJson(jsonData['user']);
    } catch (e) {
      throw Exception('Error al cargar los datos del usuario: $e');
    }
  }
} 