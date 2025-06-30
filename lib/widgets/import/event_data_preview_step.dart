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

        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: parseResult!.events.length,
            itemBuilder: (context, index) {
              final event = parseResult!.events[index];
              return Card(
                child: ExpansionTile(
                  leading: Icon(
                    Icons.event,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(event.name),
                  subtitle: Text(
                    '${DateFormat.yMMMd().format(event.date)} • ${event.attendances.length} attendances',
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Attendances:',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          ...event.attendances.map((attendance) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    Icon(
                                      _getStatusIcon(attendance.status),
                                      size: 16,
                                      color: _getStatusColor(
                                          context, attendance.status),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        attendance.dancerName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                    Text(
                                      attendance.status,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: _getStatusColor(
                                                context, attendance.status),
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
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

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'present':
        return Icons.check_circle;
      case 'served':
        return Icons.star;
      case 'left':
        return Icons.exit_to_app;
      default:
        return Icons.help;
    }
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
