import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/tag_service.dart';

class SimplifiedTagFilter extends StatefulWidget {
  final List<int> selectedTagIds;
  final Function(List<int>) onTagsChanged;
  final bool showClearButton;

  const SimplifiedTagFilter({
    super.key,
    required this.selectedTagIds,
    required this.onTagsChanged,
    this.showClearButton = true,
  });

  @override
  State<SimplifiedTagFilter> createState() => _SimplifiedTagFilterState();
}

class _SimplifiedTagFilterState extends State<SimplifiedTagFilter> {
  List<Tag> _availableTags = [];
  bool _isLoading = true;
  List<int> _pendingTagIds = [];

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    try {
      final database = Provider.of<AppDatabase>(context, listen: false);
      final tagService = TagService(database);
      final tags = await tagService.getTagsWithDancers();

      if (mounted) {
        setState(() {
          _availableTags = tags;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onTagSelected(int tagId) {
    print('Tag tapped: $tagId, current pending: $_pendingTagIds');
    final newPendingTags = List<int>.from(_pendingTagIds);

    if (newPendingTags.contains(tagId)) {
      newPendingTags.remove(tagId);
      print('Removed tag $tagId');
    } else {
      newPendingTags.add(tagId);
      print('Added tag $tagId');
    }

    setState(() {
      _pendingTagIds = newPendingTags;
    });
    print('New pending tags: $_pendingTagIds');
  }

  void _clearSelection() {
    setState(() {
      _pendingTagIds = [];
    });
  }

  void _applyChanges() {
    widget.onTagsChanged(_pendingTagIds);
  }

  void _showTagFilterBottomSheet() {
    // Initialize pending tags with current selection
    setState(() {
      _pendingTagIds = List<int>.from(widget.selectedTagIds);
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildTagFilterBottomSheet(),
    ).then((_) {
      // Apply changes when bottom sheet is closed
      _applyChanges();
    });
  }

  Widget _buildTagFilterBottomSheet() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              const Text(
                '🏷️ Filter by Tags',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Tags as pills
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_availableTags.isEmpty)
                const Text(
                  'No tags available',
                  style: TextStyle(color: Colors.grey),
                )
              else
                Flexible(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _availableTags.map((tag) {
                      final isSelected = _pendingTagIds.contains(tag.id);
                      print(
                          'Building pill for tag ${tag.name} (ID: ${tag.id}), isSelected: $isSelected');

                      return GestureDetector(
                        onTap: () {
                          print(
                              'Pill tapped for tag: ${tag.name} (ID: ${tag.id})');
                          _onTagSelected(tag.id);
                          // Force rebuild of the StatefulBuilder
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          child: Text(
                            tag.name,
                            style: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

              // Bottom padding for safe area
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // Search field (placeholder for now)
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(Icons.search, color: Colors.grey.shade600, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Search dancers...',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Tags filter
              GestureDetector(
                onTap: _showTagFilterBottomSheet,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.label, color: Colors.grey.shade600, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        _pendingTagIds.isNotEmpty
                            ? '${_pendingTagIds.length} Tags'
                            : 'Tags',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down,
                          color: Colors.grey.shade600, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Activity filter (placeholder)
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.track_changes,
                        color: Colors.grey.shade600, size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      'Active',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_drop_down,
                        color: Colors.grey.shade600, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
