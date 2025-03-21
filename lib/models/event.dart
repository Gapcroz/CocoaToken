class Event {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String date;
  final int rewardTokens;
  final bool hasReward;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    this.rewardTokens = 0,
    this.hasReward = false,
  });
}

class EventCategory {
  final String id;
  final String name;
  final List<Event> events;
  bool isExpanded;

  EventCategory({
    required this.id,
    required this.name,
    required this.events,
    this.isExpanded = false,
  });
} 