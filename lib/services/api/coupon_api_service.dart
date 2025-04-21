import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import '../../models/coupon_model.dart';
import '../../services/auth_service.dart';

class CouponApiService {
  // Get coupons for store users
  static Future<List<CouponModel>> getStoreCoupons() async {
    debugPrint('Iniciando petición GET a /store');
    final token = AuthService.token;
    debugPrint('Token: ${token != null ? 'Presente' : 'Ausente'}');

    if (token == null) {
      debugPrint('No hay token de autenticación');
      throw Exception('No autenticado');
    }

    final headers = await ApiConfig.getHeaders(token);
    debugPrint('Headers: $headers');

    final url = '${ApiConfig.couponsEndpoint}/store';
    debugPrint('URL: $url');

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      debugPrint('Código de respuesta: ${response.statusCode}');
      debugPrint('Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        debugPrint('Datos decodificados: $data');
        for (var coupon in data) {
          debugPrint(
            'Cupón ${coupon['id']} - tokensRequired: ${coupon['tokensRequired']}',
          );
        }
        return data.map((json) => CouponModel.fromJson(json)).toList();
      } else {
        debugPrint('Error en la respuesta: ${response.statusCode}');
        throw Exception('Error al cargar los cupones: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error en la petición: $e');
      rethrow;
    }
  }

  // Get coupons for regular users
  static Future<List<CouponModel>> getUserCoupons() async {
    try {
      final token = AuthService.token;
      if (token == null) throw Exception('No hay token de autenticación');

      final headers = await ApiConfig.getHeaders(token);
      debugPrint('Obteniendo cupones del usuario...');
      debugPrint('URL: ${ApiConfig.couponsEndpoint}/user');
      debugPrint('Headers: $headers');

      final response = await http.get(
        Uri.parse('${ApiConfig.couponsEndpoint}/user'),
        headers: headers,
      );

      debugPrint('Código de respuesta: ${response.statusCode}');
      debugPrint('Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        debugPrint('Cupones obtenidos: ${jsonData.length}');
        return jsonData.map((json) => CouponModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado');
      } else {
        throw Exception('Error al obtener los cupones: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error en getUserCoupons: $e');
      rethrow;
    }
  }

  // Create a new coupon
  static Future<CouponModel> createCoupon(
    Map<String, dynamic> couponData,
  ) async {
    final token = AuthService.token;
    if (token == null) {
      throw Exception('No autenticado');
    }

    final headers = await ApiConfig.getHeaders(token);
    final response = await http.post(
      Uri.parse(ApiConfig.couponsEndpoint),
      headers: headers,
      body: json.encode(couponData),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return CouponModel.fromJson(data);
    } else {
      throw Exception('Error al crear el cupón: ${response.statusCode}');
    }
  }

  // Update an existing coupon
  static Future<CouponModel> updateCoupon(CouponModel coupon) async {
    final token = AuthService.token;
    if (token == null) {
      throw Exception('No autenticado');
    }

    final userId = AuthService.userId;
    if (userId == null) {
      throw Exception('No autenticado');
    }

    final headers = await ApiConfig.getHeaders(token);
    final couponData = {...coupon.toJson(), 'storeId': userId};
    debugPrint('Enviando datos de actualización: $couponData');

    final response = await http.put(
      Uri.parse('${ApiConfig.couponsEndpoint}/${coupon.id}'),
      headers: headers,
      body: json.encode(couponData),
    );

    debugPrint('Respuesta de actualización: ${response.statusCode}');
    debugPrint('Cuerpo de la respuesta: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      debugPrint('Datos decodificados de la respuesta: $data');
      return CouponModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Cupón no encontrado');
    } else if (response.statusCode == 403) {
      throw Exception('No tienes permiso para actualizar este cupón');
    } else {
      throw Exception('Error al actualizar el cupón');
    }
  }

  // Delete a coupon
  static Future<void> deleteCoupon(String couponId) async {
    final token = AuthService.token;
    if (token == null) {
      throw Exception('No autenticado');
    }

    final headers = await ApiConfig.getHeaders(token);
    final response = await http.delete(
      Uri.parse('${ApiConfig.couponsEndpoint}/$couponId'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el cupón: ${response.statusCode}');
    }
  }
}
