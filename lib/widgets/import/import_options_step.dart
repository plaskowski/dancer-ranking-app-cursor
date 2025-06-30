import 'package:flutter/material.dart';

import '../../models/import_models.dart';

/// Step 3: Import Options Component
/// Allows users to configure conflict resolution and tag handling settings
class ImportOptionsStep extends StatelessWidget {
  final DancerImportOptions options;
  final List<DancerImportConflict> conflicts;
  final Function(DancerImportOptions) onOptionsChanged;

  const ImportOptionsStep({
    super.key,
    required this.options,
    required this.conflicts,
    required this.onOptionsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Import Configuration',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),

        // Conflict resolution
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Duplicate Names',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                RadioListTile<ConflictResolution>(
                  title: const Text('Skip duplicates'),
                  subtitle: const Text('Keep existing dancers unchanged'),
                  value: ConflictResolution.skipDuplicates,
                  groupValue: options.conflictResolution,
                  onChanged: (value) => _updateOptions(
                    options.copyWith(conflictResolution: value),
                  ),
                ),
                RadioListTile<ConflictResolution>(
                  title: const Text('Update existing'),
                  subtitle: const Text('Replace existing dancer data'),
                  value: ConflictResolution.updateExisting,
                  groupValue: options.conflictResolution,
                  onChanged: (value) => _updateOptions(
                    options.copyWith(conflictResolution: value),
                  ),
                ),
                RadioListTile<ConflictResolution>(
                  title: const Text('Import with suffix'),
                  subtitle:
                      const Text('Create new dancers with (2), (3), etc.'),
                  value: ConflictResolution.importWithSuffix,
                  groupValue: options.conflictResolution,
                  onChanged: (value) => _updateOptions(
                    options.copyWith(conflictResolution: value),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Tag handling
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tag Handling',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  title: const Text('Create missing tags automatically'),
                  subtitle: const Text('New tags will be created as needed'),
                  value: options.createMissingTags,
                  onChanged: (value) => _updateOptions(
                    options.copyWith(createMissingTags: value ?? true),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Show conflicts summary if any
        if (conflicts.isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Conflicts Detected',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${conflicts.length} conflict(s) found. Review your conflict resolution settings above.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _updateOptions(DancerImportOptions newOptions) {
    onOptionsChanged(newOptions);
  }
}
