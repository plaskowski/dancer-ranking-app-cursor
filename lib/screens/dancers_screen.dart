import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/dancer_service.dart';
import '../theme/theme_extensions.dart';
import '../widgets/add_dancer_dialog.dart';

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

  @override
  Widget build(BuildContext context) {
    final dancerService = Provider.of<DancerService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dancers'),
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
            child: StreamBuilder<List<Dancer>>(
              stream: dancerService.searchDancers(_searchQuery),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final dancers = snapshot.data ?? [];

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
                          _searchQuery.isEmpty
                              ? 'No dancers yet'
                              : 'No dancers found',
                          style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Tap + to add your first dancer'
                              : 'Try a different search',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
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
                    final dancer = dancers[index];
                    return _DancerCard(
                      dancer: dancer,
                      onEdit: () => _editDancer(dancer),
                      onDelete: () => _deleteDancer(dancer),
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
                final dancerService =
                    Provider.of<DancerService>(context, listen: false);
                await dancerService.deleteDancer(dancer.id);

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${dancer.name} deleted'),
                      backgroundColor: context.danceTheme.success,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting dancer: $e'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
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
}

class _DancerCard extends StatelessWidget {
  final Dancer dancer;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DancerCard({
    required this.dancer,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            dancer.name.isNotEmpty ? dancer.name[0].toUpperCase() : '?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          dancer.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: dancer.notes != null && dancer.notes!.isNotEmpty
            ? Text(
                dancer.notes!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : Text(
                'No notes yet',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
