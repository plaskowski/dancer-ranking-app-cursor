# Tag-Based Filtering in Event Dancer Selection

## Overview
Tag-based filtering in the dancer selection dialog allows users to quickly find and invite specific groups of dancers to events based on venue or context when planning events.

## Use Cases
- **Event planning**: "Invite all dancers from Monday Class to tonight's social"
- **Venue-based invitations**: "Add everyone from Cuban DC Festival"
- **Memory aid**: "I want to invite someone from Friday Social but forgot their name"
- **Context-based**: "Invite all the workshop participants"
- **Venue reunion**: "Invite everyone from Monday Class to this special event"

## UI Design

### 1. Integration Points

#### Event Screen Dancer Selection Dialogs
- **"Add Existing Dancer" Dialog**: When adding dancers to event with tag filtering
- **"Planning Tab" Integration**: Enhanced dancer selection with tag filters

#### Context: Event Planning Workflow
- User is planning an event and needs to invite specific groups
- Filtering helps find the right people without remembering all names
- Focus on speed and efficiency during event setup

### 0. Current Event Planning Context

#### Existing Event Screen Structure
```
Event Screen
├── Planning Tab
│   ├── Add Existing Dancer (opens dialog)
│   ├── Create New Dancer (opens dialog)
│   └── Dancer list with rankings
├── Present Tab
│   └── Mark attendance/dance status
└── Summary Tab
    └── View event results
```

#### Enhancement: Add Tag Filtering to Dialog
- **"Add Existing Dancer" Dialog** → Add tag filter chips above dancer list
- **Planning Tab Integration** → Enhanced dancer selection workflow

### 2. Enhanced Dancer Selection Dialog

#### "Add Existing Dancer" Dialog with Tag Filter
```
┌─────────────────────────────────────────────────┐
│ Add Dancers to Event                      [×]   │
├─────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────┐ │
│ │ Search dancers... 🔍                       │ │
│ └─────────────────────────────────────────────┘ │
│                                                 │
│ 🏷️ Filter by tags:                             │
│ [Monday Class (12)] [Cuban DC Festival (8)]     │
│ [Friday Social (18)] [Workshop Miami (5)]       │
│                                                 │
│ ┌─────────────────────────────────────────────┐ │
│ │ ☐ Maria Rodriguez  [Monday Class]           │ │
│ │ ☐ Carlos Santos    [Cuban DC Festival]      │ │
│ │ ☐ Ana Garcia       [Friday Social]          │ │
│ │ ...                                         │ │
│ └─────────────────────────────────────────────┘ │
│                                                 │
│ Selected: 3 dancers    [Cancel] [Add Selected] │
└─────────────────────────────────────────────────┘
```



### 3. Filter Chips Design

#### Tag Chip States
- **Available**: `[Monday Class]` - light gray background, dark text
- **Selected**: `[Monday Class]` - blue background, white text  
- **With count**: `[Monday Class (12)]` - shows number of dancers
- **Remove**: Selected chips show × when hovered

#### Tag Chip Grouping
- **Auto-categorization**: Group tags by type (venues, frequency, custom)
- **Collapsible sections**: Can hide/show tag categories
- **Most used first**: Sort by usage frequency within groups

### 4. Search Integration

#### Tag Search Box
- **Placeholder**: "Search tags..." 
- **Autocomplete**: Shows matching tags as you type
- **Add new**: Option to create new tag if not found
- **Recent**: Shows recently used tags

#### Combined Search
- **Text + Tags**: Allow searching by name AND filtering by tags
- **Clear separation**: "Search: 'Maria' + Tags: [Monday Class]"

### 5. Results Display

#### Filtered Results Header
```
┌─────────────────────────────────────────────────┐
│ Showing 8 dancers with tags: [Monday Class] [×] │
└─────────────────────────────────────────────────┘
```

#### No Results State
```
┌─────────────────────────────────────────────────┐
│           🏷️                                    │
│     No dancers found with these tags            │
│                                                 │
│     Try removing some filters or               │
│     [Create new dancer with these tags]         │
└─────────────────────────────────────────────────┘
```

### 6. Quick Actions

#### Filter Shortcuts
- **Recent filters**: "Recently used: [Monday Class] [Friday Social]"
- **Saved filters**: Save common filter combinations

#### Selection Actions
- **Multiple selection**: Select multiple dancers from filtered results
- **Clear filters**: Reset to show all dancers

## Interaction Flows

### Tag-Filtered Dancer Selection Flow
1. User is planning event and taps "Add Existing Dancer"
2. Dialog opens with search box and tag filter chips
3. User taps [Monday Class] tag to filter
4. List shows only dancers from Monday Class with checkboxes
5. User selects specific dancers and taps "Add Selected"

### Memory-Aid Flow
1. User remembers someone from Cuban DC Festival but forgot name
2. Opens "Add Existing Dancer" dialog
3. Taps [Cuban DC Festival] tag filter
4. Sees short list of 8 dancers from that event
5. Recognizes the right person and adds them

### Multiple Selection Flow
1. User wants to add several dancers from same venue
2. Opens "Add Existing Dancer" dialog
3. Filters by [Friday Social] tag
4. Selects multiple dancers from the filtered list
5. Adds all selected dancers at once

## Technical Considerations

### Performance
- **Lazy loading**: Only load visible tag chips
- **Debounced search**: Wait for typing pause before filtering
- **Cached results**: Cache common filter combinations

### Data Organization
- **Tag hierarchy**: Support nested tags (venues > classes > Monday Class)
- **Tag categorization**: Auto-group by tag type (classes, socials, festivals, workshops)
- **Tag grouping**: Group tags by category for better organization

### Accessibility
- **Screen reader**: Announce filter changes and result counts
- **Keyboard nav**: Tab through filter chips, Enter to select
- **High contrast**: Ensure filter chips are clearly distinguishable

## Integration Points

### Event Screen Integration
- **Add Existing Dancer Dialog**: Tag filtering for enhanced dancer selection
- **Planning Tab**: Improved dancer selection workflow with tag filtering

### Future Event Features
- **Event Templates**: Save tag combinations for recurring events
- **Tag Analytics**: "Monday Class dancers have 80% attendance rate at socials"
- **Cross-tag Insights**: "Dancers from Cuban DC Festival also frequent Friday Social"

## Success Metrics
- **Event setup speed**: Time from opening event to finishing dancer invitations
- **Tag filtering usage**: How often tag filtering is used vs. search for dancer selection
- **Tag-based discovery**: % of dancer selections that use tag filtering vs. search
- **Tag filtering adoption**: How often users create and use tags for event planning 