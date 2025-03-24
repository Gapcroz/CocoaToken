import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
    // Primero verificar si es una tienda
    final prefs = await SharedPreferences.getInstance();
    final userType = prefs.getString('user_type');
    
    // Si es una tienda, no cargar tokens
    if (userType == 'store') {
      _tokens = 0;
      notifyListeners();
      return;
    }

    // Si no es una tienda, continuar con la lógica normal
    if (!AuthService.isAuthenticated || AuthService.userId == null) {
      _tokens = 0;
      notifyListeners();
      return;
    }

    if (_isFetching) return;
    _isFetching = true;
    
    _isLoading = true;
    _error = null;
    
    if (hasListeners) notifyListeners();

    try {
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      print('Estructura JSON: ${jsonData.keys}');
      print('Buscando usuario con ID: ${AuthService.userId}');
      
      final List<dynamic> users = jsonData['tables']['users'] as List<dynamic>;
      print('Usuarios encontrados: ${users.length}');
      
      final userMatch = users.firstWhere(
        (user) => user['id'] == AuthService.userId,
        orElse: () => null,
      );
      
      if (userMatch != null) {
        _tokens = userMatch['tokens'] as int;
        _rewardsHistory = (userMatch['rewards_history'] as List?)
            ?.map((e) => RewardHistory.fromJson(e))
            .toList() ?? [];
          
        print("Loaded tokens for user ${userMatch['name']}: ${_tokens}");
        print("Loaded rewards: ${_rewardsHistory.length}");
      } else {
        print('Usuario no encontrado con ID: ${AuthService.userId}');
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