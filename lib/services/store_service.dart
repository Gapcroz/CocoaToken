import 'package:flutter/services.dart';

class StoreService {
  Future<String> getStores() async {
    try {
      return await rootBundle.loadString(
        'assets/data/participating_stores.json',
      );
    } catch (e) {
      throw Exception('Error al cargar las tiendas: $e');
    }
  }
}
