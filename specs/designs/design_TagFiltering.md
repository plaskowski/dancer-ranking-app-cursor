# Tag-Based Filtering in Event Dancer Selection Dialogs

## Overview
Tag-based filtering in dancer selection dialogs allows users to quickly find and invite specific groups of dancers to events based on venue, frequency, or other characteristics when planning events.

## Use Cases
- **Event planning**: "Invite all dancers from Monday Class to tonight's social"
- **Venue-based invitations**: "Add everyone from Cuban DC Festival"
- **Memory aid**: "I want to invite someone from Friday Social but forgot their name"
- **Context-based**: "Invite all the workshop participants"
- **Venue reunion**: "Invite everyone from Monday Class to this special event"

## UI Design

### 1. Integration Points

#### Event Screen Dancer Selection Dialogs
- **"Add Existing Dancer" Dialog**: When adding individual dancers to event
- **"Select Dancers" Dialog**: When bulk selecting dancers for event
- **"Planning Tab" Add Actions**: Quick add dancers based on filters

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

#### Enhancement: Add Tag Filtering to Dialogs
- **"Add Existing Dancer" Dialog** → Add tag filter chips above dancer list
- **"Select Dancers" Dialog** → New bulk selection dialog with tag-based groups
- **Planning Tab Quick Actions** → Add "Select by tag" options

### 2. Enhanced Dancer Selection Dialogs

#### "Add Existing Dancer" Dialog with Tag Filter
```
┌─────────────────────────────────────────────────┐
│ Add Dancers to Event                      [×]   │
├─────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────┐ │
│ │ Search dancers... 🔍                       │ │
│ └─────────────────────────────────────────────┘ │
│                                                 │
│ 🏷️ Filter by venue/context:                    │
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

#### "Select Dancers" Dialog with Bulk Tag Filtering
```
┌─────────────────────────────────────────────────┐
│ Select Dancers for Event                  [×]   │
├─────────────────────────────────────────────────┤
│ 🏷️ Select by venue/context:                    │
│                                                 │
│ Classes & Venues:                               │
│ [Monday Class (12)] [Friday Social (18)]        │
│ [Tuesday Workshop (6)] [Studio Downtown (15)]   │
│                                                 │  
│ Events & Festivals:                             │
│ [Cuban DC Festival (8)] [Summer Intensive (4)]  │
│ [Workshop Miami (5)] [Salsa Congress (12)]      │
│                                                 │
│ ──────────────────────────────────────────────  │
│ ☑️ Select All [Monday Class]     (12 dancers)   │
│ ☑️ Select All [Friday Social]    (18 dancers)   │
│ ☐ Select All [Cuban DC Festival] (8 dancers)   │
│                                                 │
│ Total selected: 30 dancers                     │
│                        [Cancel] [Add All (30)] │
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
- **Recent filters**: "Recently used: [Monday Class] [#frequent]"
- **Saved filters**: Save common filter combinations
- **Smart suggestions**: "Try: dancers you haven't seen recently"

#### Bulk Actions
- **Select all filtered**: Checkbox to select all filtered results
- **Bulk tag operations**: Add/remove tags to all selected dancers
- **Event invitation**: "Invite all filtered dancers to event"

## Interaction Flows

### Individual Dancer Selection Flow
1. User is planning event and taps "Add Existing Dancer"
2. Dialog opens with search box and tag filter chips
3. User taps [Monday Class] tag to filter
4. List shows only dancers from Monday Class with checkboxes
5. User selects specific dancers and taps "Add Selected"

### Bulk Group Invitation Flow  
1. User is planning event and wants to invite entire groups
2. Taps "Select Dancers" for bulk selection
3. Dialog shows venue/context categories with "Select All" options
4. User taps "Select All [Monday Class]" to invite entire class
5. Adds "Select All [Friday Social]" to also invite social dancers
6. Reviews total count and taps "Add All (30)"

### Memory-Aid Flow
1. User remembers someone from Cuban DC Festival but forgot name
2. Opens "Add Existing Dancer" dialog
3. Taps [Cuban DC Festival] tag filter
4. Sees short list of 8 dancers from that event
5. Recognizes the right person and adds them

## Technical Considerations

### Performance
- **Lazy loading**: Only load visible tag chips
- **Debounced search**: Wait for typing pause before filtering
- **Cached results**: Cache common filter combinations

### Data Organization
- **Tag hierarchy**: Support nested tags (venues > classes > Monday Class)
- **Venue categorization**: Auto-group by venue type (classes, socials, festivals, workshops)
- **Tag grouping**: Group venue/context tags by category for better organization

### Accessibility
- **Screen reader**: Announce filter changes and result counts
- **Keyboard nav**: Tab through filter chips, Enter to select
- **High contrast**: Ensure filter chips are clearly distinguishable

## Integration Points

### Event Screen Integration
- **Add Existing Dancer Dialog**: Tag filtering for individual dancer selection
- **Select Dancers Dialog**: Bulk tag-based group selection
- **Planning Tab**: Quick actions like "Add all Monday Class dancers"

### Future Event Features
- **Event Templates**: Save venue tag combinations for recurring events
- **Venue Analytics**: "Monday Class dancers have 80% attendance rate at socials"
- **Cross-venue Insights**: "Dancers from Cuban DC Festival also frequent Friday Social"

## Success Metrics
- **Event setup speed**: Time from opening event to finishing dancer invitations
- **Group invitation efficiency**: How often bulk tag selection is used vs. individual selection
- **Venue-based discovery**: % of event invitations that use venue tag filtering vs. search
- **Tag filtering adoption**: How often users create and use venue/context tags 