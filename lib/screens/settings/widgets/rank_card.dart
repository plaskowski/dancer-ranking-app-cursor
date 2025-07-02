import 'package:flutter/material.dart';

import '../../../services/ranking_service.dart';

class RankCard extends StatelessWidget {
  final RankWithUsage rankWithUsage;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  const RankCard({
    super.key,
    required this.rankWithUsage,
    required this.index,
    required this.onEdit,
    required this.onArchive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final rank = rankWithUsage.rank;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          '${rank.name} • ${rankWithUsage.usageCount} attendances',
          style: const TextStyle(fontSize: 16),
        ),
        subtitle: rank.isArchived
            ? Text(
                'Archived',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        onTap: () => _showContextMenu(context),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    final rank = rankWithUsage.rank;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                onEdit();
              },
            ),
            ListTile(
              leading: Icon(rank.isArchived ? Icons.unarchive : Icons.archive),
              title: Text(rank.isArchived ? 'Un-archive' : 'Archive'),
              onTap: () {
                Navigator.pop(context);
                onArchive();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
