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
}

class _ScoreDialogState extends State<ScoreDialog> {
  List<Score> _scores = [];
  int? _currentScoreId;
  String _dancerName = '';
  bool _isLoading = true;

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
          _currentScoreId = currentScoreId;
          _isLoading = false;
        });
      }
    } catch (e) {
      ActionLogger.logError('ScoreDialog._loadData', e.toString(), {
        'dancerId': widget.dancerId,
        'eventId': widget.eventId,
      });

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ToastHelper.showError(context, 'Error loading data: $e');
      }
    }
  }

  Future<void> _selectScore(Score score) async {
    ActionLogger.logUserAction('ScoreDialog', 'score_selected', {
      'dancerId': widget.dancerId,
      'eventId': widget.eventId,
      'scoreId': score.id,
      'scoreName': score.name,
      'previousScoreId': _currentScoreId,
    });

    try {
      final attendanceService =
          Provider.of<AttendanceService>(context, listen: false);

      await attendanceService.assignScore(
        widget.eventId,
        widget.dancerId,
        score.id,
      );

      if (mounted) {
        ActionLogger.logUserAction('ScoreDialog', 'score_assigned', {
          'dancerId': widget.dancerId,
          'eventId': widget.eventId,
          'scoreId': score.id,
          'scoreName': score.name,
          'dancerName': _dancerName,
        });

        Navigator.pop(context, true); // Return true to indicate success
        ToastHelper.showSuccess(
            context, 'Score "${score.name}" set for $_dancerName');
      }
    } catch (e) {
      ActionLogger.logError('ScoreDialog._selectScore', e.toString(), {
        'dancerId': widget.dancerId,
        'eventId': widget.eventId,
        'scoreId': score.id,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error setting score: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_dancerName),
      content: _isLoading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 300, // Limit height to prevent overflow
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _scores.map((score) {
                        final isCurrentScore = score.id == _currentScoreId;

                        return ListTile(
                          leading: Icon(
                            isCurrentScore
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: isCurrentScore
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                          ),
                          title: Text(
                            score.name,
                            style: TextStyle(
                              fontWeight: isCurrentScore
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          onTap: () => _selectScore(score),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () {
            ActionLogger.logUserAction('ScoreDialog', 'dialog_cancelled', {
              'dancerId': widget.dancerId,
              'eventId': widget.eventId,
            });
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
