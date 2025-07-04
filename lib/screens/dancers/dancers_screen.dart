import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import '../../models/dancer_with_tags.dart';
import '../../services/dancer/dancer_activity_service.dart';
import '../../services/dancer/dancer_filter_service.dart';
import '../../services/dancer_service.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/add_dancer_dialog.dart';
import '../../widgets/combined_dancer_filter.dart';
import '../../widgets/dancer_card_with_tags.dart';
import '../../widgets/safe_fab.dart';
import 'dialogs/select_merge_target_screen.dart';

class DancersScreen extends StatefulWidget {
  const DancersScreen({super.key});

  @override
  State<DancersScreen> createState() => _DancersScreenState();
}

class _DancersScreenState extends State<DancersScreen> {
  String _searchQuery = '';
  List<int> _selectedTagIds = [];
  ActivityLevel? _selectedActivityLevel = ActivityLevel.active;
  Map<ActivityLevel, int>? _activityLevelCounts;

  void _onFiltersChanged(String searchQuery, List<int> selectedTagIds,
      ActivityLevel? selectedActivityLevel) {
    setState(() {
      _searchQuery = searchQuery;
      _selectedTagIds = selectedTagIds;
      _selectedActivityLevel = selectedActivityLevel;
    });
  }

  List<DancerWithTags> _filterDancers(List<DancerWithTags> dancers) {
    final filterService = DancerFilterService.of(context);
    List<DancerWithTags> filteredDancers = dancers;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredDancers =
          filterService.filterDancersByTextWords(dancers, _searchQuery);
    }

    // Apply tag filter
    if (_selectedTagIds.isNotEmpty) {
      filteredDancers = filteredDancers.where((dancer) {
        return dancer.tags.any((tag) => _selectedTagIds.contains(tag.id));
      }).toList();
    }

    // Apply activity level filter
    if (_selectedActivityLevel != null) {
      // TODO: Implement activity level filtering when service is ready
      // For now, we'll keep all dancers
    }

    return filteredDancers;
  }

  @override
  Widget build(BuildContext context) {
    final dancerService = Provider.of<DancerService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dancers'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Filter section
            SliverToBoxAdapter(
              child: CombinedDancerFilter(
                onFiltersChanged: _onFiltersChanged,
                activityLevelCounts: _activityLevelCounts,
              ),
            ),

            // Dancers list
            StreamBuilder<List<DancerWithTags>>(
              stream: dancerService.watchDancersWithTags(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                }

                final allDancers = snapshot.data ?? [];
                final dancers = _filterDancers(allDancers);

                if (dancers.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people,
                            size: 64,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty && _selectedTagIds.isEmpty
                                ? 'No dancers yet'
                                : 'No dancers found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isEmpty && _selectedTagIds.isEmpty
                                ? 'Tap + to add your first dancer'
                                : 'Try adjusting your filters',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final dancerWithTags = dancers[index];
                        return DancerCardWithTags(
                          dancerWithTags: dancerWithTags,
                          onEdit: () => _editDancer(dancerWithTags.dancer),
                          onDelete: () => _deleteDancer(dancerWithTags.dancer),
                          onMerge: () => _mergeDancer(dancerWithTags.dancer),
                        );
                      },
                      childCount: dancers.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: SafeFAB(
        onPressed: () => _addDancer(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addDancer() {
    showDialog(
      context: context,
      builder: (context) => const AddDancerDialog(),
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
                final dancerService =
                    Provider.of<DancerService>(context, listen: false);
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
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error),
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
}
