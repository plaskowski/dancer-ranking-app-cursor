import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/dancer_service.dart';
import '../../widgets/add_dancer_dialog.dart';
import '../../widgets/dancer_card.dart';
import '../add_existing_dancer_screen.dart';
import '../event_tab_actions.dart';

// Present Tab - Shows only dancers who are present, grouped by rank
class PresentTab extends StatelessWidget {
  final int eventId;

  const PresentTab({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final dancerService = Provider.of<DancerService>(context);

    return StreamBuilder<List<DancerWithEventInfo>>(
      stream: dancerService.watchDancersForEvent(eventId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final allDancers = snapshot.data ?? [];
        final presentDancers = allDancers
            .where((d) => d.status == 'present' || d.status == 'served')
            .toList();

        if (presentDancers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(height: 16),
                Text(
                  'No one currently at the event',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Text(
                  'Use the + button to add dancers',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          );
        }

        // Group present dancers by rank
        final Map<String, List<DancerWithEventInfo>> groupedDancers = {};

        for (final dancer in presentDancers) {
          final rankName = dancer.rankName ?? 'No ranking yet';
          if (!groupedDancers.containsKey(rankName)) {
            groupedDancers[rankName] = [];
          }
          groupedDancers[rankName]!.add(dancer);
        }

        // Sort groups by rank ordinal
        final sortedKeys = groupedDancers.keys.toList()
          ..sort((a, b) {
            if (a == 'No ranking yet') return 1;
            if (b == 'No ranking yet') return -1;

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
                      eventId: eventId,
                      showPresenceIndicator: false,
                      isPlanningMode: false,
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

// Present Tab Actions Implementation with Speed Dial Menu
class PresentTabActions implements EventTabActions {
  final int eventId;
  final String eventName;

  const PresentTabActions({
    required this.eventId,
    required this.eventName,
  });

  @override
  Future<void> onFabPressed(
      BuildContext context, VoidCallback onRefresh) async {
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
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddExistingDancerScreen(
                        eventId: eventId,
                        eventName: eventName,
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
