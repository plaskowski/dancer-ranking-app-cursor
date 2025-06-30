import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/event_service.dart';
import '../utils/action_logger.dart';
import 'event_tab_actions.dart';
import 'tabs/planning_tab.dart';
import 'tabs/present_tab.dart';

class EventScreen extends StatefulWidget {
  final int eventId;

  const EventScreen({super.key, required this.eventId});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  Event? _event;
  late List<EventTabActions> _tabActions;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadEvent();

    ActionLogger.logAction('UI_EventScreen', 'screen_initialized', {
      'eventId': widget.eventId,
      'initialTab': 'planning',
    });
  }

  @override
  void dispose() {
    ActionLogger.logAction('UI_EventScreen', 'screen_disposed', {
      'eventId': widget.eventId,
      'lastTab': _currentPage == 0 ? 'planning' : 'present',
    });

    _pageController.dispose();
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

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });

    ActionLogger.logAction('UI_EventScreen', 'tab_changed', {
      'eventId': widget.eventId,
      'fromTab': _currentPage == 0 ? 'present' : 'planning',
      'toTab': index == 0 ? 'planning' : 'present',
      'tabIndex': index,
      'changeMethod': 'swipe',
    });
  }

  @override
  Widget build(BuildContext context) {
    ActionLogger.logAction('UI_EventScreen', 'build_called', {
      'eventId': widget.eventId,
      'currentTab': _currentPage == 0 ? 'planning' : 'present',
    });

    if (_event == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentTabActions = _tabActions[_currentPage];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_event!.name} • ${DateFormat('MMM d').format(_event!.date)}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              _currentPage == 0
                  ? '[Planning] • Present'
                  : 'Planning • [Present]',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
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
