import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/coupon_model.dart';

class CouponService {
  static Future<List<CouponModel>> loadCoupons() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      final List<dynamic> rewardsJson = jsonData['user']['rewards'] as List<dynamic>;
      
      return rewardsJson.map((json) => CouponModel.fromJson(json)).toList();
    } catch (e) {
      print('Error loading coupons: $e');
      return [];
    }
  }
} 