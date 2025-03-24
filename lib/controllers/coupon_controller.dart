import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../screens/coupon_detail_screen.dart';

class CouponController extends ChangeNotifier {
  List<Coupon> _coupons = [];
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;
  bool _isFetching = false;

  List<Coupon> get coupons => _coupons;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;

  // Get available coupons
  List<Coupon> get availableCoupons => 
    _coupons.where((coupon) => coupon.status == Coupon.STATUS_AVAILABLE).toList();

  // Get locked coupons
  List<Coupon> get lockedCoupons =>
    _coupons.where((coupon) => coupon.status == Coupon.STATUS_LOCKED).toList();

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
    
    // Notify only if necessary
    if (hasListeners) notifyListeners();

    try {
      // Get data directly from current user
      final currentUser = AuthService.currentUser!;
      
      // Print for debugging
      print('Cargando cupones para: ${currentUser.name}');
      print('Cupones: ${currentUser.coupons.length}');
      
      _coupons = List<Coupon>.from(currentUser.coupons);
      _error = null;
    } catch (e) {
      print('Error al cargar cupones: $e');
      _error = 'Error al cargar los cupones: $e';
      _coupons = [];
    } finally {
      _isLoading = false;
      _isInitialized = true;
      _isFetching = false;
      
      // Notify only if necessary
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

  void navigateToCouponDetail(BuildContext context, String title, String discount, String qrData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CouponDetailScreen(
          title: title,
          discount: discount,
          qrData: qrData,
        ),
      ),
    );
  }
} 