import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/event_service.dart';
import '../services/dancer_service.dart';
import '../services/attendance_service.dart';
import '../widgets/add_dancer_dialog.dart';
import '../widgets/dancer_actions_dialog.dart';
import 'select_dancers_screen.dart';

// Interface for tab components to define their available actions
abstract class EventTabActions {
  Future<void> onFabPressed(BuildContext context, VoidCallback onRefresh);
  String get fabTooltip;
  IconData get fabIcon;
}

class EventScreen extends StatefulWidget {
  final int eventId;

  const EventScreen({super.key, required this.eventId});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Event? _event;
  late List<EventTabActions> _tabActions;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabActions = [
      _PlanningTabActions(eventId: widget.eventId),
      _PresentTabActions(eventId: widget.eventId),
    ];
    _loadEvent();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEvent() async {
    final eventService = Provider.of<EventService>(context, listen: false);
    final event = await eventService.getEvent(widget.eventId);
    if (mounted) {
      setState(() {
        _event = event;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_event == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentTabActions = _tabActions[_tabController.index];

    return Scaffold(
      appBar: AppBar(
        title: Text(_event!.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Planning'),
            Tab(text: 'Present'),
          ],
          onTap: (index) {
            setState(() {
              // Trigger rebuild to update FAB
            });
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PlanningTab(eventId: widget.eventId),
          _PresentTab(eventId: widget.eventId),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => currentTabActions.onFabPressed(context, () {
          setState(() {
            // Trigger rebuild to refresh the active tab
          });
        }),
        tooltip: currentTabActions.fabTooltip,
        child: Icon(currentTabActions.fabIcon),
      ),
    );
  }
}

// Planning Tab Actions Implementation
class _PlanningTabActions implements EventTabActions {
  final int eventId;

  const _PlanningTabActions({required this.eventId});

  @override
  Future<void> onFabPressed(
      BuildContext context, VoidCallback onRefresh) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectDancersScreen(
          eventId: eventId,
          eventName: 'Planning', // We'll get event name from context if needed
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

// Present Tab Actions Implementation
class _PresentTabActions implements EventTabActions {
  final int eventId;

  const _PresentTabActions({required this.eventId});

  @override
  Future<void> onFabPressed(
      BuildContext context, VoidCallback onRefresh) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AddDancerDialog(
        eventId: eventId,
      ),
    );

    // Refresh the screen if a dancer was added
    if (result == true) {
      onRefresh();
    }
  }

  @override
  String get fabTooltip => 'Add newly met dancer';

  @override
  IconData get fabIcon => Icons.person_add;
}

// Planning Tab - Shows all dancers grouped by rank
class _PlanningTab extends StatelessWidget {
  final int eventId;

  const _PlanningTab({required this.eventId});

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
        // Only show dancers that have been explicitly added to the event (have rankings)
        final dancers = allDancers.where((d) => d.hasRanking).toList();

        if (dancers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No dancers added yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap + to add dancers to this event',
                  style: TextStyle(color: Colors.grey),
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                ...rankDancers.map((dancer) => _DancerCard(
                      dancer: dancer,
                      eventId: widget.eventId,
                      showPresenceIndicator: true,
                      isPlanningMode: true,
                      onPresenceChanged: _refreshData,
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

// Present Tab - Shows only dancers who are present, grouped by rank
class _PresentTab extends StatelessWidget {
  final int eventId;

  const _PresentTab({required this.eventId});

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
                ...rankDancers.map((dancer) => _DancerCard(
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

// Dancer Card widget used in both tabs
class _DancerCard extends StatelessWidget {
  final DancerWithEventInfo dancer;
  final int eventId;
  final bool showPresenceIndicator;
  final bool isPlanningMode;
  final VoidCallback? onPresenceChanged;

  const _DancerCard({
    required this.dancer,
    required this.eventId,
    required this.showPresenceIndicator,
    required this.isPlanningMode,
    this.onPresenceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                dancer.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            if (showPresenceIndicator && dancer.isPresent)
              const Icon(Icons.check, color: Colors.green, size: 20),
            // Show "Mark Present" button in Planning mode for absent dancers
            if (isPlanningMode && !dancer.isPresent)
              IconButton(
                icon:
                    const Icon(Icons.location_on_outlined, color: Colors.blue),
                tooltip: 'Mark Present',
                onPressed: () => _markPresent(context),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dancer.rankingReason != null)
              Text(
                '"${dancer.rankingReason}"',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            if (dancer.hasDanced)
              const Row(
                children: [
                  Icon(Icons.music_note, size: 16, color: Colors.purple),
                  SizedBox(width: 4),
                  Text('Danced!', style: TextStyle(color: Colors.purple)),
                ],
              ),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => DancerActionsDialog(
              dancer: dancer,
              eventId: eventId,
              isPlanningMode: isPlanningMode,
            ),
          );
        },
      ),
    );
  }

  Future<void> _markPresent(BuildContext context) async {
    try {
      final attendanceService =
          Provider.of<AttendanceService>(context, listen: false);
      await attendanceService.markPresent(eventId, dancer.id);

      // Show success feedback
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${dancer.name} marked as present'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

        // Trigger refresh
        onPresenceChanged?.call();
      }
    } catch (e) {
      // Show error feedback
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error marking present: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
