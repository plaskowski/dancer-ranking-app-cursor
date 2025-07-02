import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/import_models.dart';
import '../../theme/theme_extensions.dart';

/// Step 2: Event Data Preview Component
/// Shows parsed event import data with validation status and statistics
class EventDataPreviewStep extends StatelessWidget {
  final EventImportResult? parseResult;
  final bool isLoading;

  const EventDataPreviewStep({
    super.key,
    required this.parseResult,
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

    final totalAttendances = parseResult!.events
        .fold(0, (sum, event) => sum + event.attendances.length);
    final uniqueDancers = parseResult!.events
        .expand((event) => event.attendances.map((a) => a.dancerName))
        .toSet()
        .length;

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
                  'Events',
                  '${parseResult!.events.length}',
                  Icons.event,
                  Theme.of(context).colorScheme.primary,
                ),
                _buildStatItem(
                  context,
                  'Attendances',
                  '$totalAttendances',
                  Icons.people,
                  context.danceTheme.success,
                ),
                _buildStatItem(
                  context,
                  'Dancers',
                  '$uniqueDancers',
                  Icons.person,
                  Theme.of(context).colorScheme.secondary,
                ),
                if (parseResult!.summary != null &&
                    parseResult!.summary!.dancersCreated > 0)
                  _buildStatItem(
                    context,
                    'New Dancers',
                    '${parseResult!.summary!.dancersCreated}',
                    Icons.person_add,
                    Theme.of(context).colorScheme.tertiary,
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Automatic behavior info
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Automatic Import Behavior',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• Duplicate events will be automatically skipped\n'
                  '• Missing dancers will be automatically created\n'
                  '• Dance impressions and score assignments will be preserved\n'
                  '• All events will be imported immediately',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Preview list
        Text(
          'Events Preview',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),

        // Events preview - using Column instead of ListView to avoid scrolling conflicts
        ...parseResult!.summary!.eventAnalyses.map((analysis) {
          final event = analysis.event;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ExpansionTile(
              leading: Icon(
                analysis.willBeImported ? Icons.event : Icons.event_busy,
                color: analysis.willBeImported
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              title: Text(event.name),
              subtitle: Text(
                '${DateFormat.yMMMd().format(event.date)} • ${event.attendances.length} attendances${analysis.hasNewDancers ? ' (${analysis.newDancersCount} new)' : ''}',
              ),
              trailing: analysis.isDuplicate
                  ? const Tooltip(
                      message: 'This event already exists and will be skipped.',
                      child: Chip(label: Text('Skipped')),
                    )
                  : null,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attendances:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      ...event.attendances.map((attendance) {
                        final isNew = analysis.newDancerNames
                            .contains(attendance.dancerName);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Main dancer info line
                                    RichText(
                                      text: TextSpan(
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        children: [
                                          TextSpan(
                                            text: attendance.dancerName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          if (isNew)
                                            TextSpan(
                                              text: ' (new)',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          TextSpan(
                                            text: ' • ${attendance.status}',
                                            style: TextStyle(
                                              color: _getStatusColor(
                                                  context, attendance.status),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Additional data (impression, score) if present
                                    if (attendance.impression != null ||
                                        attendance.scoreName != null) ...[
                                      const SizedBox(height: 2),
                                      RichText(
                                        text: TextSpan(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                          children: [
                                            if (attendance.impression !=
                                                null) ...[
                                              TextSpan(
                                                text: attendance.impression!,
                                                style: const TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                            if (attendance.impression != null &&
                                                attendance.scoreName != null)
                                              const TextSpan(text: ' • '),
                                            if (attendance.scoreName !=
                                                null) ...[
                                              const TextSpan(text: 'Score: '),
                                              TextSpan(
                                                text: attendance.scoreName!,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
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

  Color _getStatusColor(BuildContext context, String status) {
    switch (status) {
      case 'present':
        return context.danceTheme.present;
      case 'served':
        return context.danceTheme.success;
      case 'left':
        return context.danceTheme.warning;
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }
}
