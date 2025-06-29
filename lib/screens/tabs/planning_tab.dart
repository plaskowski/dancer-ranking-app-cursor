import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/dancer_service.dart';
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
    final dancerService = Provider.of<DancerService>(context);

    return StreamBuilder<List<DancerWithEventInfo>>(
      stream: dancerService.watchDancersForEvent(widget.eventId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final allDancers = snapshot.data ?? [];
        // Only show dancers that have been explicitly added to the event (have rankings)
        final dancers = allDancers.where((d) => d.hasRanking).toList();

        if (dancers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(height: 16),
                Text(
                  'No dancers added yet',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to add dancers to this event',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
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
