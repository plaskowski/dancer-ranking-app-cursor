import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../database/database.dart';
import '../services/ranking_service.dart';
import '../services/dancer_service.dart';
import '../theme/theme_extensions.dart';

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
}

class _RankingDialogState extends State<RankingDialog> {
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
    final rankingService = Provider.of<RankingService>(context, listen: false);
    final dancerService = Provider.of<DancerService>(context, listen: false);

    try {
      // Load ranks
      final ranks = await rankingService.getAllRanks();

      // Load dancer name
      final dancer = await dancerService.getDancer(widget.dancerId);

      // Load existing ranking if any
      final existingRanking =
          await rankingService.getRanking(widget.eventId, widget.dancerId);

      if (mounted) {
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _saveRanking() async {
    if (_selectedRank == null) return;

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
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ranking updated for $_dancerName'),
            backgroundColor: context.danceTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving ranking: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
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
      title: Text('Rank $_dancerName'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  title: Text(rank.name),
                  value: rank,
                  groupValue: _selectedRank,
                  onChanged: (Rank? value) {
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveRanking,
          child: _isLoading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Set Ranking'),
        ),
      ],
    );
  }
}
