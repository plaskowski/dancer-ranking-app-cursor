# Technical Specification: Unified Dancer Filter Implementation

## Overview
Create a single, parametrized dancer filter component that can be used across multiple screens with different requirements and behaviors.

## Current State Analysis

### Existing Components
1. **CombinedDancerFilter** (`lib/widgets/combined_dancer_filter.dart`)
   - Used in: Dancers Screen
   - Features: Search, tag filtering, activity level filtering
   - API: `onFiltersChanged(String, List<int>, ActivityLevel?)`

2. **SimplifiedTagFilter** (`lib/widgets/simplified_tag_filter.dart`)
   - Used in: Select Dancers Screen
   - Features: Search, tag filtering, activity level filtering
   - API: `onTagsChanged(List<int>)`, `onSearchChanged(String?)`

3. **Tag Selection Flyout** (`lib/widgets/tag_selection_flyout.dart`)
   - Used in: CombinedDancerFilter
   - Features: Search, checkbox selection
   - API: `onTagsChanged(List<Tag>)`

### Screen Requirements

#### Dancers Screen
- **Purpose**: Browse and manage all dancers
- **Filtering**: Search by name, filter by tags, filter by activity level
- **Selection**: None (view-only)
- **Data Source**: `dancerService.watchDancersWithTagsAndLastMet()`

#### Select Dancers Screen
- **Purpose**: Select dancers to add to an event
- **Filtering**: Search by name, filter by tags, filter by activity level
- **Selection**: Multiple selection with checkboxes
- **Data Source**: `filterService.getUnrankedDancersForEvent(eventId, tagId)`

#### Add Existing Dancer Screen
- **Purpose**: Add an existing dancer to an event
- **Filtering**: Search by name, filter by tags
- **Selection**: Single selection
- **Data Source**: `filterService.getUnrankedDancersForEvent(eventId, tagId)`

## Proposed Unified Solution

### Component: `UnifiedDancerFilter`

#### Parameters
```dart
class UnifiedDancerFilter extends StatefulWidget {
  final FilterMode mode;
  final List<Tag> availableTags;
  final Function(FilterState) onFiltersChanged;
  final FilterState? initialFilters;
  final bool showActivityFilter;
  final bool showTagFilter;
  final bool showSearch;
  final String searchHintText;
  final int? eventId; // For event-specific filtering
  final bool allowMultipleTagSelection;
  
  const UnifiedDancerFilter({
    super.key,
    required this.mode,
    required this.availableTags,
    required this.onFiltersChanged,
    this.initialFilters,
    this.showActivityFilter = true,
    this.showTagFilter = true,
    this.showSearch = true,
    this.searchHintText = 'Search dancers...',
    this.eventId,
    this.allowMultipleTagSelection = true,
  });
}

enum FilterMode {
  browse,      // Dancers Screen - view only
  multiSelect, // Select Dancers Screen - multiple selection
  singleSelect, // Add Existing Dancer Screen - single selection
}

class FilterState {
  final String searchQuery;
  final List<Tag> selectedTags;
  final ActivityLevel? activityLevel;
  
  const FilterState({
    this.searchQuery = '',
    this.selectedTags = const [],
    this.activityLevel,
  });
}
```

#### Features
1. **Unified API**: Single component with different modes
2. **Flexible Configuration**: Show/hide filters based on screen needs
3. **Consistent UX**: Same look and feel across all screens
4. **Type Safety**: Use Tag objects instead of IDs where possible
5. **Performance**: Efficient filtering and state management

### Implementation Strategy

#### Phase 1: Create Unified Component
1. Create `UnifiedDancerFilter` widget
2. Implement all filter modes (browse, multiSelect, singleSelect)
3. Integrate existing `TagSelectionFlyout` for tag filtering
4. Add activity level filtering component

#### Phase 2: Update Screens
1. **Dancers Screen**: Replace `CombinedDancerFilter` with `UnifiedDancerFilter(mode: FilterMode.browse)`
2. **Select Dancers Screen**: Replace `SimplifiedTagFilter` with `UnifiedDancerFilter(mode: FilterMode.multiSelect)`
3. **Add Existing Dancer Screen**: Use `UnifiedDancerFilter(mode: FilterMode.singleSelect)`

#### Phase 3: Cleanup
1. Deprecate `CombinedDancerFilter` and `SimplifiedTagFilter`
2. Remove unused code
3. Update documentation

### Benefits
1. **Code Reuse**: Single implementation for all dancer filtering needs
2. **Consistency**: Same UX patterns across all screens
3. **Maintainability**: One component to maintain instead of three
4. **Flexibility**: Easy to add new filter types or modify existing ones
5. **Type Safety**: Better type safety with Tag objects

### Migration Plan
1. Create new component alongside existing ones
2. Test with one screen first (Dancers Screen)
3. Gradually migrate other screens
4. Remove old components after all screens are migrated

### Testing Strategy
1. Unit tests for filter logic
2. Integration tests for each screen
3. Manual testing of all filter combinations
4. Performance testing with large datasets

## Implementation Details

### State Management
```dart
class _UnifiedDancerFilterState extends State<UnifiedDancerFilter> {
  late FilterState _currentFilters;
  bool _showTagDropdown = false;
  bool _showActivityDropdown = false;
  
  @override
  void initState() {
    super.initState();
    _currentFilters = widget.initialFilters ?? const FilterState();
  }
  
  void _updateFilters(FilterState newFilters) {
    setState(() {
      _currentFilters = newFilters;
    });
    widget.onFiltersChanged(newFilters);
  }
}
```

### Filter Components
1. **Search Filter**: Text input with debouncing
2. **Tag Filter**: Dropdown with `TagSelectionFlyout`
3. **Activity Filter**: Dropdown with activity level options

### Data Flow
1. User interacts with filter
2. `UnifiedDancerFilter` updates internal state
3. `onFiltersChanged` callback is called with new `FilterState`
4. Parent screen updates its data source
5. UI reflects filtered results

## Timeline
- **Week 1**: Create `UnifiedDancerFilter` component
- **Week 2**: Migrate Dancers Screen
- **Week 3**: Migrate Select Dancers Screen
- **Week 4**: Migrate Add Existing Dancer Screen and cleanup 