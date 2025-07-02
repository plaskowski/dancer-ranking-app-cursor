import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/tag_service.dart';

class TagFilterChips extends StatefulWidget {
  final int? selectedTagId;
  final Function(int?) onTagChanged;
  final bool showClearButton;

  const TagFilterChips({
    super.key,
    required this.selectedTagId,
    required this.onTagChanged,
    this.showClearButton = true,
  });

  @override
  State<TagFilterChips> createState() => _TagFilterChipsState();
}

class _TagFilterChipsState extends State<TagFilterChips> {
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
      // Handle error silently - tags are not critical for basic functionality
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onTagSelected(int tagId) {
    // If same tag is selected, deselect it
    if (widget.selectedTagId == tagId) {
      widget.onTagChanged(null);
    } else {
      widget.onTagChanged(tagId);
    }
  }

  void _clearSelection() {
    widget.onTagChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_availableTags.isEmpty) {
      // Show empty tag filter row (no chips, no clear button)
      return const SizedBox(
        height: 48,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                'No tags available',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // Tag chips in scrollable row
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _availableTags.map((tag) {
                  final isSelected = widget.selectedTagId == tag.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(tag.name),
                      selected: isSelected,
                      onSelected: (_) => _onTagSelected(tag.id),
                      showCheckmark: false,
                      selectedColor: Theme.of(context).colorScheme.primaryContainer,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Clear button (only visible when tag is selected)
          if (widget.showClearButton && widget.selectedTagId != null)
            IconButton(
              onPressed: _clearSelection,
              icon: const Icon(Icons.close),
              tooltip: 'Clear tag filter',
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}
