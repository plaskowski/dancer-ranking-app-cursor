import 'package:flutter/material.dart';

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

        // Placeholder for future settings
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
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  title: Text(
                    'More settings coming soon',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
