import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/dancer_service.dart';
import '../services/attendance_service.dart';
import '../database/database.dart';
import 'ranking_dialog.dart';
import 'dance_recording_dialog.dart';
import 'add_dancer_dialog.dart';

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
            leading: const Icon(Icons.star, color: Colors.orange),
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
              color: dancer.isPresent ? Colors.red : Colors.green,
            ),
            title:
                Text(dancer.isPresent ? 'Remove from Present' : 'Mark Present'),
            onTap: () => _togglePresence(context),
          ),

          // Record Dance - only available in Present mode
          if (!isPlanningMode)
            ListTile(
              leading: const Icon(Icons.music_note, color: Colors.purple),
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

          // Edit Notes
          ListTile(
            leading: const Icon(Icons.edit_note, color: Colors.blue),
            title: const Text('Edit Notes'),
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
              backgroundColor: Colors.orange,
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
              backgroundColor: Colors.green,
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
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
