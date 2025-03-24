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
      // Load data directly from JSON for the current user
      final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Actualizado para la nueva estructura con 'tables'
      final List<dynamic> usersJson = jsonData['tables']['users'] as List<dynamic>;
      
      print("Estructura JSON: ${jsonData.keys}");
      print("Buscando usuario con ID: ${AuthService.userId}");
      print("Usuarios encontrados: ${usersJson.length}");
      
      // Find user by ID - cambiado para manejar el orElse correctamente
      Map<String, dynamic>? userJson;
      for (var user in usersJson) {
        if (user['id'] == AuthService.userId) {
          userJson = user;
          break;
        }
      }
      
      if (userJson != null) {
        _tokens = userJson['tokens'] ?? 0;
        _rewardsHistory = (userJson['rewards_history'] as List?)
            ?.map((e) => RewardHistory.fromJson(e))
            .toList() ?? [];
          
        print("Loaded tokens for user ${userJson['name']}: ${_tokens}");
        print("Loaded rewards: ${_rewardsHistory.length}");
      } else {
        print("Usuario no encontrado con ID: ${AuthService.userId}");
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