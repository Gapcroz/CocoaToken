import 'dart:async';
import '../models/event.dart';
import '../data/events_data.dart';

class EventsController {
  // Obtener categorías desde la fuente de datos
  final List<EventCategory> _categories = EventsData.getCategories();

  List<EventCategory> get categories => _categories;

  // Stream controller para notificar cambios
  final _categoriesController = StreamController<List<EventCategory>>.broadcast();
  Stream<List<EventCategory>> get categoriesStream => _categoriesController.stream;

  // Constructor que inicializa el stream con los datos iniciales
  EventsController() {
    _categoriesController.add(_categories);
  }

  // Método para alternar la expansión de una categoría
  void toggleCategory(int index) {
    // Cierra la categoría que estaba previamente expandida
    for (int i = 0; i < _categories.length; i++) {
      if (i != index && _categories[i].isExpanded) {
        _categories[i].isExpanded = false;
      }
    }
    
    // Cambia el estado de la categoría seleccionada
    _categories[index].isExpanded = !_categories[index].isExpanded;
    
    // Notifica a los oyentes sobre el cambio
    _categoriesController.add(_categories);
  }

  // Importante: cerrar el stream cuando ya no se necesite
  void dispose() {
    _categoriesController.close();
  }
} 