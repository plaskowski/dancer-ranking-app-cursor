import 'package:flutter/material.dart';

import '../database/database.dart';
import '../services/tag_service.dart';
import '../utils/action_logger.dart';

class TagsScreen extends StatefulWidget {
  final TagService tagService;

  const TagsScreen({super.key, required this.tagService});

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  @override
  void initState() {
    super.initState();
    ActionLogger.logAction('UI_TagsScreen', 'screen_initialized');
  }

  @override
  void dispose() {
    ActionLogger.logAction('UI_TagsScreen', 'screen_disposed');
    super.dispose();
  }

  Future<void> _showAddTagDialog() async {
    final controller = TextEditingController();

    ActionLogger.logAction('UI_TagsScreen', 'add_tag_dialog_opened');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Tag'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Tag name',
            hintText: 'Enter tag name',
          ),
          autofocus: true,
          onSubmitted: (_) => Navigator.of(context).pop(true),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ActionLogger.logAction(
                  'UI_TagsScreen', 'add_tag_dialog_cancelled');
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ActionLogger.logAction(
                  'UI_TagsScreen', 'add_tag_dialog_confirmed', {
                'tagName': controller.text.trim(),
              });
              Navigator.of(context).pop(true);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result == true && controller.text.trim().isNotEmpty) {
      await _createTag(controller.text.trim());
    }
  }

  Future<void> _createTag(String tagName) async {
    try {
      ActionLogger.logAction('UI_TagsScreen', 'creating_tag', {
        'tagName': tagName,
      });

      await widget.tagService.createTag(tagName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tag "$tagName" created successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        ActionLogger.logAction('UI_TagsScreen', 'tag_created_success', {
          'tagName': tagName,
        });
      }
    } catch (e) {
      ActionLogger.logError('UI_TagsScreen', 'create_tag_failed', {
        'tagName': tagName,
        'error': e.toString(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create tag: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _showEditTagDialog(Tag tag) async {
    final controller = TextEditingController(text: tag.name);

    ActionLogger.logAction('UI_TagsScreen', 'edit_tag_dialog_opened', {
      'tagId': tag.id,
      'tagName': tag.name,
    });

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Tag'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Tag name',
            hintText: 'Enter tag name',
          ),
          autofocus: true,
          onSubmitted: (_) => Navigator.of(context).pop(true),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ActionLogger.logAction(
                  'UI_TagsScreen', 'edit_tag_dialog_cancelled');
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ActionLogger.logAction(
                  'UI_TagsScreen', 'edit_tag_dialog_confirmed', {
                'tagId': tag.id,
                'oldName': tag.name,
                'newName': controller.text.trim(),
              });
              Navigator.of(context).pop(true);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );

    if (result == true && controller.text.trim().isNotEmpty) {
      await _updateTag(tag, controller.text.trim());
    }
  }

  Future<void> _updateTag(Tag tag, String newName) async {
    try {
      ActionLogger.logAction('UI_TagsScreen', 'updating_tag', {
        'tagId': tag.id,
        'oldName': tag.name,
        'newName': newName,
      });

      final success = await widget.tagService.updateTag(
        id: tag.id,
        name: newName,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tag updated to "$newName"'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );

          ActionLogger.logAction('UI_TagsScreen', 'tag_updated_success', {
            'tagId': tag.id,
            'oldName': tag.name,
            'newName': newName,
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to update tag'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    } catch (e) {
      ActionLogger.logError('UI_TagsScreen', 'update_tag_failed', {
        'tagId': tag.id,
        'oldName': tag.name,
        'newName': newName,
        'error': e.toString(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update tag: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<List<Tag>>(
        stream: widget.tagService.watchAllTags(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            ActionLogger.logError('UI_TagsScreen', snapshot.error.toString());
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load tags',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final tags = snapshot.data ?? [];

          ActionLogger.logListRendering('UI_TagsScreen', 'tags',
              tags.map((tag) => {'id': tag.id, 'name': tag.name}).toList());

          if (tags.isEmpty) {
            return const Center(
              child: Text(
                'No tags found',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: tags.length,
            itemBuilder: (context, index) {
              final tag = tags[index];
              return ListTile(
                title: Text(tag.name),
                leading: const Icon(Icons.label_outline),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showEditTagDialog(tag);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit'),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTagDialog,
        tooltip: 'Add Tag',
        child: const Icon(Icons.add),
      ),
    );
  }
}
