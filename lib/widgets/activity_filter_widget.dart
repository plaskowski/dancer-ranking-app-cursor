import 'package:flutter/material.dart';

import '../services/dancer/dancer_activity_service.dart';

class ActivityFilterWidget extends StatefulWidget {
  final ActivityLevel? selectedLevel;
  final Function(ActivityLevel?) onLevelChanged;
  final Map<ActivityLevel, int>? levelCounts;

  const ActivityFilterWidget({
    super.key,
    required this.selectedLevel,
    required this.onLevelChanged,
    this.levelCounts,
  });

  @override
  State<ActivityFilterWidget> createState() => _ActivityFilterWidgetState();
}

class _ActivityFilterWidgetState extends State<ActivityFilterWidget> {
  bool _showDropdown = false;

  String _getLevelDisplayName(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.all:
        return 'All Dancers';
      case ActivityLevel.active:
        return 'Active';
      case ActivityLevel.veryActive:
        return 'Very Active';
      case ActivityLevel.coreCommunity:
        return 'Core Community';
      case ActivityLevel.recent:
        return 'Recent';
    }
  }

  String _getLevelDescription(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.all:
        return 'Show everyone';
      case ActivityLevel.active:
        return '1+ events in 6 months';
      case ActivityLevel.veryActive:
        return '3+ events in 6 months';
      case ActivityLevel.coreCommunity:
        return '5+ events in year';
      case ActivityLevel.recent:
        return '1+ events in 3 months';
    }
  }

  int _getLevelCount(ActivityLevel level) {
    return widget.levelCounts?[level] ?? 0;
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

              // Tags filter (placeholder)
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
                    Icon(Icons.label, color: Colors.grey.shade600, size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      'Tags',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_drop_down, color: Colors.grey.shade600, size: 16),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Activity filter
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
                      Icon(Icons.track_changes, color: Colors.grey.shade600, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        widget.selectedLevel != null ? _getLevelDisplayName(widget.selectedLevel!) : 'Active',
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
                    '🎯 Activity Level:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                ...ActivityLevel.values.map((level) {
                  final isSelected = widget.selectedLevel == level;
                  final count = _getLevelCount(level);

                  return InkWell(
                    onTap: () {
                      widget.onLevelChanged(level);
                      setState(() {
                        _showDropdown = false;
                      });
                    },
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
