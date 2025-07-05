import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/dancer_service.dart';
import '../services/ranking_service.dart';
import '../utils/action_logger.dart';
import '../utils/toast_helper.dart';

class RankingReasonDialog extends StatefulWidget {
  final int dancerId;
  final int eventId;

  const RankingReasonDialog({
    super.key,
    required this.dancerId,
    required this.eventId,
  });

  @override
  State<RankingReasonDialog> createState() => _RankingReasonDialogState();

  static Future<bool?> show(
    BuildContext context, {
    required int dancerId,
    required int eventId,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _RankingReasonDialogContent(
        dancerId: dancerId,
        eventId: eventId,
      ),
    );
  }
}

class _RankingReasonDialogState extends State<RankingReasonDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(); // This widget is not used directly
  }
}

class _RankingReasonDialogContent extends StatefulWidget {
  final int dancerId;
  final int eventId;

  const _RankingReasonDialogContent({
    required this.dancerId,
    required this.eventId,
  });

  @override
  State<_RankingReasonDialogContent> createState() => _RankingReasonDialogContentState();
}

class _RankingReasonDialogContentState extends State<_RankingReasonDialogContent> {
  final _reasonController = TextEditingController();
  String _dancerName = '';
  String? _currentRankName;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    ActionLogger.logUserAction('RankingReasonDialog', 'loading_data', {
      'dancerId': widget.dancerId,
      'eventId': widget.eventId,
    });

    final rankingService = Provider.of<RankingService>(context, listen: false);
    final dancerService = Provider.of<DancerService>(context, listen: false);

    try {
      // Load dancer name
      final dancer = await dancerService.getDancer(widget.dancerId);

      // Load existing ranking if any
      final existingRanking = await rankingService.getRanking(widget.eventId, widget.dancerId);

      if (mounted) {
        ActionLogger.logUserAction('RankingReasonDialog', 'data_loaded', {
          'dancerId': widget.dancerId,
          'eventId': widget.eventId,
          'dancerName': dancer?.name ?? 'Unknown',
          'hasExistingRanking': existingRanking != null,
          'existingRankId': existingRanking?.rankId,
          'hasExistingReason': existingRanking?.reason != null,
        });

        setState(() {
          _dancerName = dancer?.name ?? 'Unknown';

          if (existingRanking != null) {
            _reasonController.text = existingRanking.reason ?? '';
          }
        });

        // Get rank name for display if there's an existing ranking
        if (existingRanking != null) {
          final allRanks = await rankingService.getAllRanks();
          final rank = allRanks.firstWhere(
            (r) => r.id == existingRanking.rankId,
            orElse: () => Rank(
                id: 0,
                name: 'Unknown',
                ordinal: 0,
                isArchived: false,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now()),
          );

          if (mounted) {
            setState(() {
              _currentRankName = rank.name;
            });
          }
        }
      }
    } catch (e) {
      ActionLogger.logError('RankingReasonDialog._loadData', e.toString(), {
        'dancerId': widget.dancerId,
        'eventId': widget.eventId,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error loading data: $e');
      }
    }
  }

  Future<void> _saveReason() async {
    ActionLogger.logUserAction('RankingReasonDialog', 'save_reason_started', {
      'dancerId': widget.dancerId,
      'eventId': widget.eventId,
      'reasonLength': _reasonController.text.trim().length,
    });

    setState(() {
      _isLoading = true;
    });

    try {
      final rankingService = Provider.of<RankingService>(context, listen: false);

      // Get existing ranking to preserve the rank
      final existingRanking = await rankingService.getRanking(widget.eventId, widget.dancerId);

      if (existingRanking != null) {
        await rankingService.setRanking(
          eventId: widget.eventId,
          dancerId: widget.dancerId,
          rankId: existingRanking.rankId,
          reason: _reasonController.text.trim().isNotEmpty ? _reasonController.text.trim() : null,
        );

        if (mounted) {
          ActionLogger.logUserAction('RankingReasonDialog', 'save_reason_completed', {
            'dancerId': widget.dancerId,
            'eventId': widget.eventId,
            'dancerName': _dancerName,
            'hasReason': _reasonController.text.trim().isNotEmpty,
          });

          Navigator.pop(context, true); // Return true to indicate success
          ToastHelper.showSuccess(context, 'Reason updated for $_dancerName');
        }
      } else {
        if (mounted) {
          ToastHelper.showError(context, 'No ranking found for this dancer');
        }
      }
    } catch (e) {
      ActionLogger.logError('RankingReasonDialog._saveReason', e.toString(), {
        'dancerId': widget.dancerId,
        'eventId': widget.eventId,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error saving reason: $e');
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
                    'Edit Reason for $_dancerName',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ActionLogger.logUserAction('RankingReasonDialog', 'dialog_cancelled', {
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

            if (_currentRankName != null) ...[
              Text(
                'Current rank: $_currentRankName',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
            ],

            const Text(
              'Add a reason for this ranking (optional):',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            // Reason field
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason (optional)',
                border: OutlineInputBorder(),
                hintText: 'e.g., Looking amazing tonight!',
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                _saveReason();
              },
            ),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            ActionLogger.logUserAction('RankingReasonDialog', 'dialog_cancelled', {
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
                    onPressed: _isLoading ? null : _saveReason,
                    child: _isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Reason'),
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
