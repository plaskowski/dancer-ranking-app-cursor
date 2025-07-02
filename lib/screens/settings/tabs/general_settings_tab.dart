import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/database.dart';
import '../../../utils/toast_helper.dart';
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
                  label: 'Version',
                  value: '0.65.2',
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

        // General Settings Section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'General Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildResetDatabaseTile(context),
              ],
            ),
          ),
        ),
      ],
    );
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
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
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
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

    if (confirmed == true && context.mounted) {
      await _performDatabaseReset(context);
    }
  }

  Future<void> _performDatabaseReset(BuildContext context) async {
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
      await database.resetDatabase();

      if (context.mounted) {
        // Close loading dialog
        Navigator.of(context).pop();

        // Show success message
        ToastHelper.showSuccess(
          context,
          'Database reset successfully. All data has been completely cleared.',
        );
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
