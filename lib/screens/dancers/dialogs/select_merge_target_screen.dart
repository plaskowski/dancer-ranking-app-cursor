import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/database.dart';
import '../../../services/dancer_service.dart';
import '../../../utils/action_logger.dart';
import '../../../utils/toast_helper.dart';

class SelectMergeTargetScreen extends StatefulWidget {
  final Dancer sourceDancer;

  const SelectMergeTargetScreen({
    super.key,
    required this.sourceDancer,
  });

  @override
  State<SelectMergeTargetScreen> createState() =>
      _SelectMergeTargetScreenState();
}

class _SelectMergeTargetScreenState extends State<SelectMergeTargetScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    ActionLogger.logUserAction('SelectMergeTargetScreen', 'screen_opened', {
      'sourceDancerId': widget.sourceDancer.id,
      'sourceDancerName': widget.sourceDancer.name,
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  Future<void> _showMergeConfirmation(Dancer targetDancer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _MergeConfirmationDialog(
        sourceDancer: widget.sourceDancer,
        targetDancer: targetDancer,
      ),
    );

    if (confirmed == true) {
      await _performMerge(targetDancer);
    }
  }

  Future<void> _performMerge(Dancer targetDancer) async {
    ActionLogger.logUserAction('SelectMergeTargetScreen', 'merge_started', {
      'sourceDancerId': widget.sourceDancer.id,
      'targetDancerId': targetDancer.id,
    });

    final dancerService = Provider.of<DancerService>(context, listen: false);

    try {
      final success = await dancerService.mergeDancers(
        widget.sourceDancer.id,
        targetDancer.id,
      );

      if (mounted) {
        if (success) {
          ActionLogger.logUserAction(
              'SelectMergeTargetScreen', 'merge_success', {
            'sourceDancerId': widget.sourceDancer.id,
            'targetDancerId': targetDancer.id,
          });

          ToastHelper.showSuccess(
            context,
            'Successfully merged "${widget.sourceDancer.name}" into "${targetDancer.name}"',
          );
          Navigator.pop(context, true); // Return true to indicate success
        } else {
          ActionLogger.logError('SelectMergeTargetScreen', 'merge_failed', {
            'sourceDancerId': widget.sourceDancer.id,
            'targetDancerId': targetDancer.id,
          });

          ToastHelper.showError(context, 'Failed to merge dancers');
        }
      }
    } catch (e) {
      if (mounted) {
        ActionLogger.logError('SelectMergeTargetScreen', 'merge_error', {
          'sourceDancerId': widget.sourceDancer.id,
          'targetDancerId': targetDancer.id,
          'error': e.toString(),
        });

        ToastHelper.showError(
            context, 'Error merging dancers: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dancerService = Provider.of<DancerService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Merge "${widget.sourceDancer.name}" into...'),
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(16),
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

          // Info banner
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Select the dancer to merge "${widget.sourceDancer.name}" into. All dance history will be transferred.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Dancers list
          Expanded(
            child: StreamBuilder<List<Dancer>>(
              stream: dancerService.watchAllDancers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final allDancers = snapshot.data ?? [];

                // Filter out the source dancer and apply search
                final availableDancers = allDancers
                    .where((dancer) =>
                        dancer.id !=
                            widget.sourceDancer.id && // Can't merge into self
                        (_searchQuery.isEmpty ||
                            dancer.name.toLowerCase().contains(_searchQuery) ||
                            (dancer.notes
                                    ?.toLowerCase()
                                    .contains(_searchQuery) ??
                                false)))
                    .toList();

                availableDancers.sort((a, b) => a.name.compareTo(b.name));

                if (availableDancers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No other dancers available'
                              : 'No dancers match your search',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: availableDancers.length,
                  itemBuilder: (context, index) {
                    final dancer = availableDancers[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            dancer.name.isNotEmpty
                                ? dancer.name[0].toUpperCase()
                                : '?',
                          ),
                        ),
                        title: Text(dancer.name),
                        subtitle: dancer.notes != null
                            ? Text(
                                dancer.notes!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                        onTap: () => _showMergeConfirmation(dancer),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MergeConfirmationDialog extends StatelessWidget {
  final Dancer sourceDancer;
  final Dancer targetDancer;

  const _MergeConfirmationDialog({
    required this.sourceDancer,
    required this.targetDancer,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Merge'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              children: [
                const TextSpan(text: 'Merge: '),
                TextSpan(
                  text: sourceDancer.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '\nInto: '),
                TextSpan(
                  text: targetDancer.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('After merge:'),
          const Text('✓ All dance history will be transferred'),
          const Text('✓ All tags will be combined'),
          const Text('✓ Notes will be merged'),
          Text('✓ "${sourceDancer.name}" will be deleted'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This action cannot be undone',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Confirm Merge'),
        ),
      ],
    );
  }
}
