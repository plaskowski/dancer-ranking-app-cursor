import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/event_service.dart';
import '../services/dancer_service.dart';
import '../widgets/add_dancer_dialog.dart';
import '../widgets/dancer_actions_dialog.dart';
import 'select_dancers_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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

    return Scaffold(
      appBar: AppBar(
        title: Text(_event!.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Planning'),
            Tab(text: 'Present'),
          ],
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
        onPressed: () => _addDancer(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addDancer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectDancersScreen(
          eventId: widget.eventId,
          eventName: _event!.name,
        ),
      ),
    );

    // Refresh the screen if dancers were added
    if (result == true) {
      setState(() {
        // This will trigger a rebuild and refresh the data
      });
    }
  }
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
                      eventId: eventId,
                      showPresenceIndicator: true,
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

  const _DancerCard({
    required this.dancer,
    required this.eventId,
    required this.showPresenceIndicator,
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
            ),
          );
        },
      ),
    );
  }
}
