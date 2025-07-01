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
  Score? _selectedScore;
  String _dancerName = '';
  bool _isLoading = false;
  int? _currentScoreId;

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

          if (currentScoreId != null) {
            _selectedScore = scores.firstWhere(
              (s) => s.id == currentScoreId,
              orElse: () =>
                  scores.firstWhere((s) => s.ordinal == 3), // Default to "Good"
            );
          } else {
            // Default to neutral score (Good - ordinal 3)
            _selectedScore = scores.firstWhere(
              (s) => s.ordinal == 3,
              orElse: () => scores.first,
            );
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
      'previousScoreId': _currentScoreId,
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
        ToastHelper.showSuccess(context, 'Score updated for $_dancerName');
      }
    } catch (e) {
      ActionLogger.logError('ScoreDialog._saveScore', e.toString(), {
        'dancerId': widget.dancerId,
        'eventId': widget.eventId,
        'scoreId': _selectedScore?.id,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error saving score: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _removeScore() async {
    ActionLogger.logUserAction('ScoreDialog', 'remove_score_started', {
      'dancerId': widget.dancerId,
      'eventId': widget.eventId,
      'currentScoreId': _currentScoreId,
    });

    setState(() {
      _isLoading = true;
    });

    try {
      final attendanceService =
          Provider.of<AttendanceService>(context, listen: false);

      await attendanceService.removeScore(widget.eventId, widget.dancerId);

      if (mounted) {
        ActionLogger.logUserAction('ScoreDialog', 'remove_score_completed', {
          'dancerId': widget.dancerId,
          'eventId': widget.eventId,
          'dancerName': _dancerName,
        });

        Navigator.pop(context, true); // Return true to indicate success
        ToastHelper.showSuccess(context, 'Score removed for $_dancerName');
      }
    } catch (e) {
      ActionLogger.logError('ScoreDialog._removeScore', e.toString(), {
        'dancerId': widget.dancerId,
        'eventId': widget.eventId,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error removing score: $e');
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
    return AlertDialog(
      title: Text('Score $_dancerName'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentScoreId != null) ...[
              const Text(
                'Current Score:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(_scores
                  .firstWhere((s) => s.id == _currentScoreId,
                      orElse: () => _scores.first)
                  .name),
              const SizedBox(height: 16),
            ],
            const Text(
              'Select Score:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...(_scores.map((score) {
              return RadioListTile<Score>(
                title: Text(score.name),
                subtitle: Text('Rating: ${score.ordinal}'),
                value: score,
                groupValue: _selectedScore,
                onChanged: _isLoading
                    ? null
                    : (Score? value) {
                        setState(() {
                          _selectedScore = value;
                        });
                      },
              );
            })),
          ],
        ),
      ),
      actions: [
        // Remove Score button (only show if there's a current score)
        if (_currentScoreId != null)
          TextButton(
            onPressed: _isLoading
                ? null
                : () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Remove Score'),
                        content: Text('Remove score for $_dancerName?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Remove'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await _removeScore();
                    }
                  },
            child: const Text('Remove Score'),
          ),

        // Cancel button
        TextButton(
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

        // Save button
        ElevatedButton(
          onPressed: _isLoading ? null : _saveScore,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_currentScoreId != null ? 'Update Score' : 'Assign Score'),
        ),
      ],
    );
  }
}
