import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/database.dart';
import '../../../services/event_import_service.dart';
import '../../../services/event_service.dart';
import '../../../utils/action_logger.dart';
import '../../../utils/toast_helper.dart';
import '../../../widgets/import_events_dialog.dart';
import '../../event/event_screen.dart';
import '../../settings/settings_screen.dart';

class HomeNavigationService {
  void importEvents(BuildContext context) {
    ActionLogger.logUserAction('HomeScreen', 'import_events_dialog_opened', {});

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      pageBuilder: (context, animation, secondaryAnimation) => Provider(
        create: (context) => EventImportService(
          Provider.of<AppDatabase>(context, listen: false),
        ),
        child: const Dialog.fullscreen(
          child: ImportEventsDialog(),
        ),
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation.drive(Tween(begin: 0.9, end: 1.0)),
            child: child,
          ),
        );
      },
    ).then((result) {
      if (result == true) {
        ActionLogger.logUserAction('HomeScreen', 'import_events_completed', {});
        ToastHelper.showSuccess(context, 'Events imported successfully');
      }
    });
  }

  void navigateToSettings(BuildContext context) {
    ActionLogger.logUserAction('HomeScreen', 'navigate_to_settings', {
      'destination': 'SettingsScreen',
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  static void navigateToEvent(BuildContext context, int eventId, {String? initialTab, String? initialAction}) {
    ActionLogger.logAction('HomeNavigationService', 'navigate_to_event', {
      'eventId': eventId,
      'initialTab': initialTab,
      'initialAction': initialAction,
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventScreen(
          eventId: eventId,
          initialTab: initialTab,
          initialAction: initialAction,
        ),
      ),
    );
  }

  static void navigateToEventByIndex(BuildContext context, int eventIndex,
      {String? initialTab, String? initialAction}) {
    ActionLogger.logAction('HomeNavigationService', 'navigate_to_event_by_index', {
      'eventIndex': eventIndex,
      'initialTab': initialTab,
      'initialAction': initialAction,
    });

    final eventService = Provider.of<EventService>(context, listen: false);
    eventService.watchAllEvents().listen((events) {
      if (eventIndex >= 0 && eventIndex < events.length) {
        final event = events[eventIndex];
        ActionLogger.logAction('HomeNavigationService', 'event_found_by_index', {
          'eventIndex': eventIndex,
          'eventId': event.id,
          'eventName': event.name,
        });
        navigateToEvent(context, event.id, initialTab: initialTab, initialAction: initialAction);
      } else {
        ActionLogger.logAction('HomeNavigationService', 'invalid_event_index', {
          'eventIndex': eventIndex,
          'totalEvents': events.length,
        });
      }
    });
  }
}
