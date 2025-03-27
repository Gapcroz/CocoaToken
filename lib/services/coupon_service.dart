import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/coupon_model.dart';
import '../services/auth_service.dart';

class CouponService {
  static Future<List<CouponModel>> loadCoupons() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/user_data.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Verificar si es una tienda o un usuario
      final currentUserData = await AuthService.getCurrentUserData();
      final isStore = currentUserData?['role'] == 'store';

      if (isStore) {
        // Si es tienda, cargar los cupones creados por la tienda
        final List<dynamic> coupons =
            jsonData['tables']['coupons'] as List<dynamic>;
        return coupons
            .where((coupon) => coupon['store_id'] == currentUserData?['id'])
            .map((json) => CouponModel.fromJson(json))
            .toList();
      } else {
        // Si es usuario, cargar sus cupones disponibles
        final List<dynamic> usersJson =
            jsonData['tables']['users'] as List<dynamic>;
        final userJson = usersJson.firstWhere(
          (user) => user['id'] == currentUserData?['id'],
          orElse: () => null,
        );

        if (userJson != null && userJson['coupons'] != null) {
          final List<dynamic> coupons = userJson['coupons'] as List<dynamic>;
          return coupons.map((json) => CouponModel.fromJson(json)).toList();
        }
      }

      return [];
    } catch (e) {
      debugPrint('Error loading coupons: $e');
      return [];
    }
  }

  // Método para que las tiendas creen cupones
  static Future<bool> createCoupon(CouponModel coupon) async {
    try {
      final currentUserData = await AuthService.getCurrentUserData();
      if (currentUserData?['role'] != 'store') {
        throw Exception('Solo las tiendas pueden crear cupones');
      }

      // Aquí iría la lógica para guardar el cupón en el JSON
      // Por ahora solo simulamos éxito
      return true;
    } catch (e) {
      debugPrint('Error creating coupon: $e');
      return false;
    }
  }
}
