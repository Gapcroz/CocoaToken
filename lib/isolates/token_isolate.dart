import 'package:flutter/foundation.dart';

class TokenIsolate {
  static Future<Map<String, dynamic>> processUserData(
    Map<String, dynamic> data,
  ) async {
    return await compute(_processData, data);
  }

  static Map<String, dynamic> _processData(Map<String, dynamic> data) {
    try {
      final List<dynamic> users = data['users'] as List<dynamic>;
      final String userId = data['userId'];

      final userMatch = users.firstWhere(
        (user) => user['id'] == userId,
        orElse: () => null,
      );

      if (userMatch != null) {
        return {
          'tokens': userMatch['tokens'] as int,
          'rewards_history': userMatch['rewards_history'] ?? [],
          'name': userMatch['name'],
          'found': true,
        };
      }
      return {'found': false};
    } catch (e) {
      return {'error': e.toString(), 'found': false};
    }
  }
}
