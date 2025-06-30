import 'package:flutter/material.dart';

import '../../models/import_models.dart';
import '../../theme/theme_extensions.dart';

/// Step 2: Data Preview Component
/// Shows parsed import data with validation status and statistics
class DataPreviewStep extends StatelessWidget {
  final DancerImportResult? parseResult;
  final List<DancerImportConflict> conflicts;
  final bool isLoading;

  const DataPreviewStep({
    super.key,
    required this.parseResult,
    required this.conflicts,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (parseResult == null) {
      return const Center(
        child:
            Text('No data to preview. Please select and parse a file first.'),
      );
    }

    if (!parseResult!.isValid) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'File Errors',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ...parseResult!.errors.map((error) => Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          error,
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Statistics
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Total',
                  '${parseResult!.dancers.length}',
                  Icons.people,
                  Theme.of(context).colorScheme.primary,
                ),
                _buildStatItem(
                  context,
                  'Valid',
                  '${parseResult!.dancers.length - conflicts.length}',
                  Icons.check_circle,
                  context.danceTheme.success,
                ),
                _buildStatItem(
                  context,
                  'Conflicts',
                  '${conflicts.length}',
                  Icons.warning,
                  context.danceTheme.warning,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Preview list
        Text(
          'Dancers Preview',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: parseResult!.dancers.length,
            itemBuilder: (context, index) {
              final dancer = parseResult!.dancers[index];
              return Card(
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(dancer.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (dancer.tags.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          children: dancer.tags
                              .map((tag) => Chip(
                                    label: Text(
                                      tag,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    visualDensity: VisualDensity.compact,
                                  ))
                              .toList(),
                        ),
                      if (dancer.notes != null)
                        Text(
                          dancer.notes!,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.check_circle,
                    color: context.danceTheme.success,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value,
      IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
