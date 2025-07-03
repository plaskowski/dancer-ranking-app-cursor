import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/database.dart';
import '../../../services/event_import_service.dart';
import '../../../utils/action_logger.dart';
import '../../../utils/toast_helper.dart';
import '../../../widgets/import/import_dancers_dialog.dart';
import '../../../widgets/import_events_dialog.dart';
import '../widgets/info_row.dart';

class GeneralSettingsTab extends StatelessWidget {
  const GeneralSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // App Information Section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const InfoRow(
                  label: 'App Name',
                  value: 'Dancer Ranking App',
                ),
                const SizedBox(height: 8),
                const InfoRow(
                  label: 'Built for',
                  value: 'Private use',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Data Management Section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data Management',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildImportDancersTile(context),
                const Divider(height: 24),
                _buildImportEventsTile(context),
                const Divider(height: 24),
                _buildResetDatabaseTile(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImportDancersTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.person_add,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text(
        'Import Dancers',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'Import dancers from JSON file',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      onTap: () => _importDancers(context),
    );
  }

  Widget _buildImportEventsTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.file_upload,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text(
        'Import Events',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'Import events from JSON file',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      onTap: () => _importEvents(context),
    );
  }

  void _importDancers(BuildContext context) {
    ActionLogger.logUserAction(
        'GeneralSettingsTab', 'import_dancers_dialog_opened', {
      'source': 'settings',
    });

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      pageBuilder: (context, animation, secondaryAnimation) =>
          const Dialog.fullscreen(
        child: ImportDancersDialog(),
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation.drive(Tween(begin: 0.9, end: 1.0)),
            child: child,
          ),
        );
      },
    ).then((result) {
      if (result == true && context.mounted) {
        ActionLogger.logUserAction(
            'GeneralSettingsTab', 'import_dancers_completed', {});
        ToastHelper.showSuccess(context, 'Dancers imported successfully');
      }
    });
  }

  void _importEvents(BuildContext context) {
    ActionLogger.logUserAction(
        'GeneralSettingsTab', 'import_events_dialog_opened', {
      'source': 'settings',
    });

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      pageBuilder: (context, animation, secondaryAnimation) => Provider(
        create: (context) => EventImportService(
          Provider.of<AppDatabase>(context, listen: false),
        ),
        child: const Dialog.fullscreen(
          child: ImportEventsDialog(),
        ),
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation.drive(Tween(begin: 0.9, end: 1.0)),
            child: child,
          ),
        );
      },
    ).then((result) {
      if (result == true && context.mounted) {
        ActionLogger.logUserAction(
            'GeneralSettingsTab', 'import_events_completed', {});
        ToastHelper.showSuccess(context, 'Events imported successfully');
      }
    });
  }

  Widget _buildResetDatabaseTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.refresh,
        color: Theme.of(context).colorScheme.error,
      ),
      title: Text(
        'Reset Database',
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'Clear all data and reset to defaults',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      onTap: () => _showResetConfirmationDialog(context),
    );
  }

  Future<void> _showResetConfirmationDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        bool includeTestData = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  const Text('Reset Database'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'This action will permanently delete all your data including:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  const Text('• All events and their data'),
                  const Text('• All dancers and their information'),
                  const Text('• All rankings and attendance records'),
                  const Text('• All dance recordings and scores'),
                  const Text('• Custom tags and associations'),
                  const Text('• All ranks, tags, and scores'),
                  const SizedBox(height: 12),
                  Text(
                    'Essential system defaults (ranks, tags, scores) will be restored.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'These are required for the app to function and cannot be disabled.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: const Text('Include test data'),
                    subtitle: Text(
                      'Add sample events, dancers, and data for testing',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    value: includeTestData,
                    onChanged: (value) {
                      setState(() {
                        includeTestData = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'This action cannot be undone!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop({
                    'confirmed': true,
                    'includeTestData': includeTestData,
                  }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
                  child: const Text('Reset Database'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && result['confirmed'] == true && context.mounted) {
      await _performDatabaseReset(context, result['includeTestData'] as bool);
    }
  }

  Future<void> _performDatabaseReset(
      BuildContext context, bool includeTestData) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Resetting database...'),
                  ],
                ),
              ),
            ),
          );
        },
      );

      // Get database instance and reset
      final database = Provider.of<AppDatabase>(context, listen: false);
      await database.resetDatabase(includeTestData: includeTestData);

      if (context.mounted) {
        // Close loading dialog
        Navigator.of(context).pop();

        // Show success message
        final message = includeTestData
            ? 'Database reset successfully. All user data cleared, essential defaults and test data restored.'
            : 'Database reset successfully. All user data cleared, essential defaults restored.';
        ToastHelper.showSuccess(context, message);
      }
    } catch (e) {
      if (context.mounted) {
        // Close loading dialog if it's open
        Navigator.of(context).pop();

        // Show error message
        ToastHelper.showError(
          context,
          'Failed to reset database: ${e.toString()}',
        );
      }
    }
  }
}
