import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/database.dart';
import '../../../services/ranking_service.dart';
import '../../../utils/action_logger.dart';
import '../../../utils/toast_helper.dart';
import '../../../widgets/safe_fab.dart';
import '../widgets/rank_card.dart';

class RanksManagementTab extends StatefulWidget {
  const RanksManagementTab({super.key});

  @override
  State<RanksManagementTab> createState() => _RanksManagementTabState();
}

class _RanksManagementTabState extends State<RanksManagementTab> {
  @override
  Widget build(BuildContext context) {
    final rankingService = Provider.of<RankingService>(context);

    return Scaffold(
      body: FutureBuilder<List<RankWithUsage>>(
        future: rankingService.getAllRanksWithUsage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final ranksWithUsage = snapshot.data ?? [];

          if (ranksWithUsage.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No ranks available.\nTap + to add your first rank.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          return ReorderableListView.builder(
            padding:
                const EdgeInsets.only(bottom: 80, left: 16, right: 16, top: 16),
            itemCount: ranksWithUsage.length,
            onReorder: (oldIndex, newIndex) =>
                _reorderRanks(ranksWithUsage, oldIndex, newIndex),
            itemBuilder: (context, index) {
              final rankWithUsage = ranksWithUsage[index];
              return RankCard(
                key: ValueKey(rankWithUsage.rank.id),
                rankWithUsage: rankWithUsage,
                index: index,
                onEdit: () => _showEditRankDialog(context, rankWithUsage.rank),
                onArchive: () =>
                    _showArchiveRankDialog(context, rankWithUsage.rank),
                onDelete: () =>
                    _showDeleteRankDialog(context, rankWithUsage.rank),
              );
            },
          );
        },
      ),
      floatingActionButton: SafeFAB(
        onPressed: () => _showAddRankDialog(context),
        tooltip: 'Add New Rank',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _reorderRanks(
      List<RankWithUsage> ranksWithUsage, int oldIndex, int newIndex) {
    ActionLogger.logUserAction('RanksManagementTab', 'reorder_ranks', {
      'oldIndex': oldIndex,
      'newIndex': newIndex,
      'rankId': ranksWithUsage[oldIndex].rank.id,
    });

    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final rankWithUsage = ranksWithUsage.removeAt(oldIndex);
      ranksWithUsage.insert(newIndex, rankWithUsage);
    });

    final ranks = ranksWithUsage.map((r) => r.rank).toList();
    _updateRankOrdinals(ranks);
  }

  Future<void> _updateRankOrdinals(List<Rank> ranks) async {
    try {
      final rankingService =
          Provider.of<RankingService>(context, listen: false);
      await rankingService.updateRankOrdinals(ranks);

      ActionLogger.logAction('RanksManagementTab', 'ordinals_updated', {
        'ranksCount': ranks.length,
      });
    } catch (e) {
      ActionLogger.logError(
          'RanksManagementTab._updateRankOrdinals', e.toString(), {
        'ranksCount': ranks.length,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error updating rank order: $e');
      }
    }
  }

  void _showAddRankDialog(BuildContext context) {
    ActionLogger.logUserAction('RanksManagementTab', 'add_rank_dialog_opened');

    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Rank'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Rank name',
            hintText: 'Enter rank name',
          ),
          autofocus: true,
          onSubmitted: (_) => _performAddRank(context, controller),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _performAddRank(context, controller),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _performAddRank(
      BuildContext context, TextEditingController controller) async {
    final name = controller.text.trim();
    if (name.isEmpty) return;

    ActionLogger.logUserAction('RanksManagementTab', 'add_rank_started', {
      'rankName': name,
    });

    Navigator.pop(context);

    try {
      final rankingService =
          Provider.of<RankingService>(context, listen: false);
      final ranks = await rankingService.getAllRanks();
      final nextOrdinal = ranks.isEmpty ? 1 : ranks.last.ordinal + 1;

      await rankingService.createRank(name: name, ordinal: nextOrdinal);

      if (mounted) {
        setState(() {}); // Refresh the list
        ToastHelper.showSuccess(context, 'Rank "$name" created successfully');
      }
    } catch (e) {
      ActionLogger.logError(
          'RanksManagementTab._performAddRank', e.toString(), {
        'rankName': name,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error creating rank: $e');
      }
    }
  }

  void _showEditRankDialog(BuildContext context, Rank rank) {
    ActionLogger.logUserAction(
        'RanksManagementTab', 'edit_rank_dialog_opened', {
      'rankId': rank.id,
      'rankName': rank.name,
    });

    final controller = TextEditingController(text: rank.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Rank'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Rank name',
            hintText: 'Enter rank name',
          ),
          autofocus: true,
          onSubmitted: (_) {
            Navigator.pop(context);
            _performEditRank(rank, controller);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performEditRank(rank, controller);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _performEditRank(Rank rank, TextEditingController controller) async {
    final name = controller.text.trim();
    if (name.isEmpty) return;

    ActionLogger.logUserAction('RanksManagementTab', 'edit_rank_started', {
      'rankId': rank.id,
      'oldName': rank.name,
      'newName': name,
    });

    try {
      final rankingService =
          Provider.of<RankingService>(context, listen: false);
      final success = await rankingService.updateRank(id: rank.id, name: name);

      if (mounted) {
        if (success) {
          setState(() {}); // Refresh the list
          ToastHelper.showSuccess(context, 'Rank updated to "$name"');
        } else {
          ToastHelper.showError(context, 'Failed to update rank');
        }
      }
    } catch (e) {
      ActionLogger.logError(
          'RanksManagementTab._performEditRank', e.toString(), {
        'rankId': rank.id,
        'newName': name,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error updating rank: $e');
      }
    }
  }

  void _showArchiveRankDialog(BuildContext context, Rank rank) {
    final isArchiving = !rank.isArchived;
    final action = isArchiving ? 'archive' : 'unarchive';

    ActionLogger.logUserAction(
        'RanksManagementTab', '${action}_rank_dialog_opened', {
      'rankId': rank.id,
      'rankName': rank.name,
      'currentArchivedState': rank.isArchived,
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArchiving ? 'Archive Rank' : 'Un-archive Rank'),
        content: Text(
          isArchiving
              ? 'Archive "${rank.name}"?\n\nArchived ranks will remain in past events but won\'t be suggested for new events.'
              : 'Un-archive "${rank.name}"?\n\nThis rank will be available for new events again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog first
              _performArchiveRank(rank); // Don't pass context
            },
            style: TextButton.styleFrom(
              foregroundColor: isArchiving ? Colors.orange : Colors.green,
            ),
            child: Text(isArchiving ? 'Archive' : 'Un-archive'),
          ),
        ],
      ),
    );
  }

  void _performArchiveRank(Rank rank) async {
    final isArchiving = !rank.isArchived;
    final action = isArchiving ? 'archive' : 'unarchive';

    ActionLogger.logUserAction('RanksManagementTab', '${action}_rank_started', {
      'rankId': rank.id,
      'rankName': rank.name,
      'currentArchivedState': rank.isArchived,
    });

    try {
      final rankingService =
          Provider.of<RankingService>(context, listen: false);
      final success = isArchiving
          ? await rankingService.archiveRank(rank.id)
          : await rankingService.unarchiveRank(rank.id);

      if (mounted) {
        if (success) {
          setState(() {}); // Refresh the list
          ToastHelper.showSuccess(context,
              'Rank "${rank.name}" ${isArchiving ? 'archived' : 'un-archived'}');
        } else {
          ToastHelper.showError(context, 'Failed to $action rank');
        }
      }
    } catch (e) {
      ActionLogger.logError(
          'RanksManagementTab._performArchiveRank', e.toString(), {
        'rankId': rank.id,
        'action': action,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error ${action}ing rank: $e');
      }
    }
  }

  void _showDeleteRankDialog(BuildContext context, Rank rank) {
    ActionLogger.logUserAction(
        'RanksManagementTab', 'delete_rank_dialog_opened', {
      'rankId': rank.id,
      'rankName': rank.name,
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Rank'),
        content: Text(
          'Delete "${rank.name}"?\n\nThis will permanently remove the rank. Existing rankings using this rank will need to be reassigned.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog first
              _performDeleteRank(rank); // Don't pass context
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _performDeleteRank(Rank rank) async {
    ActionLogger.logUserAction('RanksManagementTab', 'delete_rank_started', {
      'rankId': rank.id,
      'rankName': rank.name,
    });

    final rankingService = Provider.of<RankingService>(context, listen: false);

    try {
      final ranks = await rankingService.getAllRanks();
      final otherRanks = ranks.where((r) => r.id != rank.id).toList();

      if (!mounted) return;

      if (otherRanks.isEmpty) {
        ToastHelper.showError(context, 'Cannot delete the last remaining rank');
        return;
      }

      final replacementRank =
          await _showReplacementRankDialog(context, rank, otherRanks);
      if (replacementRank == null) return;

      if (!mounted) return;

      final success = await rankingService.deleteRank(
        id: rank.id,
        replacementRankId: replacementRank.id,
      );

      if (mounted) {
        if (success) {
          setState(() {}); // Refresh the list
          ToastHelper.showSuccess(context,
              'Rank "${rank.name}" deleted, existing rankings moved to "${replacementRank.name}"');
        } else {
          ToastHelper.showError(context, 'Failed to delete rank');
        }
      }
    } catch (e) {
      ActionLogger.logError(
          'RanksManagementTab._performDeleteRank', e.toString(), {
        'rankId': rank.id,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error deleting rank: $e');
      }
    }
  }

  Future<Rank?> _showReplacementRankDialog(
      BuildContext context, Rank rankToDelete, List<Rank> otherRanks) async {
    return showDialog<Rank>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Replacement Rank'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Existing rankings using "${rankToDelete.name}" will be moved to:'),
            const SizedBox(height: 16),
            ...otherRanks.map((rank) => RadioListTile<Rank>(
                  value: rank,
                  groupValue: null,
                  onChanged: (value) => Navigator.pop(context, value),
                  title: Text(rank.name),
                  subtitle: Text('Priority: ${rank.ordinal}'),
                  contentPadding: EdgeInsets.zero,
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
