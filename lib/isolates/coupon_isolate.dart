import 'package:flutter/foundation.dart';
import '../models/coupon_model.dart';

class CouponIsolate {
  static Future<List<CouponModel>> processCoupons(List<dynamic> coupons) async {
    return await compute(_processCouponsInBackground, coupons);
  }

  static List<CouponModel> _processCouponsInBackground(List<dynamic> coupons) {
    try {
      return List<CouponModel>.from(coupons);
    } catch (e) {
      debugPrint('Error procesando cupones en background: $e');
      return [];
    }
  }
}
