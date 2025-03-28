import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../data/events_data.dart';

class EventsIsolate {
  static Future<List<EventCategory>> processCategories() async {
    return await compute(_processCategoriesInBackground, null);
  }

  static List<EventCategory> _processCategoriesInBackground(_) {
    try {
      return EventsData.getCategories();
    } catch (e) {
      debugPrint('Error procesando categorías en background: $e');
      return [];
    }
  }
}
