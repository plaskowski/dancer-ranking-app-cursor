# Technical Specification: Dancer Filtering UI Integration

## Overview

Integrate the existing `SimplifiedTagFilter` and `ActivityFilterWidget` components into the `AddExistingDancerScreen` to create a unified filtering system that matches the feature specification.

## Current State Analysis

### ✅ **Existing Components**
- `SimplifiedTagFilter` - Tag filtering with pill format and auto-apply
- `ActivityFilterWidget` - Activity level dropdown with radio buttons
- `AddExistingDancerScreen` - Basic tag filtering and search

### ❌ **Missing Integration**
- Combined horizontal filter bar
- Activity level state management
- Activity counts integration
- Unified filtering logic

## Technical Requirements

### 1. **Create Combined Filter Component**

**Component**: `CombinedDancerFilter`
**Location**: `lib/widgets/combined_dancer_filter.dart`

**Props**:
```dart
class CombinedDancerFilter extends StatefulWidget {
  final Function(String, List<int>, ActivityLevel?) onFiltersChanged;
  final Map<ActivityLevel, int>? activityLevelCounts;

  const CombinedDancerFilter({
    super.key,
    required this.onFiltersChanged,
    this.activityLevelCounts,
  });
}
```

**Layout**: Single horizontal row with three filters:
```
┌─────────────────────────────────────────────────────────┐
│ 🔍 [Search dancers...]  🏷️ [Tags ▼]  🎯 [Active ▼]    │
└─────────────────────────────────────────────────────────┘
```

### 2. **Update AddExistingDancerScreen State**

**Replace existing state with simplified version**:
```dart
class _AddExistingDancerScreenState extends State<AddExistingDancerScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  List<int> _selectedTagIds = [];
  ActivityLevel? _selectedActivityLevel = ActivityLevel.active;
}
```

**Add callback handler**:
```dart
void _onFiltersChanged(String searchQuery, List<int> tagIds, ActivityLevel? activityLevel) {
  setState(() {
    _searchQuery = searchQuery;
    _selectedTagIds = tagIds;
    _selectedActivityLevel = activityLevel;
  });
}
```

### 3. **Replace SimplifiedTagFilter with CombinedDancerFilter**

**In `AddExistingDancerScreen.build()`**:
```dart
// Replace this:
SimplifiedTagFilter(
  selectedTagIds: _selectedTagIds,
  onTagsChanged: _onTagsChanged,
),

// With this:
CombinedDancerFilter(
  onFiltersChanged: _onFiltersChanged,
  activityLevelCounts: widget.activityLevelCounts,
),
```

### 4. **Remove Duplicate Search Field**

**Remove from `AddExistingDancerScreen.build()`**:
```dart
// Remove this section:
Padding(
  padding: const EdgeInsets.all(16.0),
  child: TextField(
    controller: _searchController,
    decoration: const InputDecoration(
      labelText: 'Search available dancers',
      prefixIcon: Icon(Icons.search),
      border: OutlineInputBorder(),
      hintText: 'Search by name or notes...',
    ),
    onChanged: (value) {
      setState(() {
        _searchQuery = value;
      });
    },
  ),
),
```

### 5. **Update Dancer Filtering Logic**

**Update `_getAvailableDancersStream()`**:
```dart
Stream<List<DancerWithEventInfo>> _getAvailableDancersStream() {
  final filterService = DancerFilterService.of(context);
  
  // TODO: When activity service is ready, use:
  // final activityService = DancerActivityService(AppDatabase());
  // return activityService.watchDancersByActivityLevel(
  //   widget.eventId,
  //   _selectedActivityLevel ?? ActivityLevel.active,
  // );
  
  // For now, use existing tag filtering
  return filterService.getAvailableDancersForEvent(
    widget.eventId,
    tagIds: _selectedTagIds.isNotEmpty ? _selectedTagIds.toSet() : null,
  );
}
```

## Implementation Steps

### Step 1: Create CombinedDancerFilter Component

**File**: `lib/widgets/combined_dancer_filter.dart`

**Features**:
- Self-contained state management
- Horizontal layout with three filters
- Search field with debounced input
- Tag dropdown with pill format
- Activity dropdown with radio buttons
- Auto-apply functionality for both dropdowns
- Parent notification through single callback

### Step 2: Update AddExistingDancerScreen

**Changes**:
- Replace `SimplifiedTagFilter` with `CombinedDancerFilter`
- Remove duplicate search field
- Add single `_onFiltersChanged` callback
- Simplify state management
- Update filtering logic (placeholder for now)

### Step 3: Update Dancer Filtering

**Future Enhancement**:
- Connect to `DancerActivityService` when filtering logic is implemented
- Add activity level counts loading
- Update dancer stream to respect activity level filter

## Component Architecture

```
CombinedDancerFilter
├── SearchField (inline)
├── TagFilter (dropdown with pills)
└── ActivityFilter (dropdown with radio buttons)
```

## Component State Management

### CombinedDancerFilter Internal State

**Component manages its own state**:
```dart
class _CombinedDancerFilterState extends State<CombinedDancerFilter> {
  String _searchQuery = '';
  List<int> _selectedTagIds = [];
  ActivityLevel? _selectedActivityLevel = ActivityLevel.active;
  bool _isLoadingCounts = false;

  @override
  void initState() {
    super.initState();
    _loadActivityLevelCounts();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _notifyParent();
  }

  void _onTagsChanged(List<int> tagIds) {
    setState(() {
      _selectedTagIds = tagIds;
    });
    _notifyParent();
  }

  void _onActivityLevelChanged(ActivityLevel? level) {
    setState(() {
      _selectedActivityLevel = level;
    });
    _notifyParent();
  }

  void _notifyParent() {
    widget.onFiltersChanged(_searchQuery, _selectedTagIds, _selectedActivityLevel);
  }

  Future<void> _loadActivityLevelCounts() async {
    setState(() {
      _isLoadingCounts = true;
    });

    // TODO: Implement when activity service is ready
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading

    setState(() {
      _isLoadingCounts = false;
    });
  }
}
```

### State Flow

**1. Search State**:
```
User types → _onSearchChanged → _searchQuery updated → _notifyParent → Parent UI rebuilds
```

**2. Tag State**:
```
User selects tag → _onTagsChanged → _selectedTagIds updated → _notifyParent → Parent UI rebuilds
```

**3. Activity Level State**:
```
User selects activity level → _onActivityLevelChanged → _selectedActivityLevel updated → _notifyParent → Parent UI rebuilds
```

**4. Activity Counts State**:
```
Component loads → _loadActivityLevelCounts → _isLoadingCounts updated → Loading indicator shown
```

**5. Parent Notification**:
```
Filter changes → _notifyParent → onFiltersChanged callback → Parent state updated
```

### State Integration Points

**CombinedDancerFilter Integration**:
```dart
// Replace current filter with unified component
CombinedDancerFilter(
  onFiltersChanged: _onFiltersChanged,
  activityLevelCounts: widget.activityLevelCounts,
),
```

**Dancer Filtering Integration**:
```dart
Stream<List<DancerWithEventInfo>> _getAvailableDancersStream() {
  final filterService = DancerFilterService.of(context);
  
  // TODO: When activity service is ready, use:
  // final activityService = DancerActivityService(AppDatabase());
  // return activityService.watchDancersByActivityLevel(
  //   widget.eventId,
  //   _selectedActivityLevel ?? ActivityLevel.active,
  // );
  
  // For now, use existing tag filtering
  return filterService.getAvailableDancersForEvent(
    widget.eventId,
    tagIds: _selectedTagIds.isNotEmpty ? _selectedTagIds.toSet() : null,
  );
}
```

### State Initialization

**Add to initState()**:
```dart
@override
void initState() {
  super.initState();
  
  // Existing initialization...
  
  // Load activity level counts
  _loadActivityLevelCounts();
}
```

### State Validation

**Activity Level Validation**:
```dart
ActivityLevel _getValidActivityLevel(ActivityLevel? level) {
  return level ?? ActivityLevel.active;
}
```

**Count Validation**:
```dart
int _getValidCount(ActivityLevel level) {
  return widget.activityLevelCounts?[level] ?? 0;
}
```

**Component State Validation**:
```dart
void _validateAndUpdateState() {
  final validActivityLevel = _getValidActivityLevel(_selectedActivityLevel);
  if (validActivityLevel != _selectedActivityLevel) {
    setState(() {
      _selectedActivityLevel = validActivityLevel;
    });
    _notifyParent();
  }
}
```

### State Performance

**Debounced Search**:
```dart
Timer? _searchDebounce;

void _onSearchChanged(String query) {
  _searchDebounce?.cancel();
  _searchDebounce = Timer(const Duration(milliseconds: 300), () {
    setState(() {
      _searchQuery = query;
    });
    _notifyParent();
  });
}
```

**Batch State Updates**:
```dart
void _updateMultipleFilters({
  String? searchQuery,
  List<int>? selectedTagIds,
  ActivityLevel? selectedActivityLevel,
}) {
  setState(() {
    if (searchQuery != null) _searchQuery = searchQuery;
    if (selectedTagIds != null) _selectedTagIds = selectedTagIds;
    if (selectedActivityLevel != null) _selectedActivityLevel = selectedActivityLevel;
  });
  _notifyParent();
}
```

## UI/UX Requirements

### Visual Design
- **Consistent Heights**: All filter buttons 40px height
- **Proper Spacing**: 8px between filter elements
- **Border Styling**: Grey borders with rounded corners
- **Icon Usage**: Search, label, and track_changes icons

### Interaction Design
- **Auto-Apply**: Dropdowns close immediately on selection
- **Visual Feedback**: Selected states clearly indicated
- **Loading States**: Proper loading indicators for counts
- **Empty States**: Handle no results gracefully

### Accessibility
- **Keyboard Navigation**: Full keyboard accessibility
- **Screen Reader Support**: Proper ARIA labels
- **Focus Management**: Clear focus indicators

## Integration Points

### With Existing Services
- `DancerFilterService` - For tag and text filtering
- `DancerActivityService` - For activity level filtering (future)
- `TagService` - For loading available tags

### With Existing Components
- `SimplifiedTagFilter` - Extract tag filtering logic
- `ActivityFilterWidget` - Extract activity filtering logic
- `AddExistingDancerScreen` - Main integration point

## Testing Requirements

### Unit Tests
- Filter state management
- Callback handling
- UI state transitions

### Integration Tests
- Filter combination behavior
- Search + tag + activity filtering
- State persistence during navigation

### Manual Testing
- Filter interaction flows
- Visual consistency
- Performance with large datasets

## Future Enhancements

### Activity Service Integration
- Connect to real activity level counts
- Implement activity filtering logic
- Add loading states for counts

### Performance Optimization
- Debounce search input
- Lazy load activity counts
- Optimize filter combinations

### Advanced Features
- Filter presets
- Filter history
- Export filtered results

## Success Criteria

1. **UI Matches Specification**: Horizontal filter bar with three filters
2. **Functionality Works**: All filters affect dancer list
3. **State Management**: Proper state handling and callbacks
4. **Performance**: Smooth interaction with large datasets
5. **Accessibility**: Full keyboard and screen reader support

## Dependencies

- Existing `SimplifiedTagFilter` component
- Existing `ActivityFilterWidget` component
- `DancerFilterService` for filtering logic
- `TagService` for tag data
- Future: `DancerActivityService` for activity filtering 