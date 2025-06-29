import 'package:flutter/material.dart';

import '../widgets/add_dancer_dialog.dart';
import 'select_dancers_screen.dart';

// Interface for tab components to define their available actions
abstract class EventTabActions {
  Future<void> onFabPressed(BuildContext context, VoidCallback onRefresh);
  String get fabTooltip;
  IconData get fabIcon;
}

// Planning Tab Actions Implementation
class PlanningTabActions implements EventTabActions {
  final int eventId;
  final String eventName;

  const PlanningTabActions({
    required this.eventId,
    required this.eventName,
  });

  @override
  Future<void> onFabPressed(
      BuildContext context, VoidCallback onRefresh) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectDancersScreen(
          eventId: eventId,
          eventName: eventName,
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
class PresentTabActions implements EventTabActions {
  final int eventId;

  const PresentTabActions({required this.eventId});

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
