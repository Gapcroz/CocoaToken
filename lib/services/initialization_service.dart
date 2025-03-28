import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitializationService {
  static Future<void> initialize() async {
    try {
      await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('Error en inicialización: $e');
    }
  }
}
