import 'package:dancer_ranking_app/database/database.dart';
import 'package:flutter/material.dart';

class TagSelectionFlyout extends StatefulWidget {
  final List<Tag> availableTags;
  final List<Tag> selectedTags;
  final Function(List<Tag>) onTagsChanged;
  final String? title;
  final bool showSearch;
  final int maxHeight;

  const TagSelectionFlyout({
    super.key,
    required this.availableTags,
    required this.selectedTags,
    required this.onTagsChanged,
    this.title,
    this.showSearch = true,
    this.maxHeight = 300,
  });

  @override
  State<TagSelectionFlyout> createState() => _TagSelectionFlyoutState();
}

class _TagSelectionFlyoutState extends State<TagSelectionFlyout> {
  List<Tag> _filteredTags = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredTags = widget.availableTags;
  }

  @override
  void didUpdateWidget(TagSelectionFlyout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.availableTags != widget.availableTags) {
      _filterTags();
    }
  }

  void _filterTags() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _filteredTags = widget.availableTags;
      });
    } else {
      setState(() {
        _filteredTags = widget.availableTags
            .where((tag) =>
                tag.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
      });
    }
  }

  void _toggleTag(Tag tag) {
    final newSelectedTags = List<Tag>.from(widget.selectedTags);
    if (newSelectedTags.contains(tag)) {
      newSelectedTags.remove(tag);
    } else {
      newSelectedTags.add(tag);
    }
    widget.onTagsChanged(newSelectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: widget.maxHeight.toDouble()),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          if (widget.showSearch)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search tags...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  _filterTags();
                },
              ),
            ),
          const SizedBox(height: 8),
          Flexible(
            child: _filteredTags.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No tags found'),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredTags.length,
                    itemBuilder: (context, index) {
                      final tag = _filteredTags[index];
                      final isSelected = widget.selectedTags.contains(tag);

                      return ListTile(
                        dense: true,
                        leading: Icon(
                          isSelected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        title: Text(
                          tag.name,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        onTap: () => _toggleTag(tag),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
