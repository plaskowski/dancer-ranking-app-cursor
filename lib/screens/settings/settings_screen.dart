import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import '../../services/ranking_service.dart';
import '../../services/score_service.dart';
import '../../utils/action_logger.dart';
import '../../utils/toast_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    ActionLogger.logAction('UI_SettingsScreen', 'screen_initialized', {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    ActionLogger.logAction('UI_SettingsScreen', 'screen_disposed', {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ActionLogger.logAction('UI_SettingsScreen', 'build_called', {});

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.settings),
              text: 'General',
            ),
            Tab(
              icon: Icon(Icons.military_tech),
              text: 'Ranks',
            ),
            Tab(
              icon: Icon(Icons.star_rate),
              text: 'Scores',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _GeneralSettingsTab(),
          _RanksManagementTab(),
          _ScoresManagementTab(),
        ],
      ),
    );
  }
}

class _GeneralSettingsTab extends StatelessWidget {
  const _GeneralSettingsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // App Information Section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const _InfoRow(
                  label: 'App Name',
                  value: 'Dancer Ranking App',
                ),
                const SizedBox(height: 8),
                const _InfoRow(
                  label: 'Version',
                  value: '0.65.2',
                ),
                const SizedBox(height: 8),
                const _InfoRow(
                  label: 'Built for',
                  value: 'Private use',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Placeholder for future settings
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'General Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  title: Text(
                    'More settings coming soon',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoresManagementTab extends StatefulWidget {
  const _ScoresManagementTab();

  @override
  State<_ScoresManagementTab> createState() => _ScoresManagementTabState();
}

class _ScoresManagementTabState extends State<_ScoresManagementTab> {
  List<ScoreWithUsage> _scoresWithUsage = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final scoreService = Provider.of<ScoreService>(context, listen: false);
      final scores = await scoreService.getAllScoresWithUsage();
      setState(() {
        _scoresWithUsage = scores;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ToastHelper.showError(context, 'Failed to load scores: $e');
      }
    }
  }

  Future<void> _showContextMenu(ScoreWithUsage scoreWithUsage) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => _buildContextMenu(scoreWithUsage),
    );

    if (result != null) {
      switch (result) {
        case 'rename':
          await _showRenameDialog(scoreWithUsage.score);
          break;
        case 'delete':
          await _showDeleteDialog(scoreWithUsage);
          break;
        case 'merge':
          await _showMergeDialog(scoreWithUsage.score);
          break;
      }
    }
  }

  Widget _buildContextMenu(ScoreWithUsage scoreWithUsage) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              scoreWithUsage.score.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Rename Score'),
            onTap: () => Navigator.pop(context, 'rename'),
          ),
          if (scoreWithUsage.usageCount == 0)
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Score'),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          if (_scoresWithUsage.length > 1)
            ListTile(
              leading: const Icon(Icons.merge),
              title: const Text('Merge into...'),
              onTap: () => Navigator.pop(context, 'merge'),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _showRenameDialog(Score score) async {
    final controller = TextEditingController(text: score.name);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Score'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Score name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty && newName != score.name) {
                Navigator.pop(context, newName);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      try {
        final scoreService = Provider.of<ScoreService>(context, listen: false);
        await scoreService.updateScore(id: score.id, name: result);
        await _loadScores();
        if (mounted) {
          ToastHelper.showSuccess(context, 'Score renamed successfully');
        }
      } catch (e) {
        if (mounted) {
          ToastHelper.showError(context, 'Failed to rename score: $e');
        }
      }
    }
  }

  Future<void> _showDeleteDialog(ScoreWithUsage scoreWithUsage) async {
    if (scoreWithUsage.usageCount > 0) {
      ToastHelper.showError(context, 'Cannot delete score that is in use');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Score'),
        content: Text('Are you sure you want to delete "${scoreWithUsage.score.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final scoreService = Provider.of<ScoreService>(context, listen: false);
        await scoreService.archiveScore(scoreWithUsage.score.id);
        await _loadScores();
        if (mounted) {
          ToastHelper.showSuccess(context, 'Score deleted successfully');
        }
      } catch (e) {
        if (mounted) {
          ToastHelper.showError(context, 'Failed to delete score: $e');
        }
      }
    }
  }

  Future<void> _showMergeDialog(Score sourceScore) async {
    final targetScores = _scoresWithUsage.where((s) => s.score.id != sourceScore.id).map((s) => s.score).toList();

    if (targetScores.isEmpty) {
      ToastHelper.showError(context, 'No other scores available for merging');
      return;
    }

    final targetScore = await showDialog<Score>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Merge Into'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Merge "${sourceScore.name}" into:'),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: targetScores.length,
                  itemBuilder: (context, index) {
                    final score = targetScores[index];
                    return ListTile(
                      title: Text(score.name),
                      subtitle: Text(
                          'Used in ${_scoresWithUsage.firstWhere((s) => s.score.id == score.id).usageCount} dances'),
                      onTap: () => Navigator.pop(context, score),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (targetScore != null) {
      await _showMergeConfirmationDialog(sourceScore, targetScore);
    }
  }

  Future<void> _showMergeConfirmationDialog(Score sourceScore, Score targetScore) async {
    final sourceUsage = _scoresWithUsage.firstWhere((s) => s.score.id == sourceScore.id).usageCount;
    final targetUsage = _scoresWithUsage.firstWhere((s) => s.score.id == targetScore.id).usageCount;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Merge'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Source: "${sourceScore.name}" ($sourceUsage dances)'),
            Text('Target: "${targetScore.name}" ($targetUsage dances)'),
            const SizedBox(height: 16),
            Text('All dances scored "${sourceScore.name}" will become "${targetScore.name}"'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Merge'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final scoreService = Provider.of<ScoreService>(context, listen: false);
        await scoreService.mergeScores(
          sourceScoreId: sourceScore.id,
          targetScoreId: targetScore.id,
        );
        await _loadScores();
        if (mounted) {
          ToastHelper.showSuccess(context, 'Scores merged successfully');
        }
      } catch (e) {
        if (mounted) {
          ToastHelper.showError(context, 'Failed to merge scores: $e');
        }
      }
    }
  }

  Future<void> _showAddScoreDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Score'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Score name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(context, name);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null) {
      try {
        final maxOrdinal =
            _scoresWithUsage.isEmpty ? 0 : _scoresWithUsage.map((s) => s.score.ordinal).reduce((a, b) => a > b ? a : b);

        final scoreService = Provider.of<ScoreService>(context, listen: false);
        await scoreService.createScore(
          name: result,
          ordinal: maxOrdinal + 1,
        );
        await _loadScores();
        if (mounted) {
          ToastHelper.showSuccess(context, 'Score added successfully');
        }
      } catch (e) {
        if (mounted) {
          ToastHelper.showError(context, 'Failed to add score: $e');
        }
      }
    }
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final item = _scoresWithUsage.removeAt(oldIndex);
    _scoresWithUsage.insert(newIndex, item);

    final updates = <ScoreOrderUpdate>[];
    for (int i = 0; i < _scoresWithUsage.length; i++) {
      final newOrdinal = i + 1;
      if (_scoresWithUsage[i].score.ordinal != newOrdinal) {
        updates.add(ScoreOrderUpdate(
          id: _scoresWithUsage[i].score.id,
          ordinal: newOrdinal,
        ));
      }
    }

    if (updates.isNotEmpty) {
      try {
        final scoreService = Provider.of<ScoreService>(context, listen: false);
        await scoreService.updateScoreOrder(updates);
        setState(() {});
        if (mounted) {
          ToastHelper.showSuccess(context, 'Score order updated');
        }
      } catch (e) {
        await _loadScores();
        if (mounted) {
          ToastHelper.showError(context, 'Failed to update order: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _scoresWithUsage.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No scores available.\nTap + to add your first score.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: _scoresWithUsage.length,
                    onReorder: _onReorder,
                    itemBuilder: (context, index) {
                      final scoreWithUsage = _scoresWithUsage[index];
                      return ListTile(
                        key: ValueKey(scoreWithUsage.score.id),
                        title: Text(
                          '${scoreWithUsage.score.name} • ${scoreWithUsage.usageCount} dances',
                          style: const TextStyle(fontSize: 16),
                        ),
                        onTap: () => _showContextMenu(scoreWithUsage),
                      );
                    },
                  ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _showAddScoreDialog,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _RanksManagementTab extends StatefulWidget {
  const _RanksManagementTab();

  @override
  State<_RanksManagementTab> createState() => _RanksManagementTabState();
}

class _RanksManagementTabState extends State<_RanksManagementTab> {
  @override
  Widget build(BuildContext context) {
    final rankingService = Provider.of<RankingService>(context);

    return Stack(
      children: [
        FutureBuilder<List<RankWithUsage>>(
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

            return ReorderableListView.builder(
              padding: const EdgeInsets.only(bottom: 80, left: 16, right: 16, top: 16),
              itemCount: ranksWithUsage.length,
              onReorder: (oldIndex, newIndex) => _reorderRanks(ranksWithUsage, oldIndex, newIndex),
              itemBuilder: (context, index) {
                final rankWithUsage = ranksWithUsage[index];
                return _RankCard(
                  key: ValueKey(rankWithUsage.rank.id),
                  rankWithUsage: rankWithUsage,
                  index: index,
                  onEdit: () => _showEditRankDialog(context, rankWithUsage.rank),
                  onArchive: () => _showArchiveRankDialog(context, rankWithUsage.rank),
                  onDelete: () => _showDeleteRankDialog(context, rankWithUsage.rank),
                );
              },
            );
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () => _showAddRankDialog(context),
            tooltip: 'Add New Rank',
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _reorderRanks(List<RankWithUsage> ranksWithUsage, int oldIndex, int newIndex) {
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
      final rankingService = Provider.of<RankingService>(context, listen: false);
      await rankingService.updateRankOrdinals(ranks);

      ActionLogger.logAction('RanksManagementTab', 'ordinals_updated', {
        'ranksCount': ranks.length,
      });
    } catch (e) {
      ActionLogger.logError('RanksManagementTab._updateRankOrdinals', e.toString(), {
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

  void _performAddRank(BuildContext context, TextEditingController controller) async {
    final name = controller.text.trim();
    if (name.isEmpty) return;

    ActionLogger.logUserAction('RanksManagementTab', 'add_rank_started', {
      'rankName': name,
    });

    Navigator.pop(context);

    try {
      final rankingService = Provider.of<RankingService>(context, listen: false);
      final ranks = await rankingService.getAllRanks();
      final nextOrdinal = ranks.isEmpty ? 1 : ranks.last.ordinal + 1;

      await rankingService.createRank(name: name, ordinal: nextOrdinal);

      if (mounted) {
        setState(() {}); // Refresh the list
        ToastHelper.showSuccess(context, 'Rank "$name" created successfully');
      }
    } catch (e) {
      ActionLogger.logError('RanksManagementTab._performAddRank', e.toString(), {
        'rankName': name,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error creating rank: $e');
      }
    }
  }

  void _showEditRankDialog(BuildContext context, Rank rank) {
    ActionLogger.logUserAction('RanksManagementTab', 'edit_rank_dialog_opened', {
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
      final rankingService = Provider.of<RankingService>(context, listen: false);
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
      ActionLogger.logError('RanksManagementTab._performEditRank', e.toString(), {
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

    ActionLogger.logUserAction('RanksManagementTab', '${action}_rank_dialog_opened', {
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
      final rankingService = Provider.of<RankingService>(context, listen: false);
      final success =
          isArchiving ? await rankingService.archiveRank(rank.id) : await rankingService.unarchiveRank(rank.id);

      if (mounted) {
        if (success) {
          setState(() {}); // Refresh the list
          ToastHelper.showSuccess(context, 'Rank "${rank.name}" ${isArchiving ? 'archived' : 'un-archived'}');
        } else {
          ToastHelper.showError(context, 'Failed to $action rank');
        }
      }
    } catch (e) {
      ActionLogger.logError('RanksManagementTab._performArchiveRank', e.toString(), {
        'rankId': rank.id,
        'action': action,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error ${action}ing rank: $e');
      }
    }
  }

  void _showDeleteRankDialog(BuildContext context, Rank rank) {
    ActionLogger.logUserAction('RanksManagementTab', 'delete_rank_dialog_opened', {
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

      final replacementRank = await _showReplacementRankDialog(context, rank, otherRanks);
      if (replacementRank == null) return;

      if (!mounted) return;

      final success = await rankingService.deleteRank(
        id: rank.id,
        replacementRankId: replacementRank.id,
      );

      if (mounted) {
        if (success) {
          setState(() {}); // Refresh the list
          ToastHelper.showSuccess(
              context, 'Rank "${rank.name}" deleted, existing rankings moved to "${replacementRank.name}"');
        } else {
          ToastHelper.showError(context, 'Failed to delete rank');
        }
      }
    } catch (e) {
      ActionLogger.logError('RanksManagementTab._performDeleteRank', e.toString(), {
        'rankId': rank.id,
      });

      if (mounted) {
        ToastHelper.showError(context, 'Error deleting rank: $e');
      }
    }
  }

  Future<Rank?> _showReplacementRankDialog(BuildContext context, Rank rankToDelete, List<Rank> otherRanks) async {
    return showDialog<Rank>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Replacement Rank'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Existing rankings using "${rankToDelete.name}" will be moved to:'),
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
  final RankWithUsage rankWithUsage;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  const _RankCard({
    super.key,
    required this.rankWithUsage,
    required this.index,
    required this.onEdit,
    required this.onArchive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final rank = rankWithUsage.rank;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          '${rank.name} • ${rankWithUsage.usageCount} attendances',
          style: const TextStyle(fontSize: 16),
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
        onTap: () => _showContextMenu(context),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    final rank = rankWithUsage.rank;
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
              leading: Icon(rank.isArchived ? Icons.unarchive : Icons.archive),
              title: Text(rank.isArchived ? 'Un-archive' : 'Archive'),
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
