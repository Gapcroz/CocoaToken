import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/store.dart';

class StoreService {
  Future<List<Store>> getStores() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/participating_stores.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> storesJson = jsonData['stores'];
      
      return storesJson.map((store) => Store.fromJson(store)).toList();
    } catch (e) {
      throw Exception('Error al cargar las tiendas: $e');
    }
  }
} 