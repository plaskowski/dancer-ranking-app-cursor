import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/dancer_service.dart';
import '../../utils/action_logger.dart';
import '../../widgets/dancer_card.dart';
import '../event_tab_actions.dart';

// Summary Tab - Shows all dancers who have danced, grouped by score
class SummaryTab extends StatelessWidget {
  final int eventId;

  const SummaryTab({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    ActionLogger.logAction(
        'UI_SummaryTab', 'build_called', {'eventId': eventId});

    final dancerService = Provider.of<DancerService>(context);

    return StreamBuilder<List<DancerWithEventInfo>>(
      stream: dancerService.watchDancersForEvent(eventId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          ActionLogger.logAction(
              'UI_SummaryTab', 'loading_state', {'eventId': eventId});
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          ActionLogger.logError('UI_SummaryTab', 'stream_error', {
            'eventId': eventId,
            'error': snapshot.error.toString(),
          });
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final allDancers = snapshot.data ?? [];
        final attendedDancers =
            allDancers.where((d) => d.isPresent || d.hasLeft).toList();

        ActionLogger.logListRendering(
            'UI_SummaryTab',
            'attended_dancers',
            attendedDancers
                .map((d) => {
                      'id': d.id,
                      'name': d.name,
                      'status': d.status,
                      'hasScore': d.hasScore,
                      'scoreName': d.scoreName,
                      'scoreOrdinal': d.scoreOrdinal,
                      'isFirstMetHere': d.isFirstMetHere,
                    })
                .toList());

        ActionLogger.logAction('UI_SummaryTab', 'filtering_complete', {
          'eventId': eventId,
          'totalDancers': allDancers.length,
          'attendedDancers': attendedDancers.length,
          'firstMetCount':
              attendedDancers.where((d) => d.isFirstMetHere).length,
        });

        if (attendedDancers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.summarize_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No dances recorded yet'),
                SizedBox(height: 8),
                Text(
                  'Dances will appear here after recording',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Group dancers by score
        final Map<String, List<DancerWithEventInfo>> groupedDancers = {};
        for (final dancer in attendedDancers) {
          final scoreName = dancer.scoreName ?? 'No score assigned';
          if (!groupedDancers.containsKey(scoreName)) {
            groupedDancers[scoreName] = [];
          }
          groupedDancers[scoreName]!.add(dancer);
        }

        // Sort dancers within each score group by name
        for (final scoreName in groupedDancers.keys) {
          groupedDancers[scoreName]!.sort((a, b) => a.name.compareTo(b.name));
        }

        // Sort scores by ordinal (best first)
        final sortedKeys = groupedDancers.keys.toList()
          ..sort((a, b) {
            if (a == 'No score assigned') return 1;
            if (b == 'No score assigned') return -1;

            final dancerA = groupedDancers[a]!.first;
            final dancerB = groupedDancers[b]!.first;

            return (dancerA.scoreOrdinal ?? 999)
                .compareTo(dancerB.scoreOrdinal ?? 999);
          });

        ActionLogger.logAction('UI_SummaryTab', 'grouping_complete', {
          'eventId': eventId,
          'scoreGroups': sortedKeys.length,
          'groupSizes': groupedDancers.map((k, v) => MapEntry(k, v.length)),
        });

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Summary header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dance Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        children: [
                          TextSpan(
                            text: 'Recorded ',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                          ),
                          TextSpan(
                            text:
                                '${attendedDancers.where((d) => d.hasDanced).length}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' dances total. Met ',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                          ),
                          TextSpan(
                            text:
                                '${attendedDancers.where((d) => d.isFirstMetHere).length}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' people for the first time.',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Score groups
            ...sortedKeys.map((scoreName) {
              final scoreDancers = groupedDancers[scoreName]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        scoreName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${scoreDancers.length}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...scoreDancers.map((dancer) => DancerCard(
                        dancer: dancer,
                        eventId: eventId,
                        isPlanningMode: false,
                        hideScorePill: true,
                      )),
                  const SizedBox(height: 16),
                ],
              );
            }),
          ],
        );
      },
    );
  }
}

// Summary Tab Actions Implementation (no fab actions needed)
class SummaryTabActions implements EventTabActions {
  final int eventId;
  final String eventName;

  const SummaryTabActions({
    required this.eventId,
    required this.eventName,
  });

  @override
  String get fabTooltip => 'Summary View';

  @override
  IconData get fabIcon => Icons.summarize;

  @override
  Future<void> onFabPressed(
      BuildContext context, VoidCallback onRefresh) async {
    // No actions needed for summary tab - it's read-only
    return;
  }
}
