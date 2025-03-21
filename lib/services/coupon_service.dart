import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/coupon_model.dart';

class CouponService {
  static Future<List<CouponModel>> loadCoupons() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      final List<dynamic> usersJson = jsonData['tables']['users'] as List<dynamic>;
      
      if (usersJson.isNotEmpty) {
        final userJson = usersJson[0];
        final List<dynamic> coupons = userJson['coupons'] as List<dynamic>;
        
        return coupons.map((json) => CouponModel.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('Error loading coupons: $e');
      print('Estructura del JSON: ${jsonString}');
      return [];
    }
  }
} 