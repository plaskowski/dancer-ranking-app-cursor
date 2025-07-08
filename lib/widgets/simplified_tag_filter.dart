import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/dancer/dancer_activity_service.dart';
import '../services/tag_service.dart';

class SimplifiedTagFilter extends StatefulWidget {
  final List<int> selectedTagIds;
  final Function(List<int>) onTagsChanged;
  final Function(String)? onSearchChanged;
  final Function(ActivityLevel)? onActivityChanged;
  final bool showClearButton;
  final String searchHintText;
  final String? initialSearchQuery;
  final ActivityLevel? initialActivityLevel;

  const SimplifiedTagFilter({
    super.key,
    required this.selectedTagIds,
    required this.onTagsChanged,
    this.onSearchChanged,
    this.onActivityChanged,
    this.showClearButton = true,
    this.searchHintText = 'Search dancers...',
    this.initialSearchQuery,
    this.initialActivityLevel,
  });

  @override
  State<SimplifiedTagFilter> createState() => _SimplifiedTagFilterState();
}

class _SimplifiedTagFilterState extends State<SimplifiedTagFilter> {
  List<Tag> _availableTags = [];
  bool _isLoading = true;
  List<int> _pendingTagIds = [];
  late String _searchQuery;
  late ActivityLevel _activityLevel;
  Timer? _searchDebounce;
  late TextEditingController _searchController;
  bool _showActivityDropdown = false;

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.initialSearchQuery ?? '';
    _activityLevel = widget.initialActivityLevel ?? ActivityLevel.regular;
    _searchController = TextEditingController(text: _searchQuery);
    _loadTags();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
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

    // Immediately apply changes to trigger dancer list refresh
    widget.onTagsChanged(newPendingTags);

    print('New pending tags: $_pendingTagIds');
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;

    // Debounce search to avoid excessive API calls
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      widget.onSearchChanged?.call(query);
    });
  }

  void _onActivityChanged(ActivityLevel activity) {
    setState(() {
      _activityLevel = activity;
      _showActivityDropdown = false; // Close dropdown after selection
    });
    widget.onActivityChanged?.call(activity);
  }

  String _getActivityLevelDisplayName(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.all:
        return 'All';
      case ActivityLevel.regular:
        return 'Regular';
      case ActivityLevel.occasional:
        return 'Occasional';
    }
  }

  String _getActivityLevelDescription(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.all:
        return 'Show everyone';
      case ActivityLevel.regular:
        return '3+ dances in last 2 months';
      case ActivityLevel.occasional:
        return '1+ dance in last 3 months';
    }
  }

  void _showTagFilterFlyout() {
    // Initialize pending tags with current selection
    setState(() {
      _pendingTagIds = List<int>.from(widget.selectedTagIds);
    });

    // Show the tag filter bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildTagFilterBottomSheet(),
    );
  }

  Widget _buildTagFilterBottomSheet() {
    return StatefulBuilder(
      builder: (context, setState) {
        return SafeArea(
          child: Container(
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
              // Search field
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: widget.searchHintText,
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Tags filter
              GestureDetector(
                onTap: _showTagFilterFlyout,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.outline),
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

              // Activity filter
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showActivityDropdown = !_showActivityDropdown;
                  });
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.track_changes,
                          color: Colors.grey.shade600, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        _getActivityLevelDisplayName(_activityLevel),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down,
                          color: Colors.grey.shade600, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Activity Dropdown (following existing pattern)
        if (_showActivityDropdown)
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
                    '🎯 Activity Level:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                ...ActivityLevel.values.map((level) {
                  final isSelected = _activityLevel == level;

                  return InkWell(
                    onTap: () => _onActivityChanged(level),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getActivityLevelDisplayName(level),
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _getActivityLevelDescription(level),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
      ],
    );
  }
}
