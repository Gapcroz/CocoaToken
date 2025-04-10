import '../models/coupon_model.dart';
import '../services/auth_service.dart';
import 'api/coupon_api_service.dart';
import 'package:flutter/foundation.dart';

class CouponService {
  // Check if the current user is a store
  static Future<bool> get _isStore async {
    final user = AuthService.currentUser;
    if (user == null) {
      debugPrint('No hay usuario autenticado');
      return false;
    }
    final isStore = user.isStore;
    debugPrint('Verificando isStore en CouponService: $isStore');
    return isStore;
  }

  // Load coupons for store users
  static Future<List<CouponModel>> loadCoupons() async {
    debugPrint('Iniciando carga de cupones...');
    final isStore = await _isStore;
    debugPrint('¿Es tienda?: $isStore');

    if (!isStore) {
      debugPrint('No es tienda, retornando lista vacía');
      return [];
    }

    final userId = AuthService.userId;
    debugPrint('ID del usuario: $userId');

    if (userId == null) {
      debugPrint('No hay ID de usuario, no autenticado');
      throw Exception('No autenticado');
    }

    debugPrint('Obteniendo cupones de la API...');
    try {
      final coupons = await CouponApiService.getStoreCoupons();
      debugPrint('Cupones obtenidos: ${coupons.length}');
      return coupons;
    } catch (e) {
      debugPrint('Error al obtener cupones: $e');
      rethrow;
    }
  }

  // Create a new coupon
  static Future<CouponModel> createCoupon(CouponModel coupon) async {
    if (!(await _isStore)) {
      throw Exception('Solo las tiendas pueden crear cupones');
    }

    final userId = AuthService.userId;
    if (userId == null) {
      throw Exception('No autenticado');
    }

    final couponData = coupon.toJson();
    couponData['storeId'] = userId;
    debugPrint('Creando cupón con storeId: $userId');

    return await CouponApiService.createCoupon(couponData);
  }

  // Update an existing coupon
  static Future<CouponModel> updateCoupon(CouponModel coupon) async {
    if (!(await _isStore)) {
      throw Exception('Solo las tiendas pueden actualizar cupones');
    }

    final userId = AuthService.userId;
    if (userId == null) {
      throw Exception('No autenticado');
    }

    final couponData = coupon.toJson();
    couponData['storeId'] = userId;
    debugPrint('Actualizando cupón con storeId: $userId');

    return await CouponApiService.updateCoupon(coupon);
  }

  // Delete a coupon
  static Future<void> deleteCoupon(String couponId) async {
    if (!(await _isStore)) {
      throw Exception('Solo las tiendas pueden eliminar cupones');
    }

    final userId = AuthService.userId;
    if (userId == null) {
      throw Exception('No autenticado');
    }

    await CouponApiService.deleteCoupon(couponId);
  }

  // Load coupons for regular users
  static Future<List<CouponModel>> loadUserCoupons() async {
    try {
      final coupons = await CouponApiService.getUserCoupons();
      return coupons;
    } catch (e) {
      debugPrint('Error al cargar cupones del usuario: $e');
      rethrow;
    }
  }
}
