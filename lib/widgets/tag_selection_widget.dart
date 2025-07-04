import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/tag_service.dart';

class TagSelectionWidget extends StatefulWidget {
  final Set<int> selectedTagIds;
  final Function(Set<int>) onTagsChanged;
  final int? dancerId; // If provided, load existing tags for this dancer

  const TagSelectionWidget({
    super.key,
    required this.selectedTagIds,
    required this.onTagsChanged,
    this.dancerId,
  });

  @override
  State<TagSelectionWidget> createState() => _TagSelectionWidgetState();
}

class _TagSelectionWidgetState extends State<TagSelectionWidget> {
  List<Tag> _allTags = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    try {
      final tagService = Provider.of<TagService>(context, listen: false);

      // Load all available tags
      final tags = await tagService.watchAllTags().first;

      // If editing existing dancer, load current tags
      Set<int> selectedTags = Set.from(widget.selectedTagIds);
      if (widget.dancerId != null) {
        final dancerTags = await tagService.getDancerTags(widget.dancerId!);
        selectedTags = dancerTags.map((tag) => tag.id).toSet();
        widget.onTagsChanged(selectedTags);
      }

      if (mounted) {
        setState(() {
          _allTags = tags;
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

  void _toggleTag(int tagId) {
    final newSelectedTags = Set<int>.from(widget.selectedTagIds);
    if (newSelectedTags.contains(tagId)) {
      newSelectedTags.remove(tagId);
    } else {
      newSelectedTags.add(tagId);
    }
    widget.onTagsChanged(newSelectedTags);
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

    if (_allTags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        // Scrollable oneline tag selection
        SizedBox(
          height: 48,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _allTags.map((tag) {
                final isSelected = widget.selectedTagIds.contains(tag.id);
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(tag.name),
                    selected: isSelected,
                    onSelected: (_) => _toggleTag(tag.id),
                    showCheckmark: false,
                    selectedColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
