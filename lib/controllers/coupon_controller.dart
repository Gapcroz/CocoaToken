import 'package:flutter/material.dart';
import '../models/coupon_model.dart';
import '../models/coupon_status.dart';
import '../services/auth_service.dart';
import '../services/coupon_service.dart';
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

  // Filter methods for different coupon statuses
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

  // Constructor that sets up authentication listener
  CouponController() {
    AuthService.addAuthStateListener(_handleAuthChange);
  }

  // Handle authentication state changes
  void _handleAuthChange() {
    if (!AuthService.isAuthenticated) {
      reset();
    }
  }

  @override
  void dispose() {
    AuthService.removeAuthStateListener(_handleAuthChange);
    super.dispose();
  }

  Future<void> fetchStoreCoupons() async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      _isLoading = true;
      notifyListeners();

      debugPrint('Iniciando fetchStoreCoupons...');
      final user = AuthService.currentUser;
      if (user == null) {
        debugPrint('No hay usuario autenticado');
        _error = 'No autenticado';
        return;
      }
      final isStore = user.isStore;
      debugPrint('isStore en fetchStoreCoupons: $isStore');

      if (!isStore) {
        debugPrint('El usuario no es una tienda, no se pueden cargar cupones');
        _error = 'Solo las tiendas pueden ver sus cupones';
        return;
      }

      final newCoupons = await CouponService.loadCoupons();
      debugPrint('Cupones cargados: ${newCoupons.length}');
      _coupons = newCoupons;
      _error = null;
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error al cargar cupones: $e');
      _error = 'Error al cargar los cupones: $e';
      _coupons = [];
    } finally {
      _isLoading = false;
      _isFetching = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserCoupons() async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      _isLoading = true;
      notifyListeners();

      final newCoupons = await CouponService.loadUserCoupons();
      _coupons = newCoupons;
      _error = null;
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error al cargar cupones del usuario: $e');
      _error = 'Error al cargar los cupones: $e';
      _coupons = [];
    } finally {
      _isLoading = false;
      _isFetching = false;
      notifyListeners();
    }
  }

  Future<void> createCoupon(CouponModel coupon) async {
    try {
      _isLoading = true;
      notifyListeners();

      final newCoupon = await CouponService.createCoupon(coupon);
      _coupons.add(newCoupon);
      _error = null;
    } catch (e) {
      debugPrint('Error al crear cupón: $e');
      _error = 'Error al crear el cupón: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCoupon(CouponModel coupon) async {
    try {
      _isLoading = true;
      notifyListeners();

      debugPrint('Actualizando cupón: ${coupon.toJson()}');
      final updatedCoupon = await CouponService.updateCoupon(coupon);
      debugPrint('Cupón actualizado recibido: ${updatedCoupon.toJson()}');
      
      final index = _coupons.indexWhere((c) => c.id == coupon.id);
      if (index != -1) {
        debugPrint('Reemplazando cupón en índice $index');
        _coupons[index] = updatedCoupon;
        debugPrint('Cupón actualizado en la lista: ${_coupons[index].toJson()}');
      } else {
        debugPrint('No se encontró el cupón con ID ${coupon.id} en la lista');
      }
      _error = null;
    } catch (e) {
      debugPrint('Error al actualizar cupón: $e');
      _error = 'Error al actualizar el cupón: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCoupon(String couponId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await CouponService.deleteCoupon(couponId);
      _coupons.removeWhere((c) => c.id == couponId);
      _error = null;
    } catch (e) {
      debugPrint('Error al eliminar cupón: $e');
      _error = 'Error al eliminar el cupón: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _coupons = [];
    _error = null;
    _isLoading = false;
    _isInitialized = false;
    _isFetching = false;
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
