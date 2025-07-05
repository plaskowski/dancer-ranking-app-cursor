import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import '../../services/event_service.dart';
import '../../utils/action_logger.dart';
import '../../utils/event_status_helper.dart';
import '../../widgets/safe_fab.dart';
import 'dialogs/event_tab_actions.dart';
import 'tabs/planning_tab.dart';
import 'tabs/present_tab.dart';
import 'tabs/summary_tab.dart';

class EventScreen extends StatefulWidget {
  final int eventId;
  final String? initialTab;
  final String? initialAction;

  const EventScreen({
    super.key,
    required this.eventId,
    this.initialTab,
    this.initialAction,
  });

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  Event? _event;
  late List<EventTabActions> _tabActions;

  bool get _isPastEvent => _event != null && EventStatusHelper.isPastEvent(_event!.date);

  bool get _isOldEvent => _event != null && EventStatusHelper.isOldEvent(_event!.date);

  bool get _isFarFutureEvent => _event != null && EventStatusHelper.isFarFutureEvent(_event!.date);

  @override
  void initState() {
    super.initState();
    _loadEvent();

    ActionLogger.logAction('UI_EventScreen', 'screen_initialized', {
      'eventId': widget.eventId,
      'initialTab': widget.initialTab,
    });
  }

  @override
  void dispose() {
    final tabNames = EventStatusHelper.getAvailableTabs(_event?.date ?? DateTime.now());
    ActionLogger.logAction('UI_EventScreen', 'screen_disposed', {
      'eventId': widget.eventId,
      'lastTab': tabNames.isNotEmpty ? tabNames[_currentPage] : 'unknown',
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

        // Determine initial page based on event type and CLI parameters
        int initialPage = 0;
        if (_isOldEvent) {
          // Old events only have Summary tab, so start at index 0
          initialPage = 0;
        } else if (_isFarFutureEvent) {
          // Far future events only have Planning tab, so start at index 0
          initialPage = 0;
        } else {
          // For current events, check if CLI specified a tab
          if (widget.initialTab != null) {
            final tabNames = EventStatusHelper.getAvailableTabs(_event!.date);
            final tabIndex = tabNames.indexOf(widget.initialTab!);
            if (tabIndex != -1) {
              initialPage = tabIndex;
              print('CLI Navigation: Setting initial tab to "${widget.initialTab}" (index: $tabIndex)');
            } else {
              print('CLI Navigation: Invalid tab "${widget.initialTab}". Available tabs: $tabNames');
            }
          }
        }

        _currentPage = initialPage;
        _pageController = PageController(initialPage: initialPage);

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

    final tabNames = EventStatusHelper.getAvailableTabs(_event?.date ?? DateTime.now());
    final fromTab = tabNames.isNotEmpty ? tabNames[_currentPage] : 'unknown';
    final toTab = tabNames.isNotEmpty ? tabNames[index] : 'unknown';

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
    final tabNames = EventStatusHelper.getAvailableTabs(_event?.date ?? DateTime.now());

    ActionLogger.logAction('UI_EventScreen', 'build_called', {
      'eventId': widget.eventId,
      'currentTab': tabNames.isNotEmpty ? tabNames[_currentPage] : 'unknown',
    });

    if (_event == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Different tab configurations based on event age
    final pages = _isOldEvent
        ? [
            SummaryTab(eventId: widget.eventId) // Only Summary tab for old events
          ]
        : _isFarFutureEvent
            ? [
                PlanningTab(eventId: widget.eventId) // Only Planning tab for far future events
              ]
            : _isPastEvent
                ? [
                    PresentTab(eventId: widget.eventId, initialAction: widget.initialAction),
                    SummaryTab(eventId: widget.eventId)
                  ]
                : [
                    PlanningTab(eventId: widget.eventId),
                    PresentTab(eventId: widget.eventId, initialAction: widget.initialAction),
                    SummaryTab(eventId: widget.eventId)
                  ];

    // Get the correct tab actions based on event type and current page
    final currentTabActions = _isOldEvent
        ? _tabActions[2] // Always Summary actions for old events
        : _isFarFutureEvent
            ? _tabActions[0] // Always Planning actions for far future events
            : _isPastEvent
                ? (_currentPage == 0 ? _tabActions[1] : _tabActions[2]) // Present or Summary
                : _tabActions[_currentPage]; // Planning, Present, or Summary

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_event!.name} • ${DateFormat('MMM d').format(_event!.date)}',
              style: const TextStyle(fontSize: 16),
            ),
            if (_isOldEvent)
              Text(
                'Summary', // Only Summary tab for old events
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            else if (_isFarFutureEvent)
              Text(
                'Planning', // Only Planning tab for far future events
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            else if (_isPastEvent)
              Text(
                _getPastEventTabIndicator(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            else
              Text(
                _getTabIndicator(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
          ],
        ),
      ),
      body: pages.length == 1
          ? pages[0] // Single tab, no PageView needed
          : PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: pages,
            ),
      floatingActionButton: _isOldEvent
          ? null // Hide FAB for old events (2+ days ago)
          : SafeFAB(
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
