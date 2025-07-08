import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import '../../models/dancer_with_tags.dart';
import '../../services/dancer/dancer_activity_service.dart';
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
  Stream<List<DancerWithTags>> _getDancers(List<int> tagIds, String searchQuery, [String? activityFilter]) {
    final dancerService = Provider.of<DancerService>(context, listen: false);
    final database = Provider.of<AppDatabase>(context, listen: false);
    final activityService = DancerActivityService(database);

    var allDancersStream = dancerService.watchDancersWithTagsAndLastMet();

    // Apply activity filter first
    if (activityFilter != null && activityFilter.isNotEmpty) {
      final activityLevel = _mapActivityStringToLevel(activityFilter);
      allDancersStream = activityService.filterDancersByActivityLevel(
        allDancersStream,
        activityLevel,
      );
    }

    return allDancersStream.map((allDancers) {
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
    });
  }

  ActivityLevel _mapActivityStringToLevel(String activityString) {
    switch (activityString.toLowerCase()) {
      case 'regular':
        return ActivityLevel.regular;
      case 'occasional':
        return ActivityLevel.occasional;
      case 'all':
        return ActivityLevel.all;
      default:
        return ActivityLevel.regular; // Default to most active
    }
  }

  Widget _buildDancerTile(DancerWithTags dancer) {
    return DancerCardWithTags(
      dancerWithTags: dancer,
      onEdit: () => _editDancer(dancer.dancer),
      onDelete: () => _deleteDancer(dancer.dancer),
      onMerge: () => _mergeDancer(dancer.dancer),
    );
  }

  Future<void> _editDancer(Dancer dancer) async {
    await showDialog(
      context: context,
      builder: (context) => AddDancerDialog(dancer: dancer),
    );
  }

  Future<void> _deleteDancer(Dancer dancer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Dancer'),
        content: Text(
            'Are you sure you want to delete ${dancer.name}? This will also remove all their rankings and attendance records.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final dancerService = Provider.of<DancerService>(context, listen: false);
        await dancerService.deleteDancer(dancer.id);

        if (mounted) {
          ToastHelper.showSuccess(context, '${dancer.name} deleted');
        }
      } catch (e) {
        if (mounted) {
          ToastHelper.showError(context, 'Error deleting dancer: $e');
        }
      }
    }
  }

  Future<void> _mergeDancer(Dancer dancer) async {
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

  Future<void> _showAddDancerDialog() async {
    ActionLogger.logAction(
      'DancersScreen',
      'tap_add_dancer_fab',
      {},
    );
    await showDialog(
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
      infoMessage: 'Manage your dancers. Edit, delete, or merge dancer profiles.',
      floatingActionButton: SafeFAB(
        onPressed: _showAddDancerDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
