import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class TokenController extends ChangeNotifier {
  int _tokens = 0;
  bool _isLoading = false;
  String? _error;
  List<RewardHistory> _rewardsHistory = [];

  int get tokens => _tokens;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<RewardHistory> get rewardsHistory => _rewardsHistory;

  Future<void> fetchUserTokens() async {
    if (!AuthService.isAuthenticated || AuthService.currentUser == null) {
      _tokens = 0;
      _rewardsHistory = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final currentUser = AuthService.currentUser!;
      _tokens = currentUser.tokens;
      _rewardsHistory = currentUser.rewardsHistory;
      _error = null;
    } catch (e) {
      _error = 'Error al cargar los tokens: $e';
      _tokens = 0;
      _rewardsHistory = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 