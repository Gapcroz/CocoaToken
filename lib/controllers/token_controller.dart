import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class TokenController extends ChangeNotifier {
  int _tokens = 0;
  List<RewardHistory> _rewardsHistory = [];
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;
  bool _isFetching = false;

  int get tokens => _tokens;
  List<RewardHistory> get rewardsHistory => _rewardsHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;

  // Constructor
  TokenController();

  Future<void> fetchUserTokens() async {
    if (_isFetching) return;
    _isFetching = true;
    
    if (!AuthService.isAuthenticated || AuthService.userId == null) {
      _tokens = 0;
      _rewardsHistory = [];
      _error = null;
      _isInitialized = true;
      _isFetching = false;
      
      if (hasListeners) notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    
    if (hasListeners) notifyListeners();

    try {
      // Load data directly from JSON for the current user
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> usersJson = jsonData['users'] as List<dynamic>;
      
      // Find user by ID
      final userJson = usersJson.firstWhere(
        (user) => user['id'] == AuthService.userId,
        orElse: () => null,
      );
      
      if (userJson != null) {
        _tokens = userJson['tokens'] ?? 0;
        _rewardsHistory = (userJson['rewards_history'] as List?)
            ?.map((e) => RewardHistory.fromJson(e))
            .toList() ?? [];
          
        print("Loaded tokens for user ${userJson['name']}: ${_tokens}");
        print("Loaded rewards: ${_rewardsHistory.length}");
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error loading tokens: $e');
      _error = 'Error loading tokens: $e';
      _tokens = 0;
      _rewardsHistory = [];
    } finally {
      _isLoading = false;
      _isInitialized = true;
      _isFetching = false;
      
      if (hasListeners) notifyListeners();
    }
  }

  void reset() {
    _tokens = 0;
    _rewardsHistory = [];
    _error = null;
    _isLoading = false;
    _isInitialized = false;
    notifyListeners();
  }
} 