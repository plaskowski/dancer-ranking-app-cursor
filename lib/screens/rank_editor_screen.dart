import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/ranking_service.dart';
import '../theme/theme_extensions.dart';
import '../utils/action_logger.dart';

class RankEditorScreen extends StatefulWidget {
  const RankEditorScreen({super.key});

  @override
  State<RankEditorScreen> createState() => _RankEditorScreenState();
}

class _RankEditorScreenState extends State<RankEditorScreen> {
  @override
  void initState() {
    super.initState();
    ActionLogger.logUserAction('RankEditorScreen', 'screen_opened');
  }

  @override
  Widget build(BuildContext context) {
    final rankingService = Provider.of<RankingService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Ranks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add New Rank',
            onPressed: () => _showAddRankDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Rank>>(
        future: rankingService.getAllRanks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final ranks = snapshot.data ?? [];

          if (ranks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_border,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No ranks yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first rank',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Instructions
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Drag to reorder priority. Tap to edit, long press for options.',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Ranks List
              Expanded(
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: ranks.length,
                  onReorder: (oldIndex, newIndex) =>
                      _reorderRanks(ranks, oldIndex, newIndex),
                  itemBuilder: (context, index) {
                    final rank = ranks[index];
                    return _RankCard(
                      key: ValueKey(rank.id),
                      rank: rank,
                      index: index,
                      onEdit: () => _showEditRankDialog(context, rank),
                      onArchive: () => _showArchiveRankDialog(context, rank),
                      onDelete: () => _showDeleteRankDialog(context, rank),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _reorderRanks(List<Rank> ranks, int oldIndex, int newIndex) {
    ActionLogger.logUserAction('RankEditorScreen', 'reorder_ranks', {
      'oldIndex': oldIndex,
      'newIndex': newIndex,
      'rankId': ranks[oldIndex].id,
    });

    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final rank = ranks.removeAt(oldIndex);
      ranks.insert(newIndex, rank);
    });

    // TODO: Update ordinals in database
    _updateRankOrdinals(ranks);
  }

  Future<void> _updateRankOrdinals(List<Rank> ranks) async {
    try {
      final rankingService =
          Provider.of<RankingService>(context, listen: false);
      await rankingService.updateRankOrdinals(ranks);

      ActionLogger.logAction('RankEditorScreen', 'ordinals_updated', {
        'ranksCount': ranks.length,
      });
    } catch (e) {
      ActionLogger.logError(
          'RankEditorScreen._updateRankOrdinals', e.toString(), {
        'ranksCount': ranks.length,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating rank order: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _showAddRankDialog(BuildContext context) {
    ActionLogger.logUserAction('RankEditorScreen', 'add_rank_dialog_opened');

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

    ActionLogger.logUserAction('RankEditorScreen', 'add_rank_started', {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rank "$name" created successfully'),
            backgroundColor: context.danceTheme.success,
          ),
        );
      }
    } catch (e) {
      ActionLogger.logError('RankEditorScreen._performAddRank', e.toString(), {
        'rankName': name,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating rank: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _showEditRankDialog(BuildContext context, Rank rank) {
    ActionLogger.logUserAction('RankEditorScreen', 'edit_rank_dialog_opened', {
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
          onSubmitted: (_) => _performEditRank(context, rank, controller),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _performEditRank(context, rank, controller),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _performEditRank(
      BuildContext context, Rank rank, TextEditingController controller) async {
    final name = controller.text.trim();
    if (name.isEmpty) return;

    ActionLogger.logUserAction('RankEditorScreen', 'edit_rank_started', {
      'rankId': rank.id,
      'oldName': rank.name,
      'newName': name,
    });

    Navigator.pop(context);

    try {
      final rankingService =
          Provider.of<RankingService>(context, listen: false);
      final success = await rankingService.updateRank(id: rank.id, name: name);

      if (mounted) {
        if (success) {
          setState(() {}); // Refresh the list
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Rank updated to "$name"'),
              backgroundColor: context.danceTheme.success,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update rank'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ActionLogger.logError('RankEditorScreen._performEditRank', e.toString(), {
        'rankId': rank.id,
        'newName': name,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating rank: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _showArchiveRankDialog(BuildContext context, Rank rank) {
    ActionLogger.logUserAction(
        'RankEditorScreen', 'archive_rank_dialog_opened', {
      'rankId': rank.id,
      'rankName': rank.name,
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive Rank'),
        content: Text(
          'Archive "${rank.name}"?\n\nArchived ranks will remain in past events but won\'t be suggested for new events.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _performArchiveRank(context, rank),
            style: TextButton.styleFrom(
              foregroundColor: context.danceTheme.warning,
            ),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
  }

  void _performArchiveRank(BuildContext context, Rank rank) async {
    ActionLogger.logUserAction('RankEditorScreen', 'archive_rank_started', {
      'rankId': rank.id,
      'rankName': rank.name,
    });

    Navigator.pop(context);

    try {
      final rankingService =
          Provider.of<RankingService>(context, listen: false);
      final success = await rankingService.archiveRank(rank.id);

      if (mounted) {
        if (success) {
          setState(() {}); // Refresh the list
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Rank "${rank.name}" archived'),
              backgroundColor: context.danceTheme.warning,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to archive rank'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ActionLogger.logError(
          'RankEditorScreen._performArchiveRank', e.toString(), {
        'rankId': rank.id,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error archiving rank: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _showDeleteRankDialog(BuildContext context, Rank rank) {
    ActionLogger.logUserAction(
        'RankEditorScreen', 'delete_rank_dialog_opened', {
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
            onPressed: () => _performDeleteRank(context, rank),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _performDeleteRank(BuildContext context, Rank rank) async {
    ActionLogger.logUserAction('RankEditorScreen', 'delete_rank_started', {
      'rankId': rank.id,
      'rankName': rank.name,
    });

    Navigator.pop(context);

    try {
      final rankingService =
          Provider.of<RankingService>(context, listen: false);
      final ranks = await rankingService.getAllRanks();
      final otherRanks = ranks.where((r) => r.id != rank.id).toList();

      if (otherRanks.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot delete the last remaining rank'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Show replacement rank selection dialog
      final replacementRank =
          await _showReplacementRankDialog(context, rank, otherRanks);
      if (replacementRank == null) return;

      final success = await rankingService.deleteRank(
        id: rank.id,
        replacementRankId: replacementRank.id,
      );

      if (mounted) {
        if (success) {
          setState(() {}); // Refresh the list
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Rank "${rank.name}" deleted, existing rankings moved to "${replacementRank.name}"'),
              backgroundColor: context.danceTheme.success,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete rank'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ActionLogger.logError(
          'RankEditorScreen._performDeleteRank', e.toString(), {
        'rankId': rank.id,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting rank: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
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

class _RankCard extends StatelessWidget {
  final Rank rank;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  const _RankCard({
    super.key,
    required this.rank,
    required this.index,
    required this.onEdit,
    required this.onArchive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onLongPress: () => _showContextMenu(context),
        child: ListTile(
          title: Text(
            rank.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: rank.isArchived
              ? Text(
                  'Archived',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
              : null,
          onTap: onEdit,
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                onEdit();
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archive'),
              onTap: () {
                Navigator.pop(context);
                onArchive();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
