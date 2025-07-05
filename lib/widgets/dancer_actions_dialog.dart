import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../screens/dancer_history_screen.dart';
import '../services/attendance_service.dart';
import '../services/dancer_service.dart';
import '../services/event_service.dart';
import '../services/ranking_service.dart';
import '../theme/theme_extensions.dart';
import '../utils/action_logger.dart';
import '../utils/event_status_helper.dart';
import '../utils/toast_helper.dart';
import 'add_dancer_dialog.dart';
import 'dance_recording_dialog.dart';
import 'ranking_dialog.dart';
import 'ranking_reason_dialog.dart';
import 'score_dialog.dart';

class DancerActionsDialog extends StatefulWidget {
  final DancerWithEventInfo dancer;
  final int eventId;
  final bool isPlanningMode;
  final bool isSummaryMode;

  const DancerActionsDialog({
    super.key,
    required this.dancer,
    required this.eventId,
    required this.isPlanningMode,
    this.isSummaryMode = false,
  });

  @override
  State<DancerActionsDialog> createState() => _DancerActionsDialogState();
}

class _DancerActionsDialogState extends State<DancerActionsDialog> {
  Event? _event;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    try {
      final eventService = Provider.of<EventService>(context, listen: false);
      final event = await eventService.getEvent(widget.eventId);
      if (mounted) {
        setState(() {
          _event = event;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPastEvent = _event != null && EventStatusHelper.isPastEvent(_event!.date);

    ActionLogger.logUserAction('DancerActionsDialog', 'dialog_opened', {
      'dancerId': widget.dancer.id,
      'dancerName': widget.dancer.name,
      'eventId': widget.eventId,
      'isPlanningMode': widget.isPlanningMode,
      'dancerStatus': widget.dancer.status,
      'isPresent': widget.dancer.isPresent,
      'hasRanking': widget.dancer.hasRanking,
      'isPastEvent': isPastEvent,
    });

    if (_isLoading) {
      return const AlertDialog(
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return AlertDialog(
      title: Text(widget.dancer.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ranking actions (available in planning and present modes, but not for past events or summary tab)
          if (!isPastEvent && !widget.isSummaryMode) ...[
            // Set Ranking action
            ListTile(
              leading: Icon(
                widget.dancer.hasRanking ? Icons.edit : Icons.add,
                color: context.danceTheme.rankingHigh,
              ),
              title: Text(widget.dancer.hasRanking ? 'Change Ranking' : 'Set Ranking'),
              onTap: () {
                ActionLogger.logUserAction('DancerActionsDialog', 'set_ranking_tapped', {
                  'dancerId': widget.dancer.id,
                  'eventId': widget.eventId,
                  'hasExistingRanking': widget.dancer.hasRanking,
                  'currentRank': widget.dancer.rankName,
                });

                RankingDialog.show(
                  context,
                  dancerId: widget.dancer.id,
                  eventId: widget.eventId,
                ).then((updated) {
                  if (updated == true && context.mounted) {
                    Navigator.pop(context); // Close the action dialog
                  }
                });
              },
            ),

            // Edit Ranking Reason action (only show if dancer has a ranking)
            if (widget.dancer.hasRanking)
              ListTile(
                leading: Icon(
                  Icons.edit_note,
                  color: context.danceTheme.rankingHigh,
                ),
                title: const Text('Edit Ranking Reason'),
                onTap: () {
                  ActionLogger.logUserAction('DancerActionsDialog', 'edit_ranking_reason_tapped', {
                    'dancerId': widget.dancer.id,
                    'eventId': widget.eventId,
                    'currentRank': widget.dancer.rankName,
                    'hasExistingReason': widget.dancer.rankingReason != null,
                  });

                  RankingReasonDialog.show(
                    context,
                    dancerId: widget.dancer.id,
                    eventId: widget.eventId,
                  ).then((updated) {
                    if (updated == true && context.mounted) {
                      Navigator.pop(context); // Close the action dialog
                    }
                  });
                },
              ),
          ],

          // Score actions (only for present mode and attendants)
          if (!widget.isPlanningMode && widget.dancer.isPresent)
            ListTile(
              leading: Icon(
                widget.dancer.hasScore ? Icons.star : Icons.star_outline,
                color: context.danceTheme.danceAccent,
              ),
              title: Text(widget.dancer.hasScore ? 'Edit Score' : 'Assign Score'),
              onTap: () {
                ActionLogger.logUserAction('DancerActionsDialog', 'score_action_tapped', {
                  'dancerId': widget.dancer.id,
                  'eventId': widget.eventId,
                  'hasExistingScore': widget.dancer.hasScore,
                  'currentScore': widget.dancer.scoreName,
                });

                showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => ScoreDialog(
                    dancerId: widget.dancer.id,
                    eventId: widget.eventId,
                  ),
                ).then((updated) {
                  if (updated == true && context.mounted) {
                    Navigator.pop(context); // Close the action dialog
                  }
                });
              },
            ),

          // Presence toggle - hide for past events
          if (!isPastEvent)
            ListTile(
              leading: Icon(
                widget.dancer.isPresent ? Icons.location_off : Icons.location_on,
                color: widget.dancer.isPresent ? context.danceTheme.absent : context.danceTheme.present,
              ),
              title: Text(widget.dancer.isPresent ? 'Mark absent' : 'Mark Present'),
              onTap: () => _togglePresence(context),
            ),

          // Combined action for absent dancers - Mark Present & Record Dance
          if (!widget.dancer.isPresent && !widget.isPlanningMode)
            ListTile(
              leading: Icon(Icons.music_note_outlined, color: context.danceTheme.danceAccent),
              title: const Text('Mark Present & Record Dance'),
              subtitle: const Text('Quick combo action'),
              onTap: () => _markPresentAndRecordDance(context),
            ),

          // Record Dance / Edit impression - only available for present dancers in Present mode
          if (!widget.isPlanningMode && widget.dancer.isPresent)
            ListTile(
              leading: Icon(Icons.music_note, color: context.danceTheme.danceAccent),
              title: Text(widget.dancer.hasDanced ? 'Edit impression' : 'Record Dance'),
              onTap: () {
                ActionLogger.logUserAction('DancerActionsDialog', 'record_dance_tapped', {
                  'dancerId': widget.dancer.id,
                  'eventId': widget.eventId,
                  'hasAlreadyDanced': widget.dancer.hasDanced,
                });

                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => DanceRecordingDialog(
                    dancerId: widget.dancer.id,
                    eventId: widget.eventId,
                    dancerName: widget.dancer.name,
                  ),
                );
              },
            ),

          // View History
          ListTile(
            leading: Icon(Icons.history, color: Theme.of(context).colorScheme.onSurfaceVariant),
            title: const Text('View History'),
            onTap: () {
              ActionLogger.logUserAction('DancerActionsDialog', 'view_history_tapped', {
                'dancerId': widget.dancer.id,
                'eventId': widget.eventId,
              });

              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DancerHistoryScreen(
                  dancerId: widget.dancer.id,
                  dancerName: widget.dancer.name,
                ),
              ));
            },
          ),

          // Edit General Notes
          ListTile(
            leading: Icon(Icons.edit_note, color: Theme.of(context).colorScheme.primary),
            title: const Text('Edit the dancer'),
            onTap: () async {
              ActionLogger.logUserAction('DancerActionsDialog', 'edit_notes_tapped', {
                'dancerId': widget.dancer.id,
                'eventId': widget.eventId,
              });

              Navigator.pop(context);
              // Convert DancerWithEventInfo to Dancer for editing
              final dancerEntity = Dancer(
                id: widget.dancer.id,
                name: widget.dancer.name,
                notes: widget.dancer.notes,
                createdAt: widget.dancer.createdAt,
                firstMetDate: widget.dancer.firstMetDate,
                isArchived: false, // Default to not archived
              );
              showDialog(
                context: context,
                builder: (context) => AddDancerDialog(dancer: dancerEntity),
              );
            },
          ),

          // Mark as Left - only show for present dancers who haven't danced yet and not for past events
          if (!isPastEvent && widget.dancer.isPresent && !widget.dancer.hasDanced)
            ListTile(
              leading: Icon(Icons.exit_to_app, color: context.danceTheme.warning),
              title: const Text('Mark as Left'),
              onTap: () => _markAsLeft(context),
            ),

          // Remove from Event action (only available in planning mode for ranked dancers)
          if (widget.isPlanningMode && widget.dancer.hasRanking && !isPastEvent)
            ListTile(
              leading: Icon(
                Icons.remove_circle_outline,
                color: context.danceTheme.warning,
              ),
              title: const Text('Remove from Event'),
              onTap: () => _removeFromEvent(context),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            ActionLogger.logUserAction('DancerActionsDialog', 'dialog_cancelled', {
              'dancerId': widget.dancer.id,
              'eventId': widget.eventId,
            });
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  Future<void> _togglePresence(BuildContext context) async {
    ActionLogger.logUserAction('DancerActionsDialog', 'toggle_presence_started', {
      'dancerId': widget.dancer.id,
      'eventId': widget.eventId,
      'currentlyPresent': widget.dancer.isPresent,
      'action': widget.dancer.isPresent ? 'mark_absent' : 'mark_present',
    });

    try {
      final attendanceService = Provider.of<AttendanceService>(context, listen: false);

      if (widget.dancer.isPresent) {
        // Mark as absent
        await attendanceService.removeFromPresent(widget.eventId, widget.dancer.id);
        if (context.mounted) {
          ActionLogger.logUserAction('DancerActionsDialog', 'mark_absent_completed', {
            'dancerId': widget.dancer.id,
            'eventId': widget.eventId,
          });

          Navigator.pop(context);
          ToastHelper.showSuccess(context, '${widget.dancer.name} marked as absent');
        }
      } else {
        // Mark as present
        await attendanceService.markPresent(widget.eventId, widget.dancer.id);
        if (context.mounted) {
          ActionLogger.logUserAction('DancerActionsDialog', 'mark_present_completed', {
            'dancerId': widget.dancer.id,
            'eventId': widget.eventId,
          });

          Navigator.pop(context);
          ToastHelper.showSuccess(context, '${widget.dancer.name} marked as present');
        }
      }
    } catch (e) {
      ActionLogger.logError('DancerActionsDialog._togglePresence', e.toString(), {
        'dancerId': widget.dancer.id,
        'eventId': widget.eventId,
        'action': widget.dancer.isPresent ? 'mark_absent' : 'mark_present',
      });

      if (context.mounted) {
        Navigator.pop(context);
        ToastHelper.showError(context, 'Error updating presence: $e');
      }
    }
  }

  Future<void> _markPresentAndRecordDance(BuildContext context) async {
    ActionLogger.logUserAction('DancerActionsDialog', 'combo_action_started', {
      'dancerId': widget.dancer.id,
      'eventId': widget.eventId,
      'action': 'mark_present_and_record_dance',
    });

    try {
      final attendanceService = Provider.of<AttendanceService>(context, listen: false);

      // Mark as present and record dance
      await attendanceService.recordDance(
        eventId: widget.eventId,
        dancerId: widget.dancer.id,
      );

      if (context.mounted) {
        ActionLogger.logUserAction('DancerActionsDialog', 'combo_action_completed', {
          'dancerId': widget.dancer.id,
          'eventId': widget.eventId,
        });

        Navigator.pop(context);
        ToastHelper.showSuccess(context, '${widget.dancer.name} marked present and dance recorded');
      }
    } catch (e) {
      ActionLogger.logError('DancerActionsDialog._markPresentAndRecordDance', e.toString(), {
        'dancerId': widget.dancer.id,
        'eventId': widget.eventId,
      });

      if (context.mounted) {
        Navigator.pop(context);
        ToastHelper.showError(context, 'Error recording dance: $e');
      }
    }
  }

  Future<void> _markAsLeft(BuildContext context) async {
    ActionLogger.logUserAction('DancerActionsDialog', 'mark_as_left_started', {
      'dancerId': widget.dancer.id,
      'eventId': widget.eventId,
      'currentStatus': widget.dancer.status,
    });

    try {
      final attendanceService = Provider.of<AttendanceService>(context, listen: false);

      // Mark the dancer as left
      await attendanceService.markAsLeft(widget.eventId, widget.dancer.id);

      if (context.mounted) {
        ActionLogger.logUserAction('DancerActionsDialog', 'mark_as_left_completed', {
          'dancerId': widget.dancer.id,
          'eventId': widget.eventId,
        });

        Navigator.pop(context);
        ToastHelper.showSuccess(context, '${widget.dancer.name} marked as left');
      }
    } catch (e) {
      ActionLogger.logError('DancerActionsDialog._markAsLeft', e.toString(), {
        'dancerId': widget.dancer.id,
        'eventId': widget.eventId,
      });

      if (context.mounted) {
        Navigator.pop(context);
        ToastHelper.showError(context, 'Error marking as left: $e');
      }
    }
  }

  Future<void> _removeFromEvent(BuildContext context) async {
    ActionLogger.logUserAction('DancerActionsDialog', 'remove_from_event_started', {
      'dancerId': widget.dancer.id,
      'eventId': widget.eventId,
      'dancerName': widget.dancer.name,
    });

    try {
      final rankingService = Provider.of<RankingService>(context, listen: false);
      await rankingService.deleteRanking(widget.eventId, widget.dancer.id);

      ActionLogger.logUserAction('DancerActionsDialog', 'remove_from_event_success', {
        'dancerId': widget.dancer.id,
        'eventId': widget.eventId,
        'dancerName': widget.dancer.name,
      });

      if (context.mounted) {
        Navigator.pop(context);
        ToastHelper.showSuccess(context, 'Removed ${widget.dancer.name} from event');
      }
    } catch (e) {
      ActionLogger.logError('DancerActionsDialog._removeFromEvent', e.toString(), {
        'dancerId': widget.dancer.id,
        'eventId': widget.eventId,
        'dancerName': widget.dancer.name,
      });

      if (context.mounted) {
        Navigator.pop(context);
        ToastHelper.showError(context, 'Failed to remove from event: $e');
      }
    }
  }
}
