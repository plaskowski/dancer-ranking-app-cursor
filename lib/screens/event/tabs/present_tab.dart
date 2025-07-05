import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/database.dart';
import '../../../services/dancer/dancer_crud_service.dart';
import '../../../services/dancer/dancer_tag_service.dart';
import '../../../services/dancer_service.dart';
import '../../../services/event_service.dart';
import '../../../utils/action_logger.dart';
import '../../../widgets/add_dancer_dialog.dart';
import '../../../widgets/dancer_card.dart';
import '../dialogs/add_existing_dancer_screen.dart';
import '../dialogs/event_tab_actions.dart';

// Present Tab - Shows only dancers who are present, grouped by rank
class PresentTab extends StatelessWidget {
  final int eventId;
  final String? initialAction;

  const PresentTab({
    super.key,
    required this.eventId,
    this.initialAction,
  });

  @override
  Widget build(BuildContext context) {
    ActionLogger.logAction('UI_PresentTab', 'build_called', {'eventId': eventId});

    // Handle initial action if specified
    if (initialAction != null) {
      ActionLogger.logAction('UI_PresentTab', 'cli_initial_action_received', {
        'eventId': eventId,
        'initialAction': initialAction,
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ActionLogger.logAction('UI_PresentTab', 'cli_executing_initial_action', {
          'eventId': eventId,
          'initialAction': initialAction,
        });
        _performInitialAction(context);
      });
    } else {
      ActionLogger.logAction('UI_PresentTab', 'cli_no_initial_action', {
        'eventId': eventId,
      });
    }

    final dancerService = Provider.of<DancerService>(context);

    return StreamBuilder<List<DancerWithEventInfo>>(
      stream: dancerService.watchDancersForEvent(eventId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          ActionLogger.logAction('UI_PresentTab', 'loading_state', {'eventId': eventId});
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          ActionLogger.logError('UI_PresentTab', 'stream_error', {
            'eventId': eventId,
            'error': snapshot.error.toString(),
            'stackTrace': snapshot.stackTrace?.toString(),
          });
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Unable to load event data',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please restart the app or contact support',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        final allDancers = snapshot.data ?? [];
        final presentDancers = allDancers.where((d) => d.status == 'present' || d.status == 'served').toList();

        ActionLogger.logListRendering(
            'UI_PresentTab',
            'present_dancers',
            presentDancers
                .map((d) => {
                      'id': d.id,
                      'name': d.name,
                      'status': d.status,
                      'isPresent': d.isPresent,
                      'hasRanking': d.hasRanking,
                      'rankName': d.rankName,
                      'rankOrdinal': d.rankOrdinal,
                      'hasDanced': d.hasDanced,
                      'hasScore': d.hasScore,
                      'scoreName': d.scoreName,
                      'scoreOrdinal': d.scoreOrdinal,
                      'isFirstMetHere': d.isFirstMetHere,
                    })
                .toList());

        ActionLogger.logAction('UI_PresentTab', 'filtering_complete', {
          'eventId': eventId,
          'totalDancers': allDancers.length,
          'presentDancers': presentDancers.length,
          'dancedCount': presentDancers.where((d) => d.hasDanced).length,
          'leftCount': allDancers.where((d) => d.status == 'left').length,
          'absentCount': allDancers.where((d) => d.status == 'absent').length,
        });

        if (presentDancers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No dancers present yet'),
                SizedBox(height: 8),
                Text(
                  'Mark dancers as present to see them here',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Group dancers by rank
        final Map<String, List<DancerWithEventInfo>> groupedDancers = {};
        for (final dancer in presentDancers) {
          final rankName = dancer.rankName ?? 'No ranking yet';
          if (!groupedDancers.containsKey(rankName)) {
            groupedDancers[rankName] = [];
          }
          groupedDancers[rankName]!.add(dancer);
        }

        // Sort dancers within each rank group by name
        for (final rankName in groupedDancers.keys) {
          groupedDancers[rankName]!.sort((a, b) => a.name.compareTo(b.name));
        }

        // Sort ranks by ordinal (best first)
        final sortedKeys = groupedDancers.keys.toList()
          ..sort((a, b) {
            if (a == 'No ranking yet') return 1;
            if (b == 'No ranking yet') return -1;

            final dancerA = groupedDancers[a]!.first;
            final dancerB = groupedDancers[b]!.first;

            return (dancerA.rankOrdinal ?? 999).compareTo(dancerB.rankOrdinal ?? 999);
          });

        ActionLogger.logAction('UI_PresentTab', 'grouping_complete', {
          'eventId': eventId,
          'rankGroups': sortedKeys.length,
          'groupSizes': groupedDancers.map((k, v) => MapEntry(k, v.length)),
        });

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: sortedKeys.map((rankName) {
              final rankDancers = groupedDancers[rankName]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rankName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...rankDancers.map((dancer) => DancerCard(
                        dancer: dancer,
                        eventId: eventId,
                        isPlanningMode: false,
                      )),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _performInitialAction(BuildContext context) {
    if (initialAction == null) return;

    ActionLogger.logAction('UI_PresentTab', 'cli_performing_initial_action', {
      'eventId': eventId,
      'initialAction': initialAction,
    });

    switch (initialAction) {
      case 'add-existing-dancer':
        ActionLogger.logAction('UI_PresentTab', 'cli_triggering_add_existing_dancer', {
          'eventId': eventId,
        });
        _showAddExistingDancerDialog(context);
        break;
      default:
        ActionLogger.logAction('UI_PresentTab', 'cli_unknown_action', {
          'eventId': eventId,
          'initialAction': initialAction,
        });
    }
  }

  void _showAddExistingDancerDialog(BuildContext context) {
    ActionLogger.logAction('UI_PresentTab', 'cli_showing_add_existing_dancer_dialog', {
      'eventId': eventId,
    });
    final appDb = Provider.of<AppDatabase>(context, listen: false);

    // Get event name from EventService
    final eventService = Provider.of<EventService>(context, listen: false);
    eventService.getEvent(eventId).then((event) {
      if (event != null && context.mounted) {
        Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => Provider<DancerCrudService>(
              create: (_) => DancerCrudService(appDb),
              child: Provider<DancerTagService>(
                create: (ctx) => DancerTagService(appDb, Provider.of<DancerCrudService>(ctx, listen: false)),
                child: AddExistingDancerScreen(
                  eventId: eventId,
                  eventName: event.name,
                ),
              ),
            ),
          ),
        );
      }
    });
  }
}

// Present Tab Actions Implementation with Speed Dial Menu
class PresentTabActions implements EventTabActions {
  final int eventId;
  final String eventName;

  const PresentTabActions({
    required this.eventId,
    required this.eventName,
  });

  @override
  Future<void> onFabPressed(BuildContext context, VoidCallback onRefresh) async {
    // Show speed dial menu with two options
    _showPresentTabSpeedDial(context, onRefresh);
  }

  void _showPresentTabSpeedDial(BuildContext context, VoidCallback onRefresh) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Dancers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Add New Dancer Option
              ListTile(
                leading: Icon(
                  Icons.person_add,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text('Add New Dancer'),
                subtitle: const Text('Create a new dancer profile'),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (context) => AddDancerDialog(
                      eventId: eventId,
                    ),
                  );
                  if (result == true) {
                    onRefresh();
                  }
                },
              ),

              const Divider(),

              // Add Existing Dancer Option
              ListTile(
                leading: Icon(
                  Icons.person_search,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: const Text('Add Existing Dancer'),
                subtitle: const Text('Mark unranked dancers as present'),
                onTap: () async {
                  Navigator.pop(context);
                  final appDb = Provider.of<AppDatabase>(context, listen: false);
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Provider<DancerCrudService>(
                        create: (_) => DancerCrudService(appDb),
                        child: Provider<DancerTagService>(
                          create: (ctx) => DancerTagService(appDb, Provider.of<DancerCrudService>(ctx, listen: false)),
                          child: AddExistingDancerScreen(
                            eventId: eventId,
                            eventName: eventName,
                          ),
                        ),
                      ),
                    ),
                  );
                  if (result == true) {
                    onRefresh();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  String get fabTooltip => 'Add dancers to event';

  @override
  IconData get fabIcon => Icons.add;
}
