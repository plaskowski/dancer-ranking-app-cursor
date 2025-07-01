import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/event_service.dart';
import '../utils/action_logger.dart';
import 'event_tab_actions.dart';
import 'tabs/planning_tab.dart';
import 'tabs/present_tab.dart';
import 'tabs/summary_tab.dart';

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

  bool get _isPastEvent =>
      _event != null &&
      _event!.date.isBefore(DateUtils.dateOnly(DateTime.now()));

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
    final tabNames = ['planning', 'present', 'summary'];
    ActionLogger.logAction('UI_EventScreen', 'screen_disposed', {
      'eventId': widget.eventId,
      'lastTab': tabNames[_currentPage],
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
          SummaryTabActions(
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

    final tabNames = ['planning', 'present', 'summary'];
    final fromTab = tabNames[_currentPage];
    final toTab = tabNames[index];

    ActionLogger.logAction('UI_EventScreen', 'tab_changed', {
      'eventId': widget.eventId,
      'fromTab': fromTab,
      'toTab': toTab,
      'tabIndex': index,
      'changeMethod': 'swipe',
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabNames = ['planning', 'present', 'summary'];
    ActionLogger.logAction('UI_EventScreen', 'build_called', {
      'eventId': widget.eventId,
      'currentTab': tabNames[_currentPage],
    });

    if (_event == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pages = _isPastEvent
        ? [
            PresentTab(eventId: widget.eventId),
            SummaryTab(eventId: widget.eventId)
          ]
        : [
            PlanningTab(eventId: widget.eventId),
            PresentTab(eventId: widget.eventId),
            SummaryTab(eventId: widget.eventId)
          ];

    final currentTabActions = _isPastEvent
        ? (_currentPage == 0 ? _tabActions[1] : _tabActions[2])
        : _tabActions[_currentPage];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_event!.name} • ${DateFormat('MMM d').format(_event!.date)}',
              style: const TextStyle(fontSize: 16),
            ),
            if (!_isPastEvent)
              Text(
                _getTabIndicator(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            if (_isPastEvent)
              Text(
                _getPastEventTabIndicator(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: pages,
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

  String _getTabIndicator() {
    switch (_currentPage) {
      case 0:
        return '[Planning] • Present • Summary';
      case 1:
        return 'Planning • [Present] • Summary';
      case 2:
        return 'Planning • Present • [Summary]';
      default:
        return 'Planning • Present • Summary';
    }
  }

  String _getPastEventTabIndicator() {
    switch (_currentPage) {
      case 0:
        return '[Present] • Summary';
      case 1:
        return 'Present • [Summary]';
      default:
        return 'Present • Summary';
    }
  }
}
