import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import '../../models/dancer_with_tags.dart';
import '../../services/dancer_service.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/add_dancer_dialog.dart';
import '../../widgets/dancer_card_with_tags.dart';
import '../../widgets/import/import_dancers_dialog.dart';
import 'dialogs/select_merge_target_screen.dart';

class DancersScreen extends StatefulWidget {
  const DancersScreen({super.key});

  @override
  State<DancersScreen> createState() => _DancersScreenState();
}

class _DancersScreenState extends State<DancersScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<DancerWithTags> _filterDancers(List<DancerWithTags> dancers) {
    if (_searchQuery.isEmpty) {
      return dancers;
    }

    final query = _searchQuery.toLowerCase();
    return dancers.where((dancer) {
      // Search in dancer name
      if (dancer.name.toLowerCase().contains(query)) {
        return true;
      }
      // Search in notes
      if (dancer.notes != null && dancer.notes!.toLowerCase().contains(query)) {
        return true;
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dancerService = Provider.of<DancerService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dancers'),
        actions: [
          IconButton(
            onPressed: _showImportDialog,
            icon: const Icon(Icons.file_upload),
            tooltip: 'Import dancers from JSON file',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search dancers...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          // Dancers list
          Expanded(
            child: StreamBuilder<List<DancerWithTags>>(
              stream: dancerService.watchDancersWithTags(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final allDancers = snapshot.data ?? [];
                final dancers = _filterDancers(allDancers);

                if (dancers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty ? 'No dancers yet' : 'No dancers found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isEmpty ? 'Tap + to add your first dancer' : 'Try a different search',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: dancers.length,
                  itemBuilder: (context, index) {
                    final dancerWithTags = dancers[index];
                    return DancerCardWithTags(
                      dancerWithTags: dancerWithTags,
                      onEdit: () => _editDancer(dancerWithTags.dancer),
                      onDelete: () => _deleteDancer(dancerWithTags.dancer),
                      onMerge: () => _mergeDancer(dancerWithTags.dancer),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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

  void _showImportDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const ImportDancersDialog(),
    );

    // If import was successful, refresh is automatic via streams
    // But show a confirmation if needed
    if (result == true && mounted) {
      ToastHelper.showSuccess(context, 'Dancers imported successfully!');
    }
  }
}
