import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/attendance_service.dart';
import '../services/dancer_service.dart';
import '../services/ranking_service.dart';
import '../theme/theme_extensions.dart';
import '../utils/action_logger.dart';
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
    ActionLogger.logUserAction('DancerActionsDialog', 'dialog_opened', {
      'dancerId': dancer.id,
      'dancerName': dancer.name,
      'eventId': eventId,
      'isPlanningMode': isPlanningMode,
      'dancerStatus': dancer.status,
      'isPresent': dancer.isPresent,
      'hasRanking': dancer.hasRanking,
    });

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
              ActionLogger.logUserAction(
                  'DancerActionsDialog', 'ranking_action_tapped', {
                'dancerId': dancer.id,
                'eventId': eventId,
                'hasExistingRanking': dancer.hasRanking,
                'currentRank': dancer.rankName,
              });

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

          // Mark Present / Mark absent
          ListTile(
            leading: Icon(
              dancer.isPresent ? Icons.location_off : Icons.location_on,
              color: dancer.isPresent
                  ? context.danceTheme.absent
                  : context.danceTheme.present,
            ),
            title: Text(dancer.isPresent ? 'Mark absent' : 'Mark Present'),
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

          // Record Dance / Edit impression - only available for present dancers in Present mode
          if (!isPlanningMode && dancer.isPresent)
            ListTile(
              leading:
                  Icon(Icons.music_note, color: context.danceTheme.danceAccent),
              title:
                  Text(dancer.hasDanced ? 'Edit impression' : 'Record Dance'),
              onTap: () {
                ActionLogger.logUserAction(
                    'DancerActionsDialog', 'record_dance_tapped', {
                  'dancerId': dancer.id,
                  'eventId': eventId,
                  'hasAlreadyDanced': dancer.hasDanced,
                });

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
              ActionLogger.logUserAction(
                  'DancerActionsDialog', 'edit_notes_tapped', {
                'dancerId': dancer.id,
                'eventId': eventId,
              });

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

          // Mark as Left - only show for present dancers who haven't danced yet
          if (dancer.isPresent && !dancer.hasDanced)
            ListTile(
              leading:
                  Icon(Icons.exit_to_app, color: context.danceTheme.warning),
              title: const Text('Mark as left'),
              onTap: () => _markAsLeft(context),
            ),

          // Remove from Event - only show for ranked dancers in Planning mode
          if (dancer.hasRanking && isPlanningMode)
            ListTile(
              leading: Icon(Icons.remove_circle_outline,
                  color: context.danceTheme.warning),
              title: const Text('Remove from event'),
              onTap: () => _removeFromPlanning(context),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            ActionLogger.logUserAction(
                'DancerActionsDialog', 'dialog_cancelled', {
              'dancerId': dancer.id,
              'eventId': eventId,
            });
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Future<void> _togglePresence(BuildContext context) async {
    ActionLogger.logUserAction(
        'DancerActionsDialog', 'toggle_presence_started', {
      'dancerId': dancer.id,
      'eventId': eventId,
      'currentlyPresent': dancer.isPresent,
      'action': dancer.isPresent ? 'mark_absent' : 'mark_present',
    });

    try {
      final attendanceService =
          Provider.of<AttendanceService>(context, listen: false);

      if (dancer.isPresent) {
        // Mark as absent
        await attendanceService.removeFromPresent(eventId, dancer.id);
        if (context.mounted) {
          ActionLogger.logUserAction(
              'DancerActionsDialog', 'mark_absent_completed', {
            'dancerId': dancer.id,
            'eventId': eventId,
          });

          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${dancer.name} marked as absent'),
              backgroundColor: context.danceTheme.warning,
            ),
          );
        }
      } else {
        // Mark as present
        await attendanceService.markPresent(eventId, dancer.id);
        if (context.mounted) {
          ActionLogger.logUserAction(
              'DancerActionsDialog', 'mark_present_completed', {
            'dancerId': dancer.id,
            'eventId': eventId,
          });

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
      ActionLogger.logError(
          'DancerActionsDialog._togglePresence', e.toString(), {
        'dancerId': dancer.id,
        'eventId': eventId,
        'action': dancer.isPresent ? 'mark_absent' : 'mark_present',
      });

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
    ActionLogger.logUserAction('DancerActionsDialog', 'combo_action_started', {
      'dancerId': dancer.id,
      'eventId': eventId,
      'action': 'mark_present_and_record_dance',
    });

    try {
      final attendanceService =
          Provider.of<AttendanceService>(context, listen: false);

      // Mark as present and record dance
      await attendanceService.recordDance(
        eventId: eventId,
        dancerId: dancer.id,
      );

      if (context.mounted) {
        ActionLogger.logUserAction(
            'DancerActionsDialog', 'combo_action_completed', {
          'dancerId': dancer.id,
          'eventId': eventId,
        });

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${dancer.name} marked present and dance recorded'),
            backgroundColor: context.danceTheme.success,
          ),
        );
      }
    } catch (e) {
      ActionLogger.logError(
          'DancerActionsDialog._markPresentAndRecordDance', e.toString(), {
        'dancerId': dancer.id,
        'eventId': eventId,
      });

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error recording dance: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _removeFromPlanning(BuildContext context) async {
    ActionLogger.logUserAction(
        'DancerActionsDialog', 'remove_from_planning_started', {
      'dancerId': dancer.id,
      'eventId': eventId,
      'currentRank': dancer.rankName,
    });

    try {
      final rankingService =
          Provider.of<RankingService>(context, listen: false);

      // Remove the ranking for this dancer from this event
      await rankingService.deleteRanking(eventId, dancer.id);

      if (context.mounted) {
        ActionLogger.logUserAction(
            'DancerActionsDialog', 'remove_from_planning_completed', {
          'dancerId': dancer.id,
          'eventId': eventId,
        });

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${dancer.name} removed from event'),
            backgroundColor: context.danceTheme.warning,
          ),
        );
      }
    } catch (e) {
      ActionLogger.logError(
          'DancerActionsDialog._removeFromPlanning', e.toString(), {
        'dancerId': dancer.id,
        'eventId': eventId,
      });

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing from planning: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _markAsLeft(BuildContext context) async {
    ActionLogger.logUserAction('DancerActionsDialog', 'mark_as_left_started', {
      'dancerId': dancer.id,
      'eventId': eventId,
      'currentStatus': dancer.status,
    });

    try {
      final attendanceService =
          Provider.of<AttendanceService>(context, listen: false);

      // Mark the dancer as left
      await attendanceService.markAsLeft(eventId, dancer.id);

      if (context.mounted) {
        ActionLogger.logUserAction(
            'DancerActionsDialog', 'mark_as_left_completed', {
          'dancerId': dancer.id,
          'eventId': eventId,
        });

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${dancer.name} marked as left'),
            backgroundColor: context.danceTheme.warning,
          ),
        );
      }
    } catch (e) {
      ActionLogger.logError('DancerActionsDialog._markAsLeft', e.toString(), {
        'dancerId': dancer.id,
        'eventId': eventId,
      });

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error marking as left: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
