# Tag Filtering Design Specification

## Overview
This specification details the design for adding tag-based filtering functionality to help users filter dancers by venue/context tags when selecting dancers for events. The primary use case is when users remember the venue or context where they know dancers from but may not remember specific names.

## Problem Statement
Currently, when adding existing dancers to events through the "Select Dancers" dialog, users can only filter by name or notes using text search. Users often remember where they know dancers from (e.g., "Monday Class", "Cuban DC Festival") but may not recall specific names, especially for less frequent attendees.

## Solution: Enhanced "Select Dancers" Dialog with Tag Filtering

### Target Dialog: Select Dancers Screen
**Location**: `lib/screens/event/dialogs/select_dancers_screen.dart`
**Context**: Used in event planning to add multiple existing dancers to an event
**Current Features**:
- Search field for name/notes filtering
- Checkbox list of unranked dancers
- Multiple selection capability
- FloatingActionButton to add selected dancers

### Design Requirements

#### Core Functionality
1. **Tag Filter Integration**: Add tag filter chips above the existing search field
2. **Multiple Tag Selection**: Allow filtering by multiple tags simultaneously (AND logic)
3. **Combined Filtering**: Tag filters work together with text search
4. **Memory Aid**: Help users find dancers by venue/context when names are forgotten

#### Tag Categories
Focus on **venue/context tags** that users manually assign:
- Workshop/Event names: "Cuban DC Festival", "Summer Salsa Workshop"
- Regular classes: "Monday Class", "Wednesday Bachata", "Friday Social"
- Dance schools: "DC Dance Academy", "Latin Beat Studio"
- Special events: "New Year's Party", "Anniversary Milonga"

*Note: Smart suggestions for attendance patterns (#frequent, #longTimeNoSee) will be handled by the planned smart suggestions feature, not manual tags.*

### Enhanced Dialog Structure

#### UI Layout (Top to Bottom)
1. **App Bar**: "Select Dancers" + event name (unchanged)
2. **Tag Filters Section**: Scrollable row of filter chips
3. **Search Field**: Text search (unchanged)
4. **Dancers List**: Filtered results with checkboxes (unchanged)
5. **FloatingActionButton**: Add selected dancers (unchanged)

### Complete UI Mockup

```
┌─────────────────────────────────────────────────────────┐
│ ← Select Dancers                           3 selected   │
│   Friday Social Night                                   │
├─────────────────────────────────────────────────────────┤
│                                                         │
│ ┌─ Tag Filters ─────────────────────────────────────────┐│
│ │ [All] [Monday Class] [Cuban DC Festival] [Friday...] ││ 
│ │                                                     ││
│ └─────────────────────────────────────────────────────┘│
│                                                         │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ 🔍 Search dancers                                  │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ ☑ Maria Santos                                      │ │
│ │   Great lead, loves spins                           │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ ☐ Carlos Rodriguez                                  │ │
│ │   Experienced social dancer                         │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ ☑ Ana Lopez                                         │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ ☐ Roberto Kim                                       │ │
│ │   New to bachata                                    │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ ☑ Sofia Chen                                        │ │
│ │   Advanced follower                                 │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│                                                         │
│                                              ┌─────────┐│
│                                              │ ✓ Add   ││
│                                              │ Selected││
│                                              └─────────┘│
└─────────────────────────────────────────────────────────┘
```

#### Tag Filters Section Detail
```
┌─────────────────────────────────────────────────────────┐
│ [All] [Monday Class] [Cuban DC Festival] [Friday Social] │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Behavior**:
- **"All" chip**: Always visible, selected by default, shows all dancers
- **Tag chips**: One chip per existing tag, only shows tags that have associated dancers
- **Multiple selection**: Users can select multiple tag chips (deselects "All")
- **Selection state**: Selected chips have primary color, unselected chips have neutral color
- **Auto-scroll**: Horizontal scrolling for many tags

#### Filter Logic
- **No tags selected (All)**: Show all unranked dancers
- **One tag selected**: Show dancers with that tag
- **Multiple tags selected**: Show dancers with ANY of the selected tags (OR logic)
- **Combined with search**: Apply tag filtering first, then text search on results

### Technical Implementation

#### Data Flow
1. Load all tags that have associated dancers in the database
2. Apply selected tag filters to dancer list
3. Apply text search to filtered results
4. Update UI with final filtered list

#### Service Integration
- **TagService**: Use `getDancersByTag(int tagId)` to get dancers for specific tags
- **Database queries**: Modify existing `_filterDancers()` method to include tag filtering
- **Tag loading**: Query tags that have associated dancers to avoid empty filter options

#### State Management
```dart
class _SelectDancersScreenState extends State<SelectDancersScreen> {
  // Existing state
  final Set<int> _selectedDancerIds = <int>{};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;
  
  // New tag filtering state
  Set<int> _selectedTagIds = <int>{}; // Empty = show all
  List<Tag> _availableTags = [];
  bool _showAllDancers = true; // "All" chip selected
}
```

### UI Implementation Details

#### Tag Filter Chips
- **Material 3 FilterChip**: Use Flutter's FilterChip widget for consistent behavior
- **Chip appearance**: 
  - Selected: Primary container color with checkmark
  - Unselected: Surface container color
- **"All" chip**: Special styling to distinguish from tag chips
- **Spacing**: 8px between chips, 16px padding from screen edges

#### Visual Hierarchy
1. **Tag filters**: Visually grouped above search field with consistent spacing
2. **Clear separation**: 16px gap between tag filters and search field
3. **Consistent styling**: Match existing dialog's Material 3 design system

#### Empty States
- **No tags available**: Hide tag filter section entirely
- **No dancers after filtering**: Show existing empty state message with context about active filters
- **No results**: "No dancers found with selected tags" + option to clear filters

### User Experience Flow

#### Typical Usage
1. User opens "Select Dancers" dialog from event planning
2. User sees tag filter chips for available venues/contexts
3. User taps "Monday Class" chip to see only dancers from Monday classes
4. User optionally adds more tag filters or uses text search to narrow results
5. User selects dancers with checkboxes and adds them to event

#### Error Handling
- **No network required**: All filtering happens locally with cached data
- **Empty results**: Clear messaging about active filters and option to reset
- **Tag loading errors**: Gracefully fall back to text-only search

### Technical Notes

#### Performance Considerations
- **Lazy loading**: Only load tag data when dialog opens
- **Efficient filtering**: Use database joins instead of multiple queries
- **State preservation**: Maintain filter state during dialog lifecycle

#### Future Extensions
- **Tag management**: Quick access to edit tags directly from filter interface
- **Filter memory**: Remember last used tag filters across sessions
- **Advanced filtering**: AND/OR logic toggle for power users

### Add Existing Dancer Dialog Mockup

The same tag filtering functionality applies to the "Add Existing Dancer" dialog (`lib/screens/event/dialogs/add_existing_dancer_screen.dart`) which is used to mark individual dancers as present.

```
┌─────────────────────────────────────────────────────────┐
│ ← Add to Friday Social Night                            │
├─────────────────────────────────────────────────────────┤
│                                                         │
│ ┌─ Tag Filters ─────────────────────────────────────────┐│
│ │ [All] [Monday Class] [Cuban DC Festival] [Friday...] ││ 
│ │                                                     ││
│ └─────────────────────────────────────────────────────┘│
│                                                         │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ 🔍 Search available dancers                        │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ ┌─ Info ──────────────────────────────────────────────┐ │
│ │ ℹ Showing unranked and absent dancers only.        │ │
│ │   Present dancers managed in Present tab.           │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Maria Santos                    [📍 Mark Present]   │ │
│ │ Great lead, loves spins                             │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Carlos Rodriguez                [📍 Mark Present]   │ │
│ │ Experienced social dancer                           │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Ana Lopez                       [📍 Mark Present]   │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Roberto Kim                     [📍 Mark Present]   │ │
│ │ New to bachata                                      │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Sofia Chen                      [📍 Mark Present]   │ │
│ │ Advanced follower                                   │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Key Differences from Select Dancers Dialog:**
- **Individual actions**: Each dancer has a "Mark Present" button instead of checkboxes
- **Info banner**: Explains that only unranked/absent dancers are shown
- **Immediate feedback**: Success toasts show when dancers are marked present
- **No bulk selection**: No FloatingActionButton, actions are per-dancer
- **Same tag filtering**: Identical tag filter behavior and layout

### Implementation Priority
1. **Phase 1**: Basic tag filtering with OR logic for both dialogs
2. **Phase 2**: UI polish and empty state handling
3. **Phase 3**: Performance optimization and filter memory

This design focuses on both dancer selection dialogs and provides practical venue/context filtering to complement the planned smart suggestions feature for attendance patterns. 