import 'dart:async';

import 'package:flutter/material.dart';

import '../database/database.dart';
import '../services/dancer/dancer_activity_service.dart';
import 'tag_selection_flyout.dart';

class CombinedDancerFilter extends StatefulWidget {
  final Function(String, List<int>, ActivityLevel?) onFiltersChanged;
  final Map<ActivityLevel, int>? activityLevelCounts;
  final List<Tag> availableTags;

  const CombinedDancerFilter({
    super.key,
    required this.onFiltersChanged,
    required this.availableTags,
    this.activityLevelCounts,
  });

  @override
  State<CombinedDancerFilter> createState() => _CombinedDancerFilterState();
}

class _CombinedDancerFilterState extends State<CombinedDancerFilter> {
  String _searchQuery = '';
  List<int> _selectedTagIds = [];
  List<Tag> _selectedTags = [];
  ActivityLevel? _selectedActivityLevel = ActivityLevel.all;
  bool _isLoadingCounts = false;
  bool _showTagDropdown = false;
  bool _showActivityDropdown = false;

  // Debounce timer for search
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _loadActivityLevelCounts();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _loadActivityLevelCounts() async {
    setState(() {
      _isLoadingCounts = true;
    });

    // TODO: Implement when activity service is ready
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading

    if (mounted) {
      setState(() {
        _isLoadingCounts = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = query;
      });
      _notifyParent();
    });
  }

  void _onActivityLevelChanged(ActivityLevel? level) {
    setState(() {
      _selectedActivityLevel = level;
      _showActivityDropdown = false; // Close dropdown immediately
    });
    _notifyParent();
  }

  void _notifyParent() {
    widget.onFiltersChanged(_searchQuery, _selectedTagIds, _selectedActivityLevel);
  }

  String _getLevelDisplayName(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.all:
        return 'All Dancers';
      case ActivityLevel.regular:
        return 'Regular';
      case ActivityLevel.occasional:
        return 'Occasional';
    }
  }

  String _getLevelDescription(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.all:
        return 'Show everyone';
      case ActivityLevel.regular:
        return '3+ dances in last 2 months';
      case ActivityLevel.occasional:
        return '1+ dance in last 3 months';
    }
  }

  int _getLevelCount(ActivityLevel level) {
    return widget.activityLevelCounts?[level] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter Bar
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              // Search field
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search dancers...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade600, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Tags filter
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showTagDropdown = !_showTagDropdown;
                    _showActivityDropdown = false; // Close other dropdown
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
                        _selectedTagIds.isNotEmpty ? '${_selectedTagIds.length} Tags' : 'Tags',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down, color: Colors.grey.shade600, size: 16),
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
                    _showTagDropdown = false; // Close other dropdown
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
                      Icon(Icons.track_changes, color: Colors.grey.shade600, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        _selectedActivityLevel != null ? _getLevelDisplayName(_selectedActivityLevel!) : 'Active',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down, color: Colors.grey.shade600, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Tag Dropdown
        if (_showTagDropdown)
          TagSelectionFlyout(
            availableTags: widget.availableTags,
            selectedTags: _selectedTags,
            onTagsChanged: (List<Tag> newTags) {
              setState(() {
                _selectedTags = newTags;
                _selectedTagIds = newTags.map((tag) => tag.id).toList();
                _showTagDropdown = false; // Close dropdown after selection
              });
              _notifyParent();
            },
          ),

        // Activity Dropdown
        if (_showActivityDropdown)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
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
                  final isSelected = _selectedActivityLevel == level;
                  final count = _getLevelCount(level);

                  return InkWell(
                    onTap: () => _onActivityLevelChanged(level),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_getLevelDisplayName(level)} ($count)',
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _getLevelDescription(level),
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
