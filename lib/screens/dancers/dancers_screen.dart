import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import '../../models/dancer_with_tags.dart';
import '../../services/dancer/dancer_filter_service.dart';
import '../../services/dancer_service.dart';
import '../../utils/action_logger.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/add_dancer_dialog.dart';
import '../../widgets/dancer_card_with_tags.dart';
import '../../widgets/safe_fab.dart';
import '../event/dialogs/base_dancer_selection_screen.dart';
import 'dialogs/select_merge_target_screen.dart';

class DancersScreen extends StatefulWidget {
  const DancersScreen({super.key});

  @override
  State<DancersScreen> createState() => _DancersScreenState();
}

class _DancersScreenState extends State<DancersScreen> {
  Future<List<DancerWithTags>> _getDancers(List<int> tagIds, String searchQuery) async {
    final dancerService = Provider.of<DancerService>(context, listen: false);
    final allDancers = await dancerService.getDancersWithTagsAndLastMet();

    final filterService = DancerFilterService.of(context);
    List<DancerWithTags> filteredDancers = allDancers;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filteredDancers = filterService.filterDancersByTextWords(allDancers, searchQuery);
    }

    // Apply tag filter
    if (tagIds.isNotEmpty) {
      filteredDancers = filteredDancers.where((dancer) {
        return dancer.tags.any((tag) => tagIds.contains(tag.id));
      }).toList();
    }

    return filteredDancers;
  }

  Widget _buildDancerTile(DancerWithTags dancer) {
    return DancerCardWithTags(
      dancerWithTags: dancer,
      onEdit: () => _editDancer(dancer.dancer),
      onDelete: () => _deleteDancer(dancer.dancer),
      onMerge: () => _mergeDancer(dancer.dancer),
    );
  }

  void _editDancer(Dancer dancer) {
    showDialog(
      context: context,
      builder: (context) => AddDancerDialog(dancer: dancer),
    );
  }

  void _deleteDancer(Dancer dancer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Dancer'),
        content: Text(
            'Are you sure you want to delete ${dancer.name}? This will also remove all their rankings and attendance records.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final dancerService = Provider.of<DancerService>(context, listen: false);
                await dancerService.deleteDancer(dancer.id);

                if (mounted) {
                  Navigator.pop(context);
                  ToastHelper.showSuccess(context, '${dancer.name} deleted');
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ToastHelper.showError(context, 'Error deleting dancer: $e');
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _mergeDancer(Dancer dancer) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => SelectMergeTargetScreen(sourceDancer: dancer),
      ),
    );

    // If merge was successful, the screen will automatically refresh via streams
    // The SelectMergeTargetScreen already shows success/error messages
    if (result == true && mounted) {
      // Additional refresh can be added here if needed
      // The StreamBuilder will automatically update
    }
  }

  void _showAddDancerDialog() {
    ActionLogger.logAction(
      'DancersScreen',
      'tap_add_dancer_fab',
      {},
    );
    showDialog(
      context: context,
      builder: (context) => const AddDancerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseDancerListScreen(
      screenTitle: 'Dancers',
      getDancers: _getDancers,
      buildDancerTile: _buildDancerTile,
      floatingActionButton: SafeFAB(
        onPressed: _showAddDancerDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
