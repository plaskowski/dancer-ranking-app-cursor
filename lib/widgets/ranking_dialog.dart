import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/dancer_service.dart';
import '../services/ranking_service.dart';
import '../utils/action_logger.dart';
import '../utils/toast_helper.dart';

class RankingDialog extends StatefulWidget {
  final int dancerId;
  final int eventId;

  const RankingDialog({
    super.key,
    required this.dancerId,
    required this.eventId,
  });

  @override
  State<RankingDialog> createState() => _RankingDialogState();

  static Future<bool?> show(
    BuildContext context, {
    required int dancerId,
    required int eventId,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _RankingDialogContent(
        dancerId: dancerId,
        eventId: eventId,
      ),
    );
  }
}

class _RankingDialogState extends State<RankingDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(); // This widget is not used directly
  }
}

class _RankingDialogContent extends StatefulWidget {
  final int dancerId;
  final int eventId;

  const _RankingDialogContent({
    required this.dancerId,
    required this.eventId,
  });

  @override
  State<_RankingDialogContent> createState() => _RankingDialogContentState();
}

class _RankingDialogContentState extends State<_RankingDialogContent> {
  final _reasonController = TextEditingController();

  List<Rank> _ranks = [];
  Rank? _selectedRank;
  String _dancerName = '';
  bool _isLoading = false;
  DateTime? _lastUpdated;

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
    ActionLogger.logUserAction('RankingDialog', 'loading_data', {
      'dancerId': widget.dancerId,
      'eventId': widget.eventId,
    });

    final rankingService = Provider.of<RankingService>(context, listen: false);
    final dancerService = Provider.of<DancerService>(context, listen: false);

    try {
      // Load active ranks
      final List<Rank> ranks = await rankingService.getActiveRanks();

      // Load dancer name
      final dancer = await dancerService.getDancer(widget.dancerId);

      // Load existing ranking if any
      final existingRanking =
          await rankingService.getRanking(widget.eventId, widget.dancerId);

      // Get all rankings for this event to find archived ranks in use
      final eventRankings =
          await rankingService.getRankingsForEvent(widget.eventId);
      final usedRankIds = eventRankings.map((r) => r.rankId).toSet();

      // Include any archived ranks that are currently used in this event
      final allRanks = await rankingService.getAllRanks();
      final archivedRanksInUse = allRanks
          .where((rank) => rank.isArchived && usedRankIds.contains(rank.id))
          .toList();

      if (archivedRanksInUse.isNotEmpty) {
        ranks.addAll(archivedRanksInUse);
        // Sort by ordinal to maintain proper order
        ranks.sort((a, b) => a.ordinal.compareTo(b.ordinal));
      }

      if (mounted) {
        ActionLogger.logUserAction('RankingDialog', 'data_loaded', {
          'dancerId': widget.dancerId,
          'eventId': widget.eventId,
          'dancerName': dancer?.name ?? 'Unknown',
          'activeRanksCount': (await rankingService.getActiveRanks()).length,
          'archivedRanksInUseCount': archivedRanksInUse.length,
          'totalRanksAvailable': ranks.length,
          'hasExistingRanking': existingRanking != null,
          'existingRankId': existingRanking?.rankId,
        });

        setState(() {
          _ranks = ranks;
          _dancerName = dancer?.name ?? 'Unknown';

          if (existingRanking != null) {
            _selectedRank =
                ranks.firstWhere((r) => r.id == existingRanking.rankId);
            _reasonController.text = existingRanking.reason ?? '';
            _lastUpdated = existingRanking.lastUpdated;
          } else {
            // Default to neutral rank
            _selectedRank = ranks.firstWhere((r) => r.ordinal == 3,
                orElse: () => ranks.first);
          }
        });
      }
    } catch (e) {
      ActionLogger.logError('RankingDialog._loadData', e.toString(), {
        'dancerId': widget.dancerId,
        'eventId': widget.eventId,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error loading data: $e');
      }
    }
  }

  Future<void> _saveRanking() async {
    if (_selectedRank == null) {
      ActionLogger.logUserAction('RankingDialog', 'save_validation_failed', {
        'dancerId': widget.dancerId,
        'eventId': widget.eventId,
        'reason': 'no_rank_selected',
      });
      return;
    }

    ActionLogger.logUserAction('RankingDialog', 'save_ranking_started', {
      'dancerId': widget.dancerId,
      'eventId': widget.eventId,
      'rankId': _selectedRank!.id,
      'rankName': _selectedRank!.name,
      'hasReason': _reasonController.text.trim().isNotEmpty,
      'reasonLength': _reasonController.text.trim().length,
    });

    setState(() {
      _isLoading = true;
    });

    try {
      final rankingService =
          Provider.of<RankingService>(context, listen: false);

      await rankingService.setRanking(
        eventId: widget.eventId,
        dancerId: widget.dancerId,
        rankId: _selectedRank!.id,
        reason: _reasonController.text.trim().isNotEmpty
            ? _reasonController.text.trim()
            : null,
      );

      if (mounted) {
        ActionLogger.logUserAction('RankingDialog', 'save_ranking_completed', {
          'dancerId': widget.dancerId,
          'eventId': widget.eventId,
          'rankId': _selectedRank!.id,
          'rankName': _selectedRank!.name,
          'dancerName': _dancerName,
        });

        Navigator.pop(context, true); // Return true to indicate success
        ToastHelper.showSuccess(context, 'Ranking updated for $_dancerName');
      }
    } catch (e) {
      ActionLogger.logError('RankingDialog._saveRanking', e.toString(), {
        'dancerId': widget.dancerId,
        'eventId': widget.eventId,
        'rankId': _selectedRank?.id,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error saving ranking: $e');
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
                    'Rank $_dancerName',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ActionLogger.logUserAction(
                        'RankingDialog', 'dialog_cancelled', {
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
              'How eager are you to dance with this person?',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            const Text(
              'Rank Options:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Rank options
            ..._ranks.map((rank) => RadioListTile<Rank>(
                  title: Row(
                    children: [
                      Expanded(child: Text(rank.name)),
                      if (rank.isArchived)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'ARCHIVED',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ),
                    ],
                  ),
                  subtitle: rank.isArchived
                      ? Text(
                          'Still in use by this event',
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.outline,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      : null,
                  value: rank,
                  groupValue: _selectedRank,
                  onChanged: (Rank? value) {
                    ActionLogger.logUserAction(
                        'RankingDialog', 'rank_selected', {
                      'dancerId': widget.dancerId,
                      'eventId': widget.eventId,
                      'oldRankId': _selectedRank?.id,
                      'newRankId': value?.id,
                      'newRankName': value?.name,
                      'isArchived': value?.isArchived ?? false,
                    });

                    setState(() {
                      _selectedRank = value;
                    });
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                )),

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
                if (_selectedRank != null) {
                  _saveRanking();
                }
              },
            ),

            const SizedBox(height: 16),

            // Last updated info
            if (_lastUpdated != null)
              Text(
                'Last updated: ${DateFormat('MMM d, y \'at\' h:mm a').format(_lastUpdated!)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),

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
                                'RankingDialog', 'dialog_cancelled', {
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
                    onPressed: _isLoading ? null : _saveRanking,
                    child: _isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Set Ranking'),
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
