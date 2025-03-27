import 'package:flutter/material.dart';
import '../models/coupon_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../screens/coupon_detail_screen.dart';

class CouponController extends ChangeNotifier {
  List<CouponModel> _coupons = [];
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;
  bool _isFetching = false;

  List<CouponModel> get coupons => _coupons;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;

  // Filtros para cupones
  List<CouponModel> get availableCoupons =>
      _coupons
          .where((coupon) => coupon.status == CouponStatus.available)
          .toList();

  List<CouponModel> get lockedCoupons =>
      _coupons.where((coupon) => coupon.status == CouponStatus.locked).toList();

  List<CouponModel> get usedCoupons =>
      _coupons.where((coupon) => coupon.status == CouponStatus.used).toList();

  List<CouponModel> get expiredCoupons =>
      _coupons
          .where((coupon) => coupon.status == CouponStatus.expired)
          .toList();

  // Constructor without automatic loading
  CouponController();

  Future<void> fetchUserCoupons() async {
    if (!AuthService.isAuthenticated || AuthService.currentUser == null) {
      _coupons = [];
      notifyListeners();
      return;
    }
    if (_isFetching) return;
    _isFetching = true;

    _isLoading = true;
    _error = null;

    if (hasListeners) notifyListeners();

    try {
      final currentUser = AuthService.currentUser!;

      debugPrint('Cargando cupones para: ${currentUser.name}');
      debugPrint('Cupones: ${currentUser.coupons.length}');

      _coupons = List<CouponModel>.from(currentUser.coupons);
      _error = null;
    } catch (e) {
      debugPrint('Error al cargar cupones: $e');
      _error = 'Error al cargar los cupones: $e';
      _coupons = [];
    } finally {
      _isLoading = false;
      _isInitialized = true;
      _isFetching = false;

      if (hasListeners) notifyListeners();
    }
  }

  void reset() {
    _coupons = [];
    _error = null;
    _isLoading = false;
    _isInitialized = false;
    notifyListeners();
  }

  void navigateToCouponDetail(
    BuildContext context,
    String title,
    String discount,
    String qrData,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CouponDetailScreen(
              title: title,
              discount: discount,
              qrData: qrData,
            ),
      ),
    );
  }
}
