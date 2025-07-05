import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/database.dart';
import '../../../services/dancer/dancer_crud_service.dart';
import '../../../services/dancer/dancer_tag_service.dart';
import '../../../services/dancer_service.dart';
import '../../../services/event_service.dart';
import '../../../utils/action_logger.dart';
import '../../../utils/event_status_helper.dart';
import '../../../widgets/add_dancer_dialog.dart';
import '../../../widgets/dancer_card.dart';
import '../dialogs/add_existing_dancer_screen.dart';
import '../dialogs/event_tab_actions.dart';

// Summary Tab - Shows all dancers who have danced, grouped by score
class SummaryTab extends StatelessWidget {
  final int eventId;

  const SummaryTab({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    ActionLogger.logAction('UI_SummaryTab', 'build_called', {'eventId': eventId});

    final dancerService = Provider.of<DancerService>(context);
    final eventService = Provider.of<EventService>(context, listen: false);

    return FutureBuilder<Event?>(
      future: eventService.getEvent(eventId),
      builder: (context, eventSnapshot) {
        if (eventSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final event = eventSnapshot.data;
        final isPastEvent = event != null && EventStatusHelper.isPastEvent(event.date);

        return StreamBuilder<List<DancerWithEventInfo>>(
          stream: dancerService.watchDancersForEvent(eventId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              ActionLogger.logAction('UI_SummaryTab', 'loading_state', {'eventId': eventId});
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              ActionLogger.logError('UI_SummaryTab', 'stream_error', {
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
            final attendedDancers = allDancers.where((d) => d.isPresent || d.hasLeft).toList();

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
              'firstMetCount': attendedDancers.where((d) => d.isFirstMetHere).length,
              'isPastEvent': isPastEvent,
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

                return (dancerA.scoreOrdinal ?? 999).compareTo(dancerB.scoreOrdinal ?? 999);
              });

            ActionLogger.logAction('UI_SummaryTab', 'grouping_complete', {
              'eventId': eventId,
              'scoreGroups': sortedKeys.length,
              'groupSizes': groupedDancers.map((k, v) => MapEntry(k, v.length)),
            });

            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  // Dance summary section
                  SliverToBoxAdapter(
                    child: SummaryGroupHeader(
                      title: 'Dance Summary',
                      child: SummaryRow(
                        child: Text(
                          'Recorded ${attendedDancers.where((d) => d.hasDanced).length} dances total. Met ${attendedDancers.where((d) => d.isFirstMetHere).length} people for the first time.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Score groups with sticky headers
                  ...sortedKeys.map((scoreName) {
                    final scoreDancers = groupedDancers[scoreName]!;

                    return SliverMainAxisGroup(
                      slivers: [
                        // Sticky header for each score group
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _StickyHeaderDelegate(
                            minHeight: 60,
                            maxHeight: 60,
                            child: SummaryGroupHeader(
                              title: scoreName,
                              counter: '(${scoreDancers.length})',
                            ),
                          ),
                        ),

                        // Dancers in this score group
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: DancerCard(
                                    dancer: scoreDancers[index],
                                    eventId: eventId,
                                    isPlanningMode: false,
                                    hideScorePill: true,
                                    isSummaryMode: true,
                                    hideCheckmark: isPastEvent,
                                  ),
                                );
                              },
                              childCount: scoreDancers.length,
                            ),
                          ),
                        ),

                        // Spacing after each group
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 16),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Custom delegate for sticky headers
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}

// Reusable components for summary styling
class SummaryGroupHeader extends StatelessWidget {
  final String title;
  final String? counter;
  final Widget? child;

  const SummaryGroupHeader({
    super.key,
    required this.title,
    this.counter,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              if (counter != null) ...[
                const SizedBox(width: 4),
                Text(
                  counter!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),
          if (child != null) ...[
            const SizedBox(height: 8),
            child!,
          ],
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final Widget child;

  const SummaryRow({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: child,
      ),
    );
  }
}

// Summary Tab Actions Implementation with Speed Dial Menu
class SummaryTabActions implements EventTabActions {
  final int eventId;
  final String eventName;

  const SummaryTabActions({
    required this.eventId,
    required this.eventName,
  });

  @override
  String get fabTooltip => 'Add dancers to event';

  @override
  IconData get fabIcon => Icons.add;

  @override
  Future<void> onFabPressed(BuildContext context, VoidCallback onRefresh) async {
    // Show speed dial menu with two options
    _showSummaryTabSpeedDial(context, onRefresh);
  }

  void _showSummaryTabSpeedDial(BuildContext context, VoidCallback onRefresh) {
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
}
