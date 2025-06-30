import 'package:flutter/material.dart';

import '../models/dancer_with_tags.dart';
import '../utils/action_logger.dart';

class DancerCardWithTags extends StatelessWidget {
  final DancerWithTags dancerWithTags;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DancerCardWithTags({
    super.key,
    required this.dancerWithTags,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dancer = dancerWithTags.dancer;
    final tags = dancerWithTags.tags;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          dancer.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notes
            if (dancer.notes != null && dancer.notes!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                dancer.notes!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            // Tags
            if (tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4.0,
                runSpacing: 2.0,
                children: tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
        onTap: () => _showDancerContextMenu(context),
      ),
    );
  }

  void _showDancerContextMenu(BuildContext context) {
    final dancer = dancerWithTags.dancer;

    ActionLogger.logAction('UI_DancerCard', 'dancer_context_menu_opened', {
      'dancerId': dancer.id,
      'dancerName': dancer.name,
    });

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dancer.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text('Edit'),
                onTap: () {
                  ActionLogger.logAction(
                      'UI_DancerCard', 'context_edit_tapped', {
                    'dancerId': dancer.id,
                    'dancerName': dancer.name,
                  });

                  Navigator.pop(context);
                  onEdit();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: const Text('Delete'),
                onTap: () {
                  ActionLogger.logAction(
                      'UI_DancerCard', 'context_delete_tapped', {
                    'dancerId': dancer.id,
                    'dancerName': dancer.name,
                  });

                  Navigator.pop(context);
                  onDelete();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
