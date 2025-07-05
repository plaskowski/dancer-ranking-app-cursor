import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/tag_service.dart';

enum ActivityLevel {
  all,
  active,
  veryActive,
  core,
  recent,
}

class CompactDancerFilter extends StatefulWidget {
  final String searchQuery;
  final Function(String) onSearchChanged;
  final int? selectedTagId;
  final Function(int?) onTagChanged;
  final ActivityLevel selectedActivityLevel;
  final Function(ActivityLevel?) onActivityLevelChanged;

  const CompactDancerFilter({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.selectedTagId,
    required this.onTagChanged,
    required this.selectedActivityLevel,
    required this.onActivityLevelChanged,
  });

  @override
  State<CompactDancerFilter> createState() => _CompactDancerFilterState();
}

class _CompactDancerFilterState extends State<CompactDancerFilter> {
  List<Tag> _availableTags = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    try {
      final tagService = Provider.of<TagService>(context, listen: false);
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

  String _getActivityLevelLabel(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.all:
        return 'All';
      case ActivityLevel.active:
        return 'Active';
      case ActivityLevel.veryActive:
        return 'Very Active';
      case ActivityLevel.core:
        return 'Core';
      case ActivityLevel.recent:
        return 'Recent';
    }
  }

  IconData _getActivityLevelIcon(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.all:
        return Icons.people_outlined;
      case ActivityLevel.active:
        return Icons.person_outline;
      case ActivityLevel.veryActive:
        return Icons.person;
      case ActivityLevel.core:
        return Icons.star_outline;
      case ActivityLevel.recent:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search dancers...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: widget.onSearchChanged,
            controller: TextEditingController(text: widget.searchQuery),
          ),
          const SizedBox(height: 12),

          // Compact filter row
          Row(
            children: [
              // Tag filter dropdown
              Expanded(
                flex: 2,
                child: _buildTagDropdown(),
              ),
              const SizedBox(width: 8),
              // Activity level dropdown
              Expanded(
                flex: 2,
                child: _buildActivityDropdown(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTagDropdown() {
    if (_isLoading) {
      return Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Center(
          child: SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return DropdownButtonFormField<int>(
      value: widget.selectedTagId,
      decoration: const InputDecoration(
        labelText: 'Tags',
        prefixIcon: Icon(Icons.label_outline),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: [
        const DropdownMenuItem<int>(
          child: Text('All Tags'),
        ),
        ..._availableTags.map((tag) => DropdownMenuItem<int>(
              value: tag.id,
              child: Text(tag.name),
            )),
      ],
      onChanged: widget.onTagChanged,
    );
  }

  Widget _buildActivityDropdown() {
    return DropdownButtonFormField<ActivityLevel>(
      value: widget.selectedActivityLevel,
      decoration: InputDecoration(
        labelText: 'Activity',
        prefixIcon: Icon(_getActivityLevelIcon(widget.selectedActivityLevel)),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: ActivityLevel.values
          .map((level) => DropdownMenuItem<ActivityLevel>(
                value: level,
                child: Text(_getActivityLevelLabel(level)),
              ))
          .toList(),
      onChanged: widget.onActivityLevelChanged,
    );
  }
}
