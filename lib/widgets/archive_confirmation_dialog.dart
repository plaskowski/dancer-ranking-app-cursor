import 'package:flutter/material.dart';

class ArchiveConfirmationDialog extends StatelessWidget {
  final String dancerName;
  final VoidCallback onConfirm;

  const ArchiveConfirmationDialog({
    super.key,
    required this.dancerName,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Archive Dancer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Archive "$dancerName"? This will:'),
          const SizedBox(height: 16),
          const Text('• Hide them from event planning'),
          const Text('• Preserve all dance history'),
          const Text('• Allow easy reactivation later'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Archiving is reversible - you can reactivate them anytime',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
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
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
          child: const Text('Archive'),
        ),
      ],
    );
  }
}
