import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dancer_with_tags.dart';
import '../screens/dancer_history_screen.dart';
import '../services/dancer/dancer_crud_service.dart';
import '../utils/action_logger.dart';
import '../utils/toast_helper.dart';
import 'archive_confirmation_dialog.dart';

class DancerCardWithTags extends StatelessWidget {
  final DancerWithTags dancerWithTags;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onMerge;

  const DancerCardWithTags({
    super.key,
    required this.dancerWithTags,
    required this.onEdit,
    required this.onDelete,
    required this.onMerge,
  });

  @override
  Widget build(BuildContext context) {
    final dancer = dancerWithTags.dancer;
    final tags = dancerWithTags.tags;
    final isArchived = dancer.isArchived;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isArchived ? Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5) : null,
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                dancer.name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isArchived ? Theme.of(context).colorScheme.onSurfaceVariant : null,
                ),
              ),
            ),
            if (isArchived)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'archived',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
              ),
          ],
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
          child: SingleChildScrollView(
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
                    ActionLogger.logAction('UI_DancerCard', 'context_edit_tapped', {
                      'dancerId': dancer.id,
                      'dancerName': dancer.name,
                    });

                    Navigator.pop(context);
                    onEdit();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.merge_type,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: const Text('Merge into...'),
                  onTap: () {
                    ActionLogger.logAction('UI_DancerCard', 'context_merge_tapped', {
                      'dancerId': dancer.id,
                      'dancerName': dancer.name,
                    });

                    Navigator.pop(context);
                    onMerge();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.history,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  title: const Text('View History'),
                  onTap: () {
                    ActionLogger.logAction('UI_DancerCard', 'context_history_tapped', {
                      'dancerId': dancer.id,
                      'dancerName': dancer.name,
                    });

                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DancerHistoryScreen(
                        dancerId: dancer.id,
                        dancerName: dancer.name,
                      ),
                    ));
                  },
                ),
                // Archive/Reactivate action
                ListTile(
                  leading: Icon(
                    dancer.isArchived ? Icons.restore : Icons.archive,
                    color: dancer.isArchived
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.tertiary,
                  ),
                  title: Text(dancer.isArchived ? 'Reactivate' : 'Archive'),
                  onTap: () async {
                    ActionLogger.logAction('UI_DancerCard', 'context_archive_tapped', {
                      'dancerId': dancer.id,
                      'dancerName': dancer.name,
                      'isArchived': dancer.isArchived,
                      'action': dancer.isArchived ? 'reactivate' : 'archive',
                    });

                    Navigator.pop(context);

                    if (dancer.isArchived) {
                      // Reactivate immediately (no confirmation needed)
                      try {
                        final crudService = Provider.of<DancerCrudService>(context, listen: false);
                        final success = await crudService.reactivateDancer(dancer.id);
                        if (success && context.mounted) {
                          ToastHelper.showSuccess(context, '${dancer.name} reactivated');
                        } else if (context.mounted) {
                          ToastHelper.showError(context, 'Failed to reactivate ${dancer.name}');
                        }
                      } catch (e) {
                        ActionLogger.logError('UI_DancerCard', 'reactivate_action_error', {
                          'dancerId': dancer.id,
                          'dancerName': dancer.name,
                          'error': e.toString(),
                        });

                        if (context.mounted) {
                          ToastHelper.showError(context, 'Error: $e');
                        }
                      }
                    } else {
                      // Show confirmation dialog for archiving
                      showDialog(
                        context: context,
                        builder: (context) => ArchiveConfirmationDialog(
                          dancerName: dancer.name,
                          onConfirm: () async {
                            try {
                              final crudService = Provider.of<DancerCrudService>(context, listen: false);
                              final success = await crudService.archiveDancer(dancer.id);
                              if (success && context.mounted) {
                                ToastHelper.showSuccess(context, '${dancer.name} archived');
                              } else if (context.mounted) {
                                ToastHelper.showError(context, 'Failed to archive ${dancer.name}');
                              }
                            } catch (e) {
                              ActionLogger.logError('UI_DancerCard', 'archive_action_error', {
                                'dancerId': dancer.id,
                                'dancerName': dancer.name,
                                'error': e.toString(),
                              });

                              if (context.mounted) {
                                ToastHelper.showError(context, 'Error: $e');
                              }
                            }
                          },
                        ),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: const Text('Delete'),
                  onTap: () {
                    ActionLogger.logAction('UI_DancerCard', 'context_delete_tapped', {
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
      ),
    );
  }
}
