import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/database.dart';
import '../../../services/tag_service.dart';
import '../../../utils/action_logger.dart';

class TagsManagementTab extends StatefulWidget {
  const TagsManagementTab({super.key});

  @override
  State<TagsManagementTab> createState() => _TagsManagementTabState();
}

class _TagsManagementTabState extends State<TagsManagementTab> {
  late TagService tagService;
  List<TagWithUsageCount> _tagsWithUsage = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    tagService = Provider.of<TagService>(context, listen: false);
    ActionLogger.logAction('UI_TagsManagementTab', 'tab_initialized');
    _loadTags();
  }

  @override
  void dispose() {
    ActionLogger.logAction('UI_TagsManagementTab', 'tab_disposed');
    super.dispose();
  }

  Future<void> _loadTags() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tagsWithUsage = await tagService.getAllTagsWithUsageCount();
      setState(() {
        _tagsWithUsage = tagsWithUsage;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load tags: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _showAddTagDialog() async {
    final controller = TextEditingController();

    ActionLogger.logAction('UI_TagsManagementTab', 'add_tag_dialog_opened');

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
                  'UI_TagsManagementTab', 'add_tag_dialog_cancelled');
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ActionLogger.logAction(
                  'UI_TagsManagementTab', 'add_tag_dialog_confirmed', {
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

  Future<void> _createTag(String name) async {
    try {
      ActionLogger.logAction('UI_TagsManagementTab', 'creating_tag', {
        'tagName': name,
      });

      await tagService.createTag(name);
      await _loadTags(); // Reload to show updated usage stats

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tag "$name" created successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        ActionLogger.logAction('UI_TagsManagementTab', 'tag_created_success', {
          'tagName': name,
        });
      }
    } catch (e) {
      ActionLogger.logError('UI_TagsManagementTab', 'create_tag_failed', {
        'tagName': name,
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

    ActionLogger.logAction('UI_TagsManagementTab', 'edit_tag_dialog_opened', {
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
                  'UI_TagsManagementTab', 'edit_tag_dialog_cancelled');
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ActionLogger.logAction(
                  'UI_TagsManagementTab', 'edit_tag_dialog_confirmed', {
                'tagId': tag.id,
                'oldName': tag.name,
                'newName': controller.text.trim(),
              });
              Navigator.of(context).pop(true);
            },
            child: const Text('Save'),
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
      ActionLogger.logAction('UI_TagsManagementTab', 'updating_tag', {
        'tagId': tag.id,
        'oldName': tag.name,
        'newName': newName,
      });

      final success = await tagService.updateTag(
        id: tag.id,
        name: newName,
      );

      if (mounted) {
        if (success) {
          await _loadTags(); // Reload to show updated stats
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tag updated to "$newName"'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );

          ActionLogger.logAction(
              'UI_TagsManagementTab', 'tag_updated_success', {
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
      ActionLogger.logError('UI_TagsManagementTab', 'update_tag_failed', {
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tagsWithUsage.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.label_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No tags found', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text(
                        'Tap + to add your first tag',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _tagsWithUsage.length,
                  itemBuilder: (context, index) {
                    final tagWithUsage = _tagsWithUsage[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          tagWithUsage.tag.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          '${tagWithUsage.usageCount} dancers',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        onTap: () =>
                            _showTagContextMenu(context, tagWithUsage.tag),
                      ),
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

  void _showTagContextMenu(BuildContext context, Tag tag) {
    ActionLogger.logAction('UI_TagsManagementTab', 'tag_context_menu_opened', {
      'tagId': tag.id,
      'tagName': tag.name,
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
                tag.name,
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
                      'UI_TagsManagementTab', 'context_edit_tapped', {
                    'tagId': tag.id,
                    'tagName': tag.name,
                  });

                  Navigator.pop(context);
                  _showEditTagDialog(tag);
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
                      'UI_TagsManagementTab', 'context_delete_tapped', {
                    'tagId': tag.id,
                    'tagName': tag.name,
                  });

                  Navigator.pop(context);
                  _showDeleteTagDialog(tag);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteTagDialog(Tag tag) async {
    ActionLogger.logAction('UI_TagsManagementTab', 'delete_tag_dialog_opened', {
      'tagId': tag.id,
      'tagName': tag.name,
    });

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tag'),
        content: Text(
          'Delete "${tag.name}"?\n\nThis will remove the tag from all dancers who have it. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              ActionLogger.logAction(
                  'UI_TagsManagementTab', 'delete_tag_dialog_cancelled');
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ActionLogger.logAction(
                  'UI_TagsManagementTab', 'delete_tag_dialog_confirmed', {
                'tagId': tag.id,
                'tagName': tag.name,
              });
              Navigator.of(context).pop(true);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _deleteTag(tag);
    }
  }

  Future<void> _deleteTag(Tag tag) async {
    try {
      ActionLogger.logAction('UI_TagsManagementTab', 'deleting_tag', {
        'tagId': tag.id,
        'tagName': tag.name,
      });

      final success = await tagService.deleteTag(tag.id);

      if (mounted) {
        if (success) {
          await _loadTags(); // Reload to show updated stats
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tag "${tag.name}" deleted'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );

          ActionLogger.logAction(
              'UI_TagsManagementTab', 'tag_deleted_success', {
            'tagId': tag.id,
            'tagName': tag.name,
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to delete tag'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    } catch (e) {
      ActionLogger.logError('UI_TagsManagementTab', 'delete_tag_failed', {
        'tagId': tag.id,
        'tagName': tag.name,
        'error': e.toString(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete tag: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
