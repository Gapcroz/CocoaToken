import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class CouponController extends ChangeNotifier {
  List<Coupon> _coupons = [];
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  List<Coupon> get coupons => _coupons;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;

  // Obtiene los cupones disponibles
  List<Coupon> get availableCoupons => 
    _coupons.where((coupon) => coupon.status == Coupon.STATUS_AVAILABLE).toList();

  // Obtiene los cupones bloqueados
  List<Coupon> get lockedCoupons =>
    _coupons.where((coupon) => coupon.status == Coupon.STATUS_LOCKED).toList();

  CouponController() {
    // Intentar cargar cupones si hay un usuario autenticado
    if (AuthService.isAuthenticated && AuthService.currentUser != null) {
      fetchUserCoupons();
    }
  }

  Future<void> fetchUserCoupons() async {
    if (!AuthService.isAuthenticated || AuthService.currentUser == null) {
      _coupons = [];
      _error = null;
      _isInitialized = true;
      notifyListeners();
      return;
    }

    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final currentUser = AuthService.currentUser!;
      _coupons = List<Coupon>.from(currentUser.coupons);
      _error = null;
    } catch (e) {
      _error = 'Error al cargar los cupones: $e';
      _coupons = [];
    } finally {
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  void reset() {
    _coupons = [];
    _error = null;
    _isLoading = false;
    _isInitialized = false;
    notifyListeners();
  }
} 