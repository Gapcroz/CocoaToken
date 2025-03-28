import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AuthIsolate {
  static Future<Map<String, dynamic>> validateCredentials(
    Map<String, dynamic> data,
  ) async {
    return await compute(_validateCredentialsInBackground, data);
  }

  static Map<String, dynamic> _validateCredentialsInBackground(
    Map<String, dynamic> data,
  ) {
    BackgroundIsolateBinaryMessenger.ensureInitialized(
      data['rootIsolateToken'] as RootIsolateToken,
    );
    try {
      final List<dynamic> usersJson = data['users'] as List<dynamic>;
      final List<dynamic> storesJson = data['stores'] as List<dynamic>;
      final String email = data['email'];
      final String password = data['password'];

      // Primero buscar en usuarios
      for (var userJson in usersJson) {
        if (userJson['email']?.toString().toLowerCase() ==
                email.toLowerCase() &&
            userJson['password']?.toString() == password) {
          return {
            'found': true,
            'isStore': false,
            'data': userJson,
            'role': 'user',
          };
        }
      }

      // Luego buscar en tiendas
      for (var storeJson in storesJson) {
        if (storeJson['email'].toString().toLowerCase() ==
                email.toLowerCase() &&
            storeJson['password'] == password) {
          return {
            'found': true,
            'isStore': true,
            'data': storeJson,
            'role': 'store',
          };
        }
      }

      return {'found': false, 'error': 'Credenciales inválidas'};
    } catch (e) {
      return {'found': false, 'error': e.toString()};
    }
  }
}
