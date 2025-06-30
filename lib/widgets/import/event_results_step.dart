import 'package:flutter/material.dart';

import '../../models/import_models.dart';
import '../../theme/theme_extensions.dart';

/// Step 3: Event Results Component
/// Shows import progress, results summary, and action buttons
class EventResultsStep extends StatelessWidget {
  final EventImportSummary? results;
  final double progress;
  final String currentOperation;
  final bool isImporting;
  final VoidCallback onImportAnother;

  const EventResultsStep({
    super.key,
    required this.results,
    required this.progress,
    required this.currentOperation,
    required this.isImporting,
    required this.onImportAnother,
  });

  @override
  Widget build(BuildContext context) {
    if (isImporting) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Importing Events...',
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
                      'Events Created',
                      '${results!.eventsCreated}',
                      Icons.event,
                      context.danceTheme.success,
                    ),
                    _buildResultItem(
                      context,
                      'Events Skipped',
                      '${results!.eventsSkipped}',
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildResultItem(
                      context,
                      'Attendances',
                      '${results!.attendancesCreated}',
                      Icons.people,
                      Theme.of(context).colorScheme.primary,
                    ),
                    _buildResultItem(
                      context,
                      'Dancers Created',
                      '${results!.dancersCreated}',
                      Icons.person_add,
                      context.danceTheme.present,
                    ),
                    _buildResultItem(
                      context,
                      'Total',
                      '${results!.eventsProcessed}',
                      Icons.assessment,
                      Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Skipped events details if any
        if (results!.hasSkipped) ...[
          const SizedBox(height: 16),
          Card(
            color: context.danceTheme.warningContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: context.danceTheme.onWarningContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Skipped Events',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: context.danceTheme.onWarningContainer,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'These events were automatically skipped because they already exist:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.danceTheme.onWarningContainer,
                        ),
                  ),
                  const SizedBox(height: 4),
                  ...results!.skippedEvents.take(5).map((eventName) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          '• $eventName',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: context.danceTheme.onWarningContainer,
                              ),
                        ),
                      )),
                  if (results!.skippedEvents.length > 5)
                    Text(
                      'and ${results!.skippedEvents.length - 5} more events...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.danceTheme.onWarningContainer,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                ],
              ),
            ),
          ),
        ],

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
        if (!results!.hasErrors && results!.eventsCreated > 0) ...[
          const SizedBox(height: 16),
          Card(
            color: context.danceTheme.successContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: context.danceTheme.onSuccessContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Import completed successfully! ${results!.eventsCreated} events and ${results!.attendancesCreated} attendances have been added to your database.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: context.danceTheme.onSuccessContainer,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton.icon(
              onPressed: onImportAnother,
              icon: const Icon(Icons.add),
              label: const Text('Import Another'),
            ),
            if (results!.eventsCreated > 0)
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.check),
                label: const Text('View Events'),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultItem(BuildContext context, String label, String value,
      IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
