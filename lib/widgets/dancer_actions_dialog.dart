import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/attendance_service.dart';
import '../services/dancer_service.dart';
import '../theme/theme_extensions.dart';
import 'add_dancer_dialog.dart';
import 'dance_recording_dialog.dart';
import 'ranking_dialog.dart';

class DancerActionsDialog extends StatelessWidget {
  final DancerWithEventInfo dancer;
  final int eventId;
  final bool isPlanningMode;

  const DancerActionsDialog({
    super.key,
    required this.dancer,
    required this.eventId,
    required this.isPlanningMode,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(dancer.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Set/Edit Ranking
          ListTile(
            leading: Icon(Icons.star, color: context.danceTheme.rankingHigh),
            title: Text(dancer.hasRanking ? 'Edit Ranking' : 'Set Ranking'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => RankingDialog(
                  dancerId: dancer.id,
                  eventId: eventId,
                ),
              );
            },
          ),

          // Mark Present / Remove from Present
          ListTile(
            leading: Icon(
              dancer.isPresent ? Icons.location_off : Icons.location_on,
              color: dancer.isPresent
                  ? context.danceTheme.absent
                  : context.danceTheme.present,
            ),
            title:
                Text(dancer.isPresent ? 'Remove from Present' : 'Mark Present'),
            onTap: () => _togglePresence(context),
          ),

          // Combined action for absent dancers - Mark Present & Record Dance
          if (!dancer.isPresent && !isPlanningMode)
            ListTile(
              leading: Icon(Icons.music_note_outlined,
                  color: context.danceTheme.danceAccent),
              title: const Text('Mark Present & Record Dance'),
              subtitle: const Text('Quick combo action'),
              onTap: () => _markPresentAndRecordDance(context),
            ),

          // Record Dance - only available for present dancers in Present mode
          if (!isPlanningMode && dancer.isPresent)
            ListTile(
              leading:
                  Icon(Icons.music_note, color: context.danceTheme.danceAccent),
              title: const Text('Record Dance'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => DanceRecordingDialog(
                    dancerId: dancer.id,
                    eventId: eventId,
                    dancerName: dancer.name,
                  ),
                );
              },
            ),

          // Edit General Notes
          ListTile(
            leading: Icon(Icons.edit_note,
                color: Theme.of(context).colorScheme.primary),
            title: const Text('Edit general note'),
            onTap: () {
              Navigator.pop(context);
              // Convert DancerWithEventInfo to Dancer for editing
              final dancerEntity = Dancer(
                id: dancer.id,
                name: dancer.name,
                notes: dancer.notes,
                createdAt: dancer.createdAt,
              );
              showDialog(
                context: context,
                builder: (context) => AddDancerDialog(dancer: dancerEntity),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Future<void> _togglePresence(BuildContext context) async {
    try {
      final attendanceService =
          Provider.of<AttendanceService>(context, listen: false);

      if (dancer.isPresent) {
        // Remove from present
        await attendanceService.removeFromPresent(eventId, dancer.id);
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${dancer.name} removed from present list'),
              backgroundColor: context.danceTheme.warning,
            ),
          );
        }
      } else {
        // Mark as present
        await attendanceService.markPresent(eventId, dancer.id);
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${dancer.name} marked as present'),
              backgroundColor: context.danceTheme.success,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating presence: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _markPresentAndRecordDance(BuildContext context) async {
    try {
      // First mark as present
      final attendanceService =
          Provider.of<AttendanceService>(context, listen: false);
      await attendanceService.markPresent(eventId, dancer.id);

      if (context.mounted) {
        // Close current dialog
        Navigator.pop(context);

        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${dancer.name} marked as present'),
            duration: const Duration(seconds: 1), // Shorter duration
            backgroundColor: context.danceTheme.success,
          ),
        );

        // Immediately open dance recording dialog
        showDialog(
          context: context,
          builder: (context) => DanceRecordingDialog(
            dancerId: dancer.id,
            eventId: eventId,
            dancerName: dancer.name,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error marking present: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
