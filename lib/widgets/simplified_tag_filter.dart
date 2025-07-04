import 'package:flutter/material.dart';

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
  bool _showDropdown = false;

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    try {
      final tagService = TagService(AppDatabase());
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
    final newSelectedTags = List<int>.from(widget.selectedTagIds);

    if (newSelectedTags.contains(tagId)) {
      newSelectedTags.remove(tagId);
    } else {
      newSelectedTags.add(tagId);
    }

    widget.onTagsChanged(newSelectedTags);
    setState(() {
      _showDropdown = false; // Close dropdown immediately
    });
  }

  void _clearSelection() {
    widget.onTagsChanged([]);
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
                onTap: () {
                  setState(() {
                    _showDropdown = !_showDropdown;
                  });
                },
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
                        widget.selectedTagIds.isNotEmpty ? '${widget.selectedTagIds.length} Tags' : 'Tags',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down, color: Colors.grey.shade600, size: 16),
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
                    Icon(Icons.track_changes, color: Colors.grey.shade600, size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      'Active',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_drop_down, color: Colors.grey.shade600, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Dropdown
        if (_showDropdown)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    '🏷️ Tags:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_availableTags.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('No tags available'),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _availableTags.map((tag) {
                        final isSelected = widget.selectedTagIds.contains(tag.id);

                        return GestureDetector(
                          onTap: () => _onTagSelected(tag.id),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                            decoration: BoxDecoration(
                              color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              tag.name,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                if (widget.showClearButton && widget.selectedTagIds.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextButton(
                      onPressed: _clearSelection,
                      child: const Text('Clear All'),
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
      ],
    );
  }
}
