import 'package:flutter/material.dart';
import '../models/coupon_model.dart';
import '../services/coupon_service.dart';

class CouponController extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<CouponModel> _coupons = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<CouponModel> get availableCoupons => 
    _coupons.where((coupon) => coupon.isAvailable).toList();
  
  List<CouponModel> get lockedCoupons =>
    _coupons.where((coupon) => !coupon.isAvailable).toList();

  CouponController() {
    loadCoupons();
  }

  Future<void> loadCoupons() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _coupons = await CouponService.loadCoupons();
    } catch (e) {
      _error = 'Error al cargar los cupones: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 