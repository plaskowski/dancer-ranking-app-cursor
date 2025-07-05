import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/database.dart';
import 'screens/dancers/dancers_screen.dart';
import 'screens/event/dialogs/select_dancers_screen.dart';
import 'screens/event/event_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/event_service.dart';
import 'utils/action_logger.dart';

/// CLI Arguments structure
class CliArguments {
  final String? navigationPath;
  final int? eventIndex;
  final bool autoTapAdd;
  final String? initialTab;
  final String? initialAction;

  CliArguments({
    this.navigationPath,
    this.eventIndex,
    this.autoTapAdd = false,
    this.initialTab,
    this.initialAction,
  });
}

/// Parse CLI arguments for navigation
/// Usage examples:
/// flutter run --dart-define=NAV_PATH=/event/current
/// flutter run --dart-define=EVENT_INDEX=0 --dart-define=AUTO_TAP_ADD=true
/// flutter run --dart-define=EVENT_INDEX=1
/// flutter run --dart-define=HELP=true
CliArguments parseCliArguments(List<String> args) {
  const navPathStr = String.fromEnvironment('NAV_PATH');
  const eventIndexStr = String.fromEnvironment('EVENT_INDEX');
  const autoTapAddStr =
      String.fromEnvironment('AUTO_TAP_ADD', defaultValue: 'false');
  const helpStr = String.fromEnvironment('HELP');

  // Show help if requested
  if (helpStr == 'true' || args.contains('--help') || args.contains('-h')) {
    showCliHelp();
    return CliArguments();
  }

  // Parse navigation path
  String? navigationPath;
  if (navPathStr.isNotEmpty) {
    navigationPath = navPathStr;
  }

  // Parse event index (legacy support)
  int? eventIndex;
  if (eventIndexStr.isNotEmpty) {
    eventIndex = int.tryParse(eventIndexStr);
    if (eventIndex == null || eventIndex < 0) {
      print('Warning: Invalid EVENT_INDEX. Must be a non-negative integer.');
      return CliArguments();
    }
  }

  // Parse auto tap add
  final autoTapAdd = autoTapAddStr.toLowerCase() == 'true';

  return CliArguments(
    navigationPath: navigationPath,
    eventIndex: eventIndex,
    autoTapAdd: autoTapAdd,
  );
}

/// Show CLI help information
void showCliHelp() {
  print('''
Dancer Ranking App - CLI Navigation

Usage: flutter run --dart-define=NAV_PATH=<path> [additional args]

Arguments:
  NAV_PATH=<path>         - Navigation path (e.g., /event/current)
  EVENT_INDEX=<index>     - Navigate to event at this position (0-based, legacy)
  AUTO_TAP_ADD=true       - Automatically tap the add button (requires navigation)
  HELP=true               - Show this help message

Available Paths:
  /dancers               - Navigate to dancers management screen
  /event/current          - Navigate to a current event (today's date)
  /event/<index>          - Navigate to event by index (0-based)
  /event/current/present-tab - Navigate to current event and switch to present tab
  /event/current/present-tab/add-existing-dancer - Navigate to current event, present tab, and trigger add existing dancer dialog
  /event/current/planning-tab/select-dancers - Navigate to current event, planning tab, and open select dancers dialog

Examples:
  flutter run --dart-define=NAV_PATH=/dancers
  flutter run --dart-define=NAV_PATH=/event/current
  flutter run --dart-define=NAV_PATH=/event/0
  flutter run --dart-define=NAV_PATH=/event/current/present-tab/add-existing-dancer
  flutter run --dart-define=NAV_PATH=/event/current/planning-tab/select-dancers
  flutter run --dart-define=EVENT_INDEX=0 --dart-define=AUTO_TAP_ADD=true
  flutter run --dart-define=HELP=true

Note: 
- NAV_PATH takes precedence over EVENT_INDEX
- /event/current finds an event with today's date for testing present tab
- Invalid paths will fall back to home screen
''');
}

/// CLI Navigator widget that handles automatic navigation and actions
/// This widget only runs once at app startup and then transitions to the target screen
class CliNavigator extends StatefulWidget {
  final String? navigationPath;
  final int? eventIndex;
  final bool autoTapAdd;
  final String? initialTab;
  final String? initialAction;

  CliNavigator({
    super.key,
    required CliArguments cliArgs,
  })  : navigationPath = cliArgs.navigationPath,
        eventIndex = cliArgs.eventIndex,
        autoTapAdd = cliArgs.autoTapAdd,
        initialTab = cliArgs.initialTab,
        initialAction = cliArgs.initialAction;

  @override
  State<CliNavigator> createState() => _CliNavigatorState();
}

class _CliNavigatorState extends State<CliNavigator> {
  Widget? _targetScreen;

  @override
  void initState() {
    super.initState();
    // Perform CLI navigation once at startup
    _performCliNavigation();
  }

  Future<void> _performCliNavigation() async {
    ActionLogger.logAction('CLI_Navigation', 'cli_navigation_started', {
      'navigationPath': widget.navigationPath,
      'eventIndex': widget.eventIndex,
    });

    // Add a small delay to ensure Provider is ready
    await Future.delayed(const Duration(milliseconds: 100));

    final eventService = Provider.of<EventService>(context, listen: false);
    ActionLogger.logAction('CLI_Navigation', 'cli_event_service_obtained', {});

    try {
      // Get events once (not as a stream)
      ActionLogger.logAction('CLI_Navigation', 'cli_loading_events', {});
      final events = await eventService.watchAllEvents().first;
      ActionLogger.logAction('CLI_Navigation', 'cli_events_loaded', {
        'eventsCount': events.length,
      });

      Event? targetEvent;
      bool isDancersNavigation = false;

      // Handle path-based navigation
      if (widget.navigationPath != null) {
        ActionLogger.logAction('CLI_Navigation', 'cli_resolving_path', {
          'navigationPath': widget.navigationPath,
        });

        // Check if this is a dancers navigation
        if (widget.navigationPath!.startsWith('/dancers')) {
          isDancersNavigation = true;
          ActionLogger.logAction(
              'CLI_Navigation', 'cli_navigating_to_dancers', {});
          if (mounted) {
            setState(() {
              _targetScreen = const DancersScreen();
            });
          }
          return;
        }

        targetEvent = _resolveNavigationPath(widget.navigationPath!, events);
      }
      // Handle legacy index-based navigation
      else if (widget.eventIndex != null) {
        ActionLogger.logAction('CLI_Navigation', 'cli_resolving_index', {
          'eventIndex': widget.eventIndex,
        });
        targetEvent = _resolveEventIndex(widget.eventIndex!, events);
      }

      if (targetEvent == null && !isDancersNavigation) {
        ActionLogger.logAction('CLI_Navigation', 'cli_no_valid_target_found', {
          'fallbackToHome': true,
        });
        if (mounted) {
          setState(() {
            _targetScreen = const HomeScreen();
          });
        }
        return;
      }

      ActionLogger.logAction('CLI_Navigation', 'cli_navigating_to_event', {
        'eventId': targetEvent.id,
        'eventName': targetEvent.name,
      });

      // Parse tab and action from navigation path
      String? initialTab;
      String? initialAction;

      if (widget.navigationPath != null) {
        final parts = widget.navigationPath!
            .split('/')
            .where((part) => part.isNotEmpty)
            .toList();
        ActionLogger.logAction('CLI_Navigation', 'cli_parsed_path_parts', {
          'parts': parts,
        });
        if (parts.length >= 3) {
          final tab = parts[2];
          // Map CLI tab names to actual tab names
          switch (tab) {
            case 'present-tab':
              initialTab = 'present';
              break;
            case 'planning-tab':
              initialTab = 'planning';
              break;
            case 'summary-tab':
              initialTab = 'summary';
              break;
            default:
              initialTab = tab; // Use as-is for other cases
          }
          ActionLogger.logAction('CLI_Navigation', 'cli_mapped_tab', {
            'originalTab': tab,
            'mappedTab': initialTab,
          });
        }
        if (parts.length >= 4) {
          initialAction = parts[3];
          ActionLogger.logAction('CLI_Navigation', 'cli_initial_action', {
            'initialAction': initialAction,
          });
        }
      }

      // Handle special actions that require different navigation
      if (initialAction == 'select-dancers') {
        ActionLogger.logAction(
            'CLI_Navigation', 'cli_navigating_to_select_dancers', {
          'eventId': targetEvent.id,
          'eventName': targetEvent.name,
        });

        if (mounted) {
          setState(() {
            _targetScreen = SelectDancersScreen(
              eventId: targetEvent!.id,
              eventName: targetEvent.name,
            );
          });
        }
        return;
      }

      if (mounted) {
        ActionLogger.logAction('CLI_Navigation', 'cli_setting_target_screen', {
          'targetScreen': 'EventScreen',
          'eventId': targetEvent.id,
          'initialTab': initialTab,
          'initialAction': initialAction,
        });
        setState(() {
          _targetScreen = EventScreen(
            eventId: targetEvent!.id,
            initialTab: initialTab,
            initialAction: initialAction,
          );
        });
      }
    } catch (e) {
      ActionLogger.logError('CLI_Navigation', 'cli_error_loading_events',
          {'error': e.toString()});
      if (mounted) {
        setState(() {
          _targetScreen = const HomeScreen();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while performing CLI navigation
    if (_targetScreen == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Return the target screen once navigation is complete
    return _targetScreen!;
  }

  /// Resolve navigation path to find target event or screen
  Event? _resolveNavigationPath(String path, List<Event> events) {
    final parts = path.split('/').where((part) => part.isNotEmpty).toList();

    if (parts.isEmpty) {
      print('Warning: Invalid navigation path: $path');
      return null;
    }

    final screen = parts[0];

    // Handle dancers screen
    if (screen == 'dancers') {
      print('CLI Navigation: Navigating to dancers screen');
      return null; // Return null to indicate this is not an event navigation
    }

    // Handle event navigation
    if (screen == 'event') {
      if (parts.length < 2) {
        print('Warning: Invalid event navigation path: $path');
        return null;
      }

      final target = parts[1];
      Event? event;
      if (target == 'current') {
        event = _findCurrentEvent(events);
      } else {
        // Try to parse as index
        final index = int.tryParse(target);
        if (index != null) {
          event = _resolveEventIndex(index, events);
        }
      }

      if (event != null) {
        // Parse additional path segments for tab and action
        if (parts.length >= 3) {
          final tab = parts[2];
          // Map CLI tab names to actual tab names
          String? mappedTab;
          switch (tab) {
            case 'present-tab':
              mappedTab = 'present';
              break;
            case 'planning-tab':
              mappedTab = 'planning';
              break;
            case 'summary-tab':
              mappedTab = 'summary';
              break;
            default:
              mappedTab = tab; // Use as-is for other cases
          }
          print(
              'CLI Navigation: Setting initial tab to "$mappedTab" (from "$tab")');
        }

        if (parts.length >= 4) {
          final action = parts[3];
          print('CLI Navigation: Setting initial action to "$action"');
        }

        return event;
      }
    }

    print('Warning: Unknown navigation path: $path');
    return null;
  }

  /// Find current event (today's date)
  Event? _findCurrentEvent(List<Event> events) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    for (final event in events) {
      final eventDate =
          DateTime(event.date.year, event.date.month, event.date.day);
      if (eventDate.isAtSameMomentAs(todayDate)) {
        print('CLI Navigation: Found current event "${event.name}" for today');
        return event;
      }
    }

    print(
        'CLI Navigation: No current event found for today. Available events:');
    for (int i = 0; i < events.length; i++) {
      final event = events[i];
      final eventDate =
          DateTime(event.date.year, event.date.month, event.date.day);
      final isToday = eventDate.isAtSameMomentAs(todayDate);
      print(
          '  [$i] ${event.name} (${event.date.toString().split(' ')[0]}) ${isToday ? '← TODAY' : ''}');
    }
    return null;
  }

  /// Resolve event index to find target event
  Event? _resolveEventIndex(int index, List<Event> events) {
    if (index >= events.length) {
      print(
          'Warning: Event index $index is out of range. Available events: ${events.length}');
      return null;
    }
    return events[index];
  }
}
