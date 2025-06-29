import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/attendance_service.dart';
import 'dancer_actions_dialog.dart';

// Dancer Card widget used in both tabs
class DancerCard extends StatelessWidget {
  final DancerWithEventInfo dancer;
  final int eventId;
  final bool showPresenceIndicator;
  final bool isPlanningMode;
  final VoidCallback? onPresenceChanged;

  const DancerCard({
    super.key,
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
