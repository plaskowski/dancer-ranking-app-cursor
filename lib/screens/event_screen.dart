import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/event_service.dart';
import 'event_tab_actions.dart';
import 'tabs/planning_tab.dart';
import 'tabs/present_tab.dart';

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
        // Initialize tab actions with event data
        _tabActions = [
          PlanningTabActions(
            eventId: widget.eventId,
            eventName: _event!.name,
          ),
          PresentTabActions(
            eventId: widget.eventId,
            eventName: _event!.name,
          ),
        ];
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
        title: Text(
          '${_event!.name} - ${DateFormat('MMM d').format(_event!.date)}',
          style: const TextStyle(fontSize: 20),
        ),
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
          PlanningTab(eventId: widget.eventId),
          PresentTab(eventId: widget.eventId),
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
