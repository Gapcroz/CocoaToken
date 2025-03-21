import 'dart:async';
import '../models/event.dart';
import '../data/events_data.dart';

class EventsController {
  // Get categories from data source
  final List<EventCategory> _categories = EventsData.getCategories();

  List<EventCategory> get categories => _categories;

  // Stream controller to notify changes
  final _categoriesController = StreamController<List<EventCategory>>.broadcast();
  Stream<List<EventCategory>> get categoriesStream => _categoriesController.stream;

  // Constructor that initializes the stream with initial data
  EventsController() {
    _categoriesController.add(_categories);
  }

  // Method to toggle a category's expansion
  void toggleCategory(int index) {
    // Close previously expanded category
    for (int i = 0; i < _categories.length; i++) {
      if (i != index && _categories[i].isExpanded) {
        _categories[i].isExpanded = false;
      }
    }
    
    // Change the selected category state
    _categories[index].isExpanded = !_categories[index].isExpanded;
    
    // Notify listeners about the change
    _categoriesController.add(_categories);
  }

  // Important: close the stream when no longer needed
  void dispose() {
    _categoriesController.close();
  }
} 