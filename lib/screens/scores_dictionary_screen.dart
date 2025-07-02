import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/score_service.dart';
import '../utils/toast_helper.dart';

class ScoresDictionaryScreen extends StatefulWidget {
  static const String routeName = '/scores-dictionary';

  const ScoresDictionaryScreen({super.key});

  @override
  State<ScoresDictionaryScreen> createState() => _ScoresDictionaryScreenState();
}

class _ScoresDictionaryScreenState extends State<ScoresDictionaryScreen> {
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
        // Since usage count is 0, we can safely delete without replacement
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Merge "${sourceScore.name}" into:'),
            const SizedBox(height: 16),
            ...targetScores.map((score) => ListTile(
                  title: Text(score.name),
                  subtitle: Text('Ordinal: ${score.ordinal}'),
                  onTap: () => Navigator.pop(context, score),
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
        // Find the next ordinal (worst rank + 1)
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

    // Update ordinals based on new positions
    final updates = <ScoreOrderUpdate>[];
    for (int i = 0; i < _scoresWithUsage.length; i++) {
      final newOrdinal = i + 1; // 1-based ordinals
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
        setState(() {}); // Refresh to show new order
        if (mounted) {
          ToastHelper.showSuccess(context, 'Score order updated');
        }
      } catch (e) {
        // Revert the UI change if update failed
        await _loadScores();
        if (mounted) {
          ToastHelper.showError(context, 'Failed to update order: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Scores'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _scoresWithUsage.isEmpty
              ? const Center(
                  child: Text(
                    'No scores available.\nTap + to add your first score.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ReorderableListView.builder(
                  padding: const EdgeInsets.only(bottom: 80), // Space for FAB
                  itemCount: _scoresWithUsage.length,
                  onReorder: _onReorder,
                  itemBuilder: (context, index) {
                    final scoreWithUsage = _scoresWithUsage[index];
                    return ListTile(
                      key: ValueKey(scoreWithUsage.score.id),
                      leading: const Icon(Icons.drag_handle),
                      title: Text(scoreWithUsage.score.name),
                      subtitle: Text('Used in ${scoreWithUsage.usageCount} dances'),
                      trailing: Text(
                        '#${scoreWithUsage.score.ordinal}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      onTap: () => _showContextMenu(scoreWithUsage),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddScoreDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
