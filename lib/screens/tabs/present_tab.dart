import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import '../../services/dancer_service.dart';
import '../../widgets/dancer_card.dart';

// Present Tab - Shows only dancers who are present, grouped by rank
class PresentTab extends StatelessWidget {
  final int eventId;

  const PresentTab({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final dancerService = Provider.of<DancerService>(context);

    return FutureBuilder<List<DancerWithEventInfo>>(
      future: dancerService.getDancersForEvent(eventId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final allDancers = snapshot.data ?? [];
        final presentDancers = allDancers.where((d) => d.isPresent).toList();

        if (presentDancers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No one marked present yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Go to Planning tab to mark people as present',
                  style: TextStyle(color: Colors.grey),
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
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
