import 'package:flutter/material.dart';

import 'common_search_field.dart';
import 'tag_filter_chips.dart';

class CommonFilterSection extends StatelessWidget {
  final String searchHintText;
  final String? searchLabelText;
  final Function(String) onSearchChanged;
  final TextEditingController? searchController;
  final String? searchInitialValue;
  final bool showTagFilter;
  final int? selectedTagId;
  final Function(int?)? onTagChanged;
  final bool showTagClearButton;
  final EdgeInsetsGeometry? padding;

  const CommonFilterSection({
    super.key,
    this.searchHintText = 'Search...',
    this.searchLabelText,
    required this.onSearchChanged,
    this.searchController,
    this.searchInitialValue,
    this.showTagFilter = true,
    this.selectedTagId,
    this.onTagChanged,
    this.showTagClearButton = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search field
        Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: CommonSearchField(
            hintText: searchHintText,
            labelText: searchLabelText,
            onChanged: onSearchChanged,
            controller: searchController,
            initialValue: searchInitialValue,
          ),
        ),

        // Tag filter (optional)
        if (showTagFilter && onTagChanged != null)
          TagFilterChips(
            selectedTagId: selectedTagId,
            onTagChanged: onTagChanged!,
            showClearButton: showTagClearButton,
          ),
      ],
    );
  }
}
