import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import '../../services/event_service.dart';
import '../../utils/action_logger.dart';
import '../../widgets/error_display.dart';
import '../../widgets/safe_fab.dart';
import 'dialog/create_event_screen.dart';
import 'widgets/empty_events_view.dart';
import 'widgets/event_card.dart';
import 'widgets/home_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventService = Provider.of<EventService>(context);

    return Scaffold(
      appBar: const HomeAppBar(),
      body: StreamBuilder<List<Event>>(
        stream: eventService.watchAllEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorDisplayFactory.streamError(
              source: 'HomeScreen.StreamBuilder',
              error: snapshot.error!,
              stackTrace: snapshot.stackTrace,
              title: 'Unable to load events',
              message: 'Please restart the app or contact support',
            );
          }

          final events = snapshot.data ?? [];

          if (events.isEmpty) {
            return const EmptyEventsView();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return EventCard(event: event);
            },
          );
        },
      ),
      floatingActionButton: SafeFAB(
        onPressed: () {
          ActionLogger.logUserAction('HomeScreen', 'navigate_to_create_event', {
            'destination': 'CreateEventScreen',
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateEventScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
