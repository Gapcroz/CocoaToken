import '../models/event.dart';

// Datos de ejemplo para categorías y eventos
class EventsData {
  static List<EventCategory> getCategories() {
    return [
      EventCategory(
        id: '1',
        name: 'Pago de predial',
        events: [],
        isExpanded: false,
      ),
      EventCategory(
        id: '2',
        name: 'Eventos Deportivos',
        events: [],
        isExpanded: false,
      ),
      EventCategory(
        id: '3',
        name: 'Reuniones Escolares',
        events: [],
        isExpanded: false,
      ),
      EventCategory(
        id: '4',
        name: 'Reciclaje',
        events: [],
        isExpanded: false,
      ),
      EventCategory(
        id: '5',
        name: 'Votaciones Elecciones',
        events: [
          Event(
            id: '1',
            title: 'Vota este 4 de junio',
            description: 'Participa en las elecciones para elegir a tu candidato preferido.',
            imageUrl: 'assets/images/vote_4june.png',
            date: '4 de junio',
            hasReward: true,
            rewardTokens: 50,
          ),
          Event(
            id: '2',
            title: 'Vota este 8 de junio',
            description: 'Segunda vuelta de votaciones para elegir al representante.',
            imageUrl: 'assets/images/vote_8june.png',
            date: '8 de junio',
            hasReward: true,
            rewardTokens: 50,
          ),
          Event(
            id: '3',
            title: 'Vota este 15 de julio',
            description: 'Elecciones finales para el consejo comunitario.',
            imageUrl: 'assets/images/vote_15july.png',
            date: '15 de julio',
            hasReward: true,
            rewardTokens: 50,
          ),
        ],
        isExpanded: false,
      ),
    ];
  }
} 