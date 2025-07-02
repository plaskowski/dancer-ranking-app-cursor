import 'package:flutter/material.dart';

import '../../models/import_models.dart';
import '../../theme/theme_extensions.dart';

/// Step 4: Results Component
/// Shows import progress, results summary
class ResultsStep extends StatelessWidget {
  final DancerImportSummary? results;
  final double progress;
  final String currentOperation;
  final bool isImporting;

  const ResultsStep({
    super.key,
    required this.results,
    required this.progress,
    required this.currentOperation,
    required this.isImporting,
  });

  @override
  Widget build(BuildContext context) {
    if (isImporting) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Importing Dancers...',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 8),
          Text(
            currentOperation,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 8),
                Text(
                  'Please wait...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (results == null) {
      return const Center(
        child: Text('Import has not been started yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Import Complete',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),

        // Results summary
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildResultItem(
                      context,
                      'Imported',
                      '${results!.imported}',
                      Icons.check_circle,
                      context.danceTheme.success,
                    ),
                    _buildResultItem(
                      context,
                      'Skipped',
                      '${results!.skipped}',
                      Icons.skip_next,
                      context.danceTheme.warning,
                    ),
                    _buildResultItem(
                      context,
                      'Errors',
                      '${results!.errors}',
                      Icons.error,
                      Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
                if (results!.createdTags.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Created ${results!.createdTags.length} new tags',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ),

        // Error details if any
        if (results!.hasErrors) ...[
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
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Errors Encountered',
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
                  ...results!.errorMessages.take(3).map((error) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '• $error',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                  ),
                        ),
                      )),
                  if (results!.errorMessages.length > 3)
                    Text(
                      'and ${results!.errorMessages.length - 3} more errors...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                ],
              ),
            ),
          ),
        ],

        // Success message if no errors
        if (!results!.hasErrors && results!.imported > 0) ...[
          const SizedBox(height: 16),
          Card(
            color: context.danceTheme.success.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: context.danceTheme.success,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Import completed successfully! All dancers have been added to your database.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: context.danceTheme.success,
                          ),
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

  Widget _buildResultItem(BuildContext context, String label, String value,
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
