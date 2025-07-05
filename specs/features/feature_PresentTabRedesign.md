# Present Tab Redesign Specification

## Overview
Redesign the Present tab to incorporate critical functionality from the Planning tab, allowing users to manage both present dancers and expected attendees from a single interface during current events.

## Problem Statement
Currently, the Planning tab provides essential functionality for current events:
- View expected attendees who haven't arrived yet
- Remove dancers from event roster (only available in planning mode)
- Bulk add dancers

If the Planning tab is removed, users lose these capabilities. The Present tab redesign addresses this by incorporating these features into the Present tab workflow.

## Design Goals
1. **Unified Management**: Single interface for managing both present and expected dancers
2. **Preserve Critical Functions**: Maintain ability to remove dancers and import rankings
3. **Clear Visual Separation**: Distinguish between present and expected dancers
4. **Efficient Workflow**: Streamline the process of managing attendance during events

## Proposed Design

### 1. Single List Approach
The Present tab will show all dancers in a single, unified list:

#### Unified List Structure
- **All dancers with rankings**: Present, absent, and expected dancers in one list
- **Visual status indicators**: Clear visual distinction between present and expected dancers
- **Grouped by rank**: All dancers grouped by their rank, regardless of status
- **Status badges**: Each dancer shows their current status (Present, Expected, Absent)

#### Visual Design
- **Present dancers**: Normal appearance with full functionality
- **Expected dancers**: Muted appearance with "Expected" badge
- **Absent dancers**: Muted appearance with "Absent" badge
- **Status-based actions**: Different actions available based on dancer status

### 3. Enhanced FAB Menu
The Floating Action Button will provide a comprehensive menu:

#### Primary Actions (for Present Dancers):
- **Add New Dancer**: Create new dancer profile
- **Add Existing Dancer**: Mark unranked dancers as present
- **Record Dance**: Quick dance recording for present dancers

#### Secondary Actions (for Event Management):
- **Bulk Add Dancers**: Add multiple dancers at once
- **Manage Expected**: Expand/collapse expected dancers section

### 4. Enhanced Dancer Cards

#### Single Card Design:
- **Unified appearance**: All dancers use the same card component
- **Status badges**: Visual indicator showing Present/Expected/Absent status
- **Contextual actions**: Actions change based on dancer status
- **Consistent layout**: Same information structure for all dancers

#### Status-Based Actions:
- **Present dancers**: Record dance, mark as left, edit dancer, view history
- **Expected dancers**: Mark as present, remove from event, edit dancer, view history
- **Absent dancers**: Mark as present, remove from event, edit dancer, view history

### 5. Context Menu Actions

#### For Present Dancers:
- Mark as absent
- Mark as left
- Record dance
- Edit dancer
- View history

#### For Expected/Absent Dancers:
- Mark as present
- Remove from event
- Edit dancer
- View history

## Wireframes

### 1. Main Present Tab View

```
┌─────────────────────────────────────────────────────────┐
│ Event Name • Date                    [Settings] [Menu] │
│ [Present] • Summary                                   │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Advanced Dancers (3)                                  │
│  ┌─────────────────────────────────────────────────────┐ │
│  │ [Present] John Smith                    [Record]   │ │
│  │ Rank: Advanced • 2 dances recorded                 │ │
│  └─────────────────────────────────────────────────────┘ │
│  ┌─────────────────────────────────────────────────────┐ │
│  │ [Present] Sarah Johnson                  [Record]   │ │
│  │ Rank: Advanced • 1 dance recorded                  │ │
│  └─────────────────────────────────────────────────────┘ │
│  ┌─────────────────────────────────────────────────────┐ │
│  │ [Expected] Mike Wilson                             │ │
│  │ Rank: Advanced • Tap to mark present               │ │
│  └─────────────────────────────────────────────────────┘ │
│                                                         │
│  Intermediate Dancers (2)                               │
│  ┌─────────────────────────────────────────────────────┐ │
│  │ [Present] Lisa Brown                     [Record]   │ │
│  │ Rank: Intermediate • 0 dances recorded             │ │
│  └─────────────────────────────────────────────────────┘ │
│  ┌─────────────────────────────────────────────────────┐ │
│  │ [Absent] Tom Davis                                 │ │
│  │ Rank: Intermediate • Tap to mark present           │ │
│  └─────────────────────────────────────────────────────┘ │
│                                                         │
│  Beginner Dancers (1)                                   │
│  ┌─────────────────────────────────────────────────────┐ │
│  │ [Expected] Anna Lee                                │ │
│  │ Rank: Beginner • Tap to mark present               │ │
│  └─────────────────────────────────────────────────────┘ │
│                                                         │
│                                    [+ Add Dancers]      │
└─────────────────────────────────────────────────────────┘
```

### 2. Enhanced FAB Menu

```
┌─────────────────────────────────────────────────────────┐
│                    Add Dancers                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────────────────────────────────────────────┐ │
│  │ [👤] Add New Dancer                               │ │
│  │ Create a new dancer profile                       │ │
│  └─────────────────────────────────────────────────────┘ │
│                                                         │
│  ┌─────────────────────────────────────────────────────┐ │
│  │ [👥] Add Existing Dancer                          │ │
│  │ Mark unranked dancers as present                  │ │
│  └─────────────────────────────────────────────────────┘ │
│                                                         │
│  ┌─────────────────────────────────────────────────────┐ │
│  │ [📋] Bulk Add Dancers                             │ │
│  │ Add multiple dancers at once                       │ │
│  └─────────────────────────────────────────────────────┘ │
│                                                         │
│                                    [Cancel]             │
└─────────────────────────────────────────────────────────┘
```

### 3. Dancer Card States

#### Present Dancer Card
```
┌─────────────────────────────────────────────────────────┐
│ [Present] John Smith                        [Record]   │
│ Rank: Advanced • 2 dances recorded                    │
│ Tags: #regular, #advanced                             │
└─────────────────────────────────────────────────────────┘
```

#### Expected Dancer Card
```
┌─────────────────────────────────────────────────────────┐
│ [Expected] Mike Wilson                                │
│ Rank: Advanced • Tap to mark present                  │
│ Tags: #regular, #advanced                             │
└─────────────────────────────────────────────────────────┘
```

#### Absent Dancer Card
```
┌─────────────────────────────────────────────────────────┐
│ [Absent] Tom Davis                                    │
│ Rank: Intermediate • Tap to mark present              │
│ Tags: #regular, #intermediate                         │
└─────────────────────────────────────────────────────────┘
```

### 4. Context Menu Actions

#### For Present Dancers
```
┌─────────────────────────────────────────────────────────┐
│                    John Smith                          │
├─────────────────────────────────────────────────────────┤
│ [🎵] Record Dance                                     │
│ [↩️] Mark as Left                                     │
│ [✏️] Edit Dancer                                      │
│ [📊] View History                                     │
│ [❌] Mark as Absent                                   │
└─────────────────────────────────────────────────────────┘
```

#### For Expected/Absent Dancers
```
┌─────────────────────────────────────────────────────────┐
│                    Mike Wilson                         │
├─────────────────────────────────────────────────────────┤
│ [✅] Mark as Present                                  │
│ [🗑️] Remove from Event                                │
│ [✏️] Edit Dancer                                      │
│ [📊] View History                                     │
└─────────────────────────────────────────────────────────┘
```

### 5. Status Badge Design

#### Present Status
```
[Present] - Green background, white text
```

#### Expected Status  
```
[Expected] - Orange background, white text
```

#### Absent Status
```
[Absent] - Gray background, white text
```

## User Workflow

### 1. Normal Event Flow
1. **Open Present tab** → See all dancers grouped by rank
2. **Scan through list** → See present and expected dancers together
3. **Mark expected dancers as present** → Status changes to present
4. **Record dances** → For present dancers only

### 2. Mid-Event Additions
1. **Tap FAB** → Open action menu
2. **Choose "Bulk Add"** → Add multiple dancers at once
3. **New dancers appear** → In list with "Expected" status

### 3. Managing No-Shows
1. **Scan through list** → See expected dancers with muted appearance
2. **Long press dancer** → Open context menu
3. **Choose "Remove from event"** → Remove from roster
4. **Confirm action** → Dancer removed from list

## Benefits

### 1. Unified Interface
- **Single list** for all current event management
- **Reduced cognitive load** from complex section management
- **Streamlined workflow** for event organizers

### 2. Preserved Functionality
- **All critical features** from Planning tab maintained
- **Remove dancer capability** still available
- **Bulk operations** still supported

### 3. Improved UX
- **Clear visual hierarchy** between present and expected
- **Contextual actions** based on dancer status
- **Efficient workflow** for managing attendance

### 4. Reduced Complexity
- **Single list** instead of multiple sections
- **Consolidated actions** in one place
- **Simplified mental model** for users

## Migration Strategy

### Phase 1: Core Implementation
1. **Modify Present tab** to show all dancers with rankings
2. **Add status badges** to dancer cards
3. **Enhance FAB menu** with import/bulk actions
4. **Add remove dancer capability** to expected dancers

### Phase 2: Polish
1. **Visual refinements** for status badges and muted appearance
2. **Smooth animations** for status changes
3. **Performance optimization** for larger lists
4. **Accessibility improvements**

### Phase 3: Testing & Validation
1. **User testing** with event organizers
2. **Workflow validation** for different event types
3. **Performance testing** with large dancer lists
4. **Edge case handling** for various scenarios

## Success Metrics

### 1. User Adoption
- **Reduced tab switching** during events
- **Increased use** of import/bulk features
- **Positive user feedback** on unified interface

### 2. Efficiency Gains
- **Faster event setup** with unified interface
- **Reduced time** to manage attendance
- **Fewer clicks** to complete common tasks

### 3. Feature Usage
- **Maintained usage** of remove dancer feature
- **Improved adoption** of bulk operations

## Risks & Mitigation

### 1. UI Complexity
- **Risk**: Present tab becomes too complex
- **Mitigation**: Clear visual separation and collapsible sections

### 2. Performance
- **Risk**: Slower performance with larger lists
- **Mitigation**: Efficient data loading and virtual scrolling

### 3. User Confusion
- **Risk**: Users confused by combined interface
- **Mitigation**: Clear labels and intuitive interactions

## Conclusion

This redesign successfully addresses the critical functionality that would be lost by removing the Planning tab while providing a more streamlined user experience. The unified interface reduces cognitive load while maintaining all essential features for current event management.

The key insight is that during a current event, users primarily need to manage present dancers, but occasionally need access to expected dancer management. By making the expected dancer section collapsible and secondary, we maintain focus on the primary workflow while preserving critical functionality. 