import 'package:flutter/foundation.dart';
import '../models/store.dart';
import 'dart:convert';

class StoreIsolate {
  static Future<List<Store>> processStores(String jsonString) async {
    return await compute(_processStoresInBackground, jsonString);
  }

  static List<Store> _processStoresInBackground(String jsonString) {
    try {
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> storesJson = jsonData['stores'];
      return storesJson.map((store) => Store.fromJson(store)).toList();
    } catch (e) {
      debugPrint('Error procesando tiendas en background: $e');
      return [];
    }
  }
}
