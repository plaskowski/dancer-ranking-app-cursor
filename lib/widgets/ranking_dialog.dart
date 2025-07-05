import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/dancer_service.dart';
import '../services/ranking_service.dart';
import '../utils/action_logger.dart';
import '../utils/toast_helper.dart';
import 'simple_selection_dialog.dart';

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
  List<Rank> _ranks = [];
  int? _currentRankId;
  String _dancerName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
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
      final existingRanking = await rankingService.getRanking(widget.eventId, widget.dancerId);

      // Get all rankings for this event to find archived ranks in use
      final eventRankings = await rankingService.getRankingsForEvent(widget.eventId);
      final usedRankIds = eventRankings.map((r) => r.rankId).toSet();

      // Include any archived ranks that are currently used in this event
      final allRanks = await rankingService.getAllRanks();
      final archivedRanksInUse = allRanks.where((rank) => rank.isArchived && usedRankIds.contains(rank.id)).toList();

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
          _currentRankId = existingRanking?.rankId;
          _isLoading = false;
        });
      }
    } catch (e) {
      ActionLogger.logError('RankingDialog._loadData', e.toString(), {
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

  Future<void> _selectRank(Rank rank) async {
    ActionLogger.logUserAction('RankingDialog', 'rank_selected', {
      'dancerId': widget.dancerId,
      'eventId': widget.eventId,
      'rankId': rank.id,
      'rankName': rank.name,
      'previousRankId': _currentRankId,
    });

    try {
      final rankingService = Provider.of<RankingService>(context, listen: false);

      await rankingService.setRanking(
        eventId: widget.eventId,
        dancerId: widget.dancerId,
        rankId: rank.id,
      );

      if (mounted) {
        ActionLogger.logUserAction('RankingDialog', 'rank_saved', {
          'dancerId': widget.dancerId,
          'eventId': widget.eventId,
          'rankId': rank.id,
          'rankName': rank.name,
          'dancerName': _dancerName,
        });

        Navigator.pop(context, true); // Return true to indicate success
        ToastHelper.showSuccess(context, 'Ranking updated for $_dancerName');
      }
    } catch (e) {
      ActionLogger.logError('RankingDialog._selectRank', e.toString(), {
        'dancerId': widget.dancerId,
        'eventId': widget.eventId,
        'rankId': rank.id,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error saving ranking: $e');
      }
    }
  }

  String _getRankDisplayName(Rank rank) {
    if (rank.isArchived) {
      return '${rank.name} (ARCHIVED)';
    }
    return rank.name;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleSelectionDialog<Rank>(
      title: 'Rank $_dancerName',
      items: _ranks,
      itemTitle: _getRankDisplayName,
      isSelected: (rank) => rank.id == _currentRankId,
      onItemSelected: _selectRank,
      isLoading: _isLoading,
      logPrefix: 'RankingDialog',
    );
  }
}
