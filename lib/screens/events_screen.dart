import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../controllers/events_controller.dart';
import '../models/event.dart';
import '../widgets/expandable_event_section.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final EventsController _eventsController = EventsController();

  @override
  void dispose() {
    _eventsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: AppTheme.headerDecoration,
                child: Column(
                  children: [
                    Container(
                      color: AppTheme.primaryColor,
                      height: MediaQuery.of(context).padding.top,
                    ),
                    Padding(
                      padding: AppTheme.headerPadding.copyWith(
                        top: 20,
                        bottom: 20,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Image.asset(
                              'assets/icons/arrow.png',
                              width: 24,
                              height: 24,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text('Eventos sociales', style: AppTheme.titleMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // main content
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: StreamBuilder<List<EventCategory>>(
                  stream: _eventsController.categoriesStream,
                  initialData: _eventsController.categories,
                  builder: (context, snapshot) {
                    final categories = snapshot.data ?? [];

                    return ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return ExpandableEventSection(
                          category: categories[index],
                          isExpanded: categories[index].isExpanded,
                          onToggle:
                              () => _eventsController.toggleCategory(index),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
