# Tag Filtering Technical Design

## Overview
Technical specification for implementing tag-based filtering in the "Select Dancers" and "Add Existing Dancer" dialogs. This document outlines the architecture, implementation approach, and code changes required.

## Architecture Components

### 1. Service Layer Extensions

#### DancerTagService Extensions
**File**: `lib/services/dancer/dancer_tag_service.dart`

New methods required:
```dart
// Get unranked dancers for event filtered by single tag
Future<List<DancerWithEventInfo>> getUnrankedDancersForEventByTag(
  int eventId, 
  int tagId
) async

// Get available dancers for add existing dialog filtered by single tag
Stream<List<DancerWithEventInfo>> watchAvailableDancersForEventByTag(
  int eventId,
  int tagId
) async
```

**Implementation Notes**:
- Leverage existing `getDancersByTag()` method from TagService for single tag filtering
- Combine existing event filtering logic with single tag filtering
- Use database joins for efficient querying
- Maintain reactive streams for real-time updates

#### TagService Extensions
**File**: `lib/services/tag_service.dart`

New methods required:
```dart
// Get tags that have associated dancers (for filter chip display)
Future<List<Tag>> getTagsWithDancers() async
```

**Implementation Notes**:
- `getTagsWithDancers()`: Join with dancer_tags table to only return tags that have associated dancers
- Optimize queries with proper indexing on dancer_tags table

### 2. UI Component Architecture

#### Shared Tag Filter Widget
**New File**: `lib/widgets/tag_filter_chips.dart`

```dart
class TagFilterChips extends StatefulWidget {
  final int? selectedTagId;
  final Function(int?) onTagChanged;
  final bool showClearButton;
  
  const TagFilterChips({
    required this.selectedTagId,
    required this.onTagChanged,
    this.showClearButton = true,
  });
}
```

**Features**:
- Horizontal scrollable row of FilterChip widgets
- Clear button (✕) conditionally displayed on the right only when a tag is selected
- Material 3 design with proper theming
- Loading state during tag fetch
- Empty state when no tags available (no chips, no clear button)

#### Enhanced Dialog State Management

**Select Dancers Screen State Extensions**:
```dart
class _SelectDancersScreenState extends State<SelectDancersScreen> {
  // Existing state
  final Set<int> _selectedDancerIds = <int>{};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;
  
  // New tag filtering state
  int? _selectedTagId; // null = show all
  List<Tag> _availableTags = [];
  bool _isLoadingTags = false;
}
```

**Add Existing Dancer Screen State Extensions**:
```dart
class _AddExistingDancerScreenState extends State<AddExistingDancerScreen> {
  // Existing state
  final _searchController = TextEditingController();
  String _searchQuery = '';
  
  // New tag filtering state
  int? _selectedTagId; // null = show all
  List<Tag> _availableTags = [];
  bool _isLoadingTags = false;
}
```

### 3. Database Query Optimization

#### Enhanced Filtering Queries

**Tag-based Dancer Filtering**:
```sql
-- Get dancers by single tag (leverages existing TagService.getDancersByTag)
SELECT DISTINCT d.* 
FROM dancers d
INNER JOIN dancer_tags dt ON d.id = dt.dancer_id
WHERE dt.tag_id = ?
ORDER BY d.name

-- Get unranked dancers for event with single tag filtering
SELECT d.*, 
       r.name as rank_name,
       a.marked_at as attendance_marked_at,
       a.status as status
FROM dancers d
LEFT JOIN rankings rk ON d.id = rk.dancer_id AND rk.event_id = ?
LEFT JOIN ranks r ON rk.rank_id = r.id
LEFT JOIN attendances a ON d.id = a.dancer_id AND a.event_id = ?
INNER JOIN dancer_tags dt ON d.id = dt.dancer_id
WHERE rk.id IS NULL 
  AND dt.tag_id = ?
ORDER BY d.name
```

**Tags with Dancers Query**:
```sql
-- Get only tags that have associated dancers
SELECT DISTINCT t.*
FROM tags t
INNER JOIN dancer_tags dt ON t.id = dt.tag_id
ORDER BY t.name
```

#### Database Indexes
Ensure proper indexing for performance:
- `dancer_tags(tag_id)` - for tag-based filtering
- `dancer_tags(dancer_id)` - for dancer's tags lookup
- `dancer_tags(tag_id, dancer_id)` - composite index for joins

### 4. Implementation Plan

#### Phase 1: Core Infrastructure
1. **Service Layer**:
   - Add single tag event filtering methods to DancerTagService
   - Add `getTagsWithDancers()` to TagService
   - Leverage existing `getDancersByTag()` method for core filtering

2. **Shared Widget**:
   - Create `TagFilterChips` widget
   - Implement Material 3 styling
   - Add loading and empty states

3. **Database Optimization**:
   - Verify database indexes
   - Test query performance

#### Phase 2: Dialog Integration
1. **Select Dancers Screen**:
   - Add tag filtering state management
   - Integrate TagFilterChips widget
   - Update filtering logic to combine tags + search
   - Update UI layout with proper spacing

2. **Add Existing Dancer Screen**:
   - Mirror tag filtering implementation
   - Adapt for single-selection interaction pattern
   - Maintain existing info banner functionality

#### Phase 3: Polish & Optimization
1. **Performance**:
   - Optimize database queries
   - Add query result caching
   - Minimize UI rebuilds during filtering

2. **UX Enhancements**:
   - Add filter memory across sessions
   - Improve empty state messaging
   - Add filter clear functionality

### 5. Code Changes Required

#### Files to Modify
1. **Service Layer**:
   - `lib/services/dancer/dancer_tag_service.dart` - Add tag-based dancer filtering methods
   - `lib/services/tag_service.dart` - Add `getTagsWithDancers()` method

2. **UI Components**:
   - `lib/screens/event/dialogs/select_dancers_screen.dart` - Add tag filtering
   - `lib/screens/event/dialogs/add_existing_dancer_screen.dart` - Add tag filtering

3. **New Files**:
   - `lib/widgets/tag_filter_chips.dart` - Shared tag filter component

#### Files to Test
- Both dialog screens with various tag combinations
- Database queries with large datasets
- UI responsiveness during filtering operations

### 6. Technical Considerations

#### Performance Optimization
- **Query Efficiency**: Use JOIN operations instead of multiple queries
- **UI Responsiveness**: Debounce filter operations to avoid excessive rebuilds
- **Memory Management**: Dispose of controllers and streams properly
- **Caching**: Cache tag list to avoid repeated database calls

#### Error Handling
- **Database Errors**: Graceful fallback to text-only search
- **Empty States**: Clear messaging when no tags or dancers available, clear button visible when tag selected
- **Network Independence**: All filtering happens locally with cached data

#### Testing Strategy
- **Unit Tests**: Service layer methods for tag filtering
- **Widget Tests**: TagFilterChips component behavior
- **Integration Tests**: End-to-end dialog filtering workflows
- **Performance Tests**: Large dataset filtering performance

### 7. Data Flow Architecture

#### Tag Filter Selection Flow
1. User opens dialog → Load available tags
2. User taps tag chip → Update selected tag state (single selection)
3. State change triggers → Filter dancers by single tag
4. Optional text search → Further filter results
5. Display filtered list → User makes selections

#### Database Query Flow
```
User Selection → TagService.getDancersByTag() → 
Database Query → Join with Event Data → 
Filter by Text Search → Return Filtered Results →
Update UI
```

#### State Synchronization
- Single tag selection state managed locally in each dialog
- Filter results computed reactively from state changes
- Database queries triggered only when tag selection changes
- Text search applied to tag-filtered results in memory

### 8. Future Extensions

#### Advanced Filtering (Phase 4)
- **Multiple Tag Selection**: Add option for multi-select with AND/OR logic
- **Tag Hierarchies**: Support for grouped tags (venue type > specific venue)
- **Recent Tags**: Show most recently used tags first
- **Quick Tag Switching**: Remember and cycle through recently used tags

#### Smart Integration (Phase 5)
- **Tag Suggestions**: Suggest relevant tags based on event context
- **Learning**: Remember frequently used tag combinations per user
- **Auto-tagging**: Suggest tags for new dancers based on patterns

This technical design provides a comprehensive roadmap for implementing tag filtering while maintaining the existing functionality and ensuring optimal performance. 