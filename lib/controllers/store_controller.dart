import 'package:flutter/material.dart';
import '../models/store.dart';
import '../services/store_service.dart';
import '../isolates/store_isolate.dart';

class StoreController extends ChangeNotifier {
  final StoreService _storeService = StoreService();
  List<Store> _stores = [];
  bool _isLoading = false;
  String _error = '';

  List<Store> get stores => _stores;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadStores() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final stores = await _storeService.getStores();
      _stores = await StoreIsolate.processStores(stores);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
