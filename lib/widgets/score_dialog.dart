import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/attendance_service.dart';
import '../services/dancer_service.dart';
import '../services/score_service.dart';
import '../utils/action_logger.dart';
import '../utils/toast_helper.dart';

class ScoreDialog extends StatefulWidget {
  final int dancerId;
  final int eventId;

  const ScoreDialog({
    super.key,
    required this.dancerId,
    required this.eventId,
  });

  @override
  State<ScoreDialog> createState() => _ScoreDialogState();

  static Future<bool?> show(
    BuildContext context, {
    required int dancerId,
    required int eventId,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ScoreDialogContent(
        dancerId: dancerId,
        eventId: eventId,
      ),
    );
  }
}

class _ScoreDialogState extends State<ScoreDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(); // This widget is not used directly
  }
}

class _ScoreDialogContent extends StatefulWidget {
  final int dancerId;
  final int eventId;

  const _ScoreDialogContent({
    required this.dancerId,
    required this.eventId,
  });

  @override
  State<_ScoreDialogContent> createState() => _ScoreDialogContentState();
}

class _ScoreDialogContentState extends State<_ScoreDialogContent> {
  List<Score> _scores = [];
  Score? _selectedScore;
  String _dancerName = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    ActionLogger.logUserAction('ScoreDialog', 'dialog_opened', {
      'dancerId': widget.dancerId,
      'eventId': widget.eventId,
    });

    _loadData();
  }

  Future<void> _loadData() async {
    ActionLogger.logUserAction('ScoreDialog', 'loading_data', {
      'dancerId': widget.dancerId,
      'eventId': widget.eventId,
    });

    final scoreService = Provider.of<ScoreService>(context, listen: false);
    final dancerService = Provider.of<DancerService>(context, listen: false);
    final attendanceService =
        Provider.of<AttendanceService>(context, listen: false);

    try {
      // Load active scores
      final List<Score> scores = await scoreService.getActiveScores();

      // Load dancer name
      final dancer = await dancerService.getDancer(widget.dancerId);

      // Load existing score if any
      final currentScoreId = await attendanceService.getAttendanceScore(
          widget.eventId, widget.dancerId);

      if (mounted) {
        ActionLogger.logUserAction('ScoreDialog', 'data_loaded', {
          'dancerId': widget.dancerId,
          'eventId': widget.eventId,
          'dancerName': dancer?.name ?? 'Unknown',
          'activeScoresCount': scores.length,
          'hasExistingScore': currentScoreId != null,
          'existingScoreId': currentScoreId,
        });

        setState(() {
          _scores = scores;
          _dancerName = dancer?.name ?? 'Unknown';

          if (currentScoreId != null) {
            _selectedScore = scores.firstWhere((s) => s.id == currentScoreId);
          } else {
            // Default to first score if no current score
            _selectedScore = scores.isNotEmpty ? scores.first : null;
          }
        });
      }
    } catch (e) {
      ActionLogger.logError('ScoreDialog._loadData', e.toString(), {
        'dancerId': widget.dancerId,
        'eventId': widget.eventId,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error loading data: $e');
      }
    }
  }

  Future<void> _saveScore() async {
    if (_selectedScore == null) {
      ActionLogger.logUserAction('ScoreDialog', 'save_validation_failed', {
        'dancerId': widget.dancerId,
        'eventId': widget.eventId,
        'reason': 'no_score_selected',
      });
      return;
    }

    ActionLogger.logUserAction('ScoreDialog', 'save_score_started', {
      'dancerId': widget.dancerId,
      'eventId': widget.eventId,
      'scoreId': _selectedScore!.id,
      'scoreName': _selectedScore!.name,
    });

    setState(() {
      _isLoading = true;
    });

    try {
      final attendanceService =
          Provider.of<AttendanceService>(context, listen: false);

      await attendanceService.assignScore(
        widget.eventId,
        widget.dancerId,
        _selectedScore!.id,
      );

      if (mounted) {
        ActionLogger.logUserAction('ScoreDialog', 'save_score_completed', {
          'dancerId': widget.dancerId,
          'eventId': widget.eventId,
          'scoreId': _selectedScore!.id,
          'scoreName': _selectedScore!.name,
          'dancerName': _dancerName,
        });

        Navigator.pop(context, true); // Return true to indicate success
        ToastHelper.showSuccess(
            context, 'Score "${_selectedScore!.name}" set for $_dancerName');
      }
    } catch (e) {
      ActionLogger.logError('ScoreDialog._saveScore', e.toString(), {
        'dancerId': widget.dancerId,
        'eventId': widget.eventId,
        'scoreId': _selectedScore?.id,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error setting score: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Score $_dancerName',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ActionLogger.logUserAction(
                        'ScoreDialog', 'dialog_cancelled', {
                      'dancerId': widget.dancerId,
                      'eventId': widget.eventId,
                    });
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              'How was your dance with this person?',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            const Text(
              'Score Options:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Score options
            ..._scores.map((score) => RadioListTile<Score>(
                  title: Text(score.name),
                  value: score,
                  groupValue: _selectedScore,
                  onChanged: (Score? value) {
                    ActionLogger.logUserAction(
                        'ScoreDialog', 'score_selected', {
                      'dancerId': widget.dancerId,
                      'eventId': widget.eventId,
                      'oldScoreId': _selectedScore?.id,
                      'newScoreId': value?.id,
                      'newScoreName': value?.name,
                    });

                    setState(() {
                      _selectedScore = value;
                    });
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                )),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            ActionLogger.logUserAction(
                                'ScoreDialog', 'dialog_cancelled', {
                              'dancerId': widget.dancerId,
                              'eventId': widget.eventId,
                            });
                            Navigator.pop(context);
                          },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveScore,
                    child: _isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Set Score'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
