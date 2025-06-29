import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/dancer_service.dart';
import '../../theme/theme_extensions.dart';
import '../../utils/action_logger.dart';
import '../../widgets/dancer_card.dart';
import '../event_tab_actions.dart';
import '../select_dancers_screen.dart';

// Planning Tab - Shows all dancers grouped by rank
class PlanningTab extends StatefulWidget {
  final int eventId;

  const PlanningTab({super.key, required this.eventId});

  @override
  State<PlanningTab> createState() => _PlanningTabState();
}

class _PlanningTabState extends State<PlanningTab> {
  @override
  Widget build(BuildContext context) {
    ActionLogger.logAction(
        'UI_PlanningTab', 'build_called', {'eventId': widget.eventId});

    final dancerService = Provider.of<DancerService>(context);

    return StreamBuilder<List<DancerWithEventInfo>>(
      stream: dancerService.watchDancersForEvent(widget.eventId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          ActionLogger.logAction(
              'UI_PlanningTab', 'loading_state', {'eventId': widget.eventId});
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          ActionLogger.logError('UI_PlanningTab', 'stream_error', {
            'eventId': widget.eventId,
            'error': snapshot.error.toString(),
          });
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final allDancers = snapshot.data ?? [];
        // Only show dancers that have been explicitly added to the event (have rankings) AND are not present yet
        final dancers =
            allDancers.where((d) => d.hasRanking && !d.isPresent).toList();

        ActionLogger.logListRendering(
            'UI_PlanningTab',
            'filtered_dancers',
            dancers
                .map((d) => {
                      'id': d.id,
                      'name': d.name,
                      'status': d.status,
                      'isPresent': d.isPresent,
                      'hasRanking': d.hasRanking,
                      'rankName': d.rankName,
                      'rankOrdinal': d.rankOrdinal,
                    })
                .toList());

        ActionLogger.logAction('UI_PlanningTab', 'filtering_complete', {
          'eventId': widget.eventId,
          'totalDancers': allDancers.length,
          'filteredDancers': dancers.length,
          'presentDancers': allDancers.where((d) => d.isPresent).length,
          'rankedDancers': allDancers.where((d) => d.hasRanking).length,
        });

        if (dancers.isEmpty) {
          // Check if there are any ranked dancers at all for this event
          final totalRankedDancers =
              allDancers.where((d) => d.hasRanking).length;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  totalRankedDancers > 0 ? Icons.check_circle : Icons.people,
                  size: 64,
                  color: totalRankedDancers > 0
                      ? context.danceTheme.success
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  totalRankedDancers > 0
                      ? 'All ranked dancers are present!'
                      : 'No dancers added yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  totalRankedDancers > 0
                      ? 'Switch to Present tab to manage attendance'
                      : 'Tap + to add dancers to this event',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        // Group dancers by rank (only dancers with rankings will be shown)
        final Map<String, List<DancerWithEventInfo>> groupedDancers = {};

        for (final dancer in dancers) {
          final rankName =
              dancer.rankName!; // Safe since we filtered for hasRanking
          if (!groupedDancers.containsKey(rankName)) {
            groupedDancers[rankName] = [];
          }
          groupedDancers[rankName]!.add(dancer);
        }

        // Sort groups by rank ordinal
        final sortedKeys = groupedDancers.keys.toList()
          ..sort((a, b) {
            final dancerA = groupedDancers[a]!.first;
            final dancerB = groupedDancers[b]!.first;

            return (dancerA.rankOrdinal ?? 999)
                .compareTo(dancerB.rankOrdinal ?? 999);
          });

        ActionLogger.logAction('UI_PlanningTab', 'grouping_complete', {
          'eventId': widget.eventId,
          'rankGroups': sortedKeys.length,
          'groupSizes': groupedDancers.map((k, v) => MapEntry(k, v.length)),
        });

        return ListView(
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
                      eventId: widget.eventId,
                      showPresenceIndicator: true,
                      isPlanningMode: true,
                    )),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}

// Planning Tab Actions Implementation
class PlanningTabActions implements EventTabActions {
  final int eventId;
  final String eventName;

  const PlanningTabActions({
    required this.eventId,
    required this.eventName,
  });

  @override
  Future<void> onFabPressed(
      BuildContext context, VoidCallback onRefresh) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectDancersScreen(
          eventId: eventId,
          eventName: eventName,
        ),
      ),
    );

    // Refresh the screen if dancers were added
    if (result == true) {
      onRefresh();
    }
  }

  @override
  String get fabTooltip => 'Add multiple dancers to event';

  @override
  IconData get fabIcon => Icons.group_add;
}
