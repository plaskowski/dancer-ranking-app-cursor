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
import '../../widgets/error_display.dart';
import '../../widgets/safe_fab.dart';
import '../../widgets/simplified_tag_filter.dart';
import 'dialogs/select_merge_target_screen.dart';

class DancersScreen extends StatefulWidget {
  const DancersScreen({super.key});

  @override
  State<DancersScreen> createState() => _DancersScreenState();
}

class _DancersScreenState extends State<DancersScreen> {
  String _searchQuery = '';
  List<int> _selectedTagIds = [];

  void _onSearchChanged(String searchQuery) {
    setState(() {
      _searchQuery = searchQuery;
    });
  }

  void _onTagsChanged(List<int> selectedTagIds) {
    setState(() {
      _selectedTagIds = selectedTagIds;
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SimplifiedTagFilter(
                  selectedTagIds: _selectedTagIds,
                  onTagsChanged: _onTagsChanged,
                  onSearchChanged: _onSearchChanged,
                  initialSearchQuery: _searchQuery,
                ),
              ),
            ),

            // Dancers list
            StreamBuilder<List<DancerWithTags>>(
              stream: dancerService.watchDancersWithTagsAndLastMet(),
              builder: (context, snapshot) {
                try {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: ErrorDisplayFactory.streamError(
                        source: 'DancersScreen.StreamBuilder',
                        error: snapshot.error!,
                        stackTrace: snapshot.stackTrace,
                        title: 'Unable to load dancers',
                        message: 'Please restart the app or contact support',
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
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

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final dancer = dancers[index];
                        return DancerCardWithTags(
                          dancerWithTags: dancer,
                          onEdit: () => _editDancer(dancer.dancer),
                          onDelete: () => _deleteDancer(dancer.dancer),
                          onMerge: () => _mergeDancer(dancer.dancer),
                        );
                      },
                      childCount: dancers.length,
                    ),
                  );
                } catch (e, stackTrace) {
                  return SliverToBoxAdapter(
                    child: ErrorDisplayFactory.streamError(
                      source: 'DancersScreen.StreamBuilder',
                      error: e,
                      stackTrace: stackTrace,
                      title: 'Error loading dancers',
                      message: 'Please restart the app or contact support',
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: SafeFAB(
        onPressed: () {
          ActionLogger.logAction(
            'DancersScreen',
            'tap_add_dancer_fab',
            {},
          );
          _showAddDancerDialog();
        },
        child: const Icon(Icons.add),
      ),
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

  void _showAddDancerDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddDancerDialog(),
    );
  }
}
