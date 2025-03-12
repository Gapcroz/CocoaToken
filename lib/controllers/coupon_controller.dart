import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

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

  // Obtiene los cupones disponibles
  List<Coupon> get availableCoupons => 
    _coupons.where((coupon) => coupon.status == Coupon.STATUS_AVAILABLE).toList();

  // Obtiene los cupones bloqueados
  List<Coupon> get lockedCoupons =>
    _coupons.where((coupon) => coupon.status == Coupon.STATUS_LOCKED).toList();

  // Constructor sin carga automática
  CouponController();

  Future<void> fetchUserCoupons() async {
    if (_isFetching) return;
    _isFetching = true;
    
    if (!AuthService.isAuthenticated || AuthService.currentUser == null) {
      _coupons = [];
      _error = null;
      _isInitialized = true;
      _isFetching = false;
      
      // Notificar solo si es necesario
      if (hasListeners) notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    
    // Notificar solo si es necesario
    if (hasListeners) notifyListeners();

    try {
      // Obtener datos directamente del usuario actual
      final currentUser = AuthService.currentUser!;
      
      // Imprimir para depuración
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
      
      // Notificar solo si es necesario
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
} 