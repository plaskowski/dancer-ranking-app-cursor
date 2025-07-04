# Dancer Archival Feature

## Problem Statement
As the dance community grows and evolves, some dancers become inactive (stop attending events, move away, or change dance styles). Currently, all dancers remain in the active list, making it harder to focus on currently active community members during event planning and management.

## User Pain Points
- **Cluttered Lists**: Active dancer lists become overwhelming with 100+ inactive dancers
- **Planning Difficulty**: Hard to focus on who's actually likely to attend current events
- **Memory Overload**: Too many names to scan through when planning events
- **Historical Preservation**: Fear of losing important dance history if removing dancers

## Proposed Solution
A dancer archival system that allows users to archive inactive dancers while preserving their complete history and enabling easy reactivation when needed.

## Core User Experience

### 1. Archival Concept
- **"Archive" vs "Delete"**: Archiving is reversible, deletion is permanent
- **Preserved History**: All dance history, scores, and relationships remain intact
- **Hidden from Active View**: Archived dancers don't clutter current planning
- **Easy Recovery**: One-click reactivation when dancers return

### 2. When to Archive
- **Moved Away**: Dancers who have relocated and won't attend local events
- **Changed Styles**: Dancers who switched to different dance forms
- **Long Absence**: Dancers who haven't attended events in 6+ months
- **Life Changes**: Dancers who got busy with work, family, or other commitments

### 3. User Workflows

#### Archiving a Dancer
1. **Trigger**: User notices dancer hasn't been seen in a while
2. **Action**: Navigate to Dancers screen → tap dancer → "Archive"
3. **Confirmation**: Dialog explains what archival means (preserves history, reversible)
4. **Result**: Dancer disappears from active list, appears in archived section

#### Reactivating a Dancer
1. **Trigger**: Dancer returns to community or user wants to include them
2. **Action**: Navigate to Dancers screen → find archived dancer → "Reactivate"
3. **Result**: Dancer immediately returns to active list with all history intact

## User Interface Design

### 1. Dancers Screen Enhancement
- **Archive Option**: Add "Archive" to existing context menu (Edit, Merge, Delete)
- **Archived Label**: Show "archived" label on archived dancers in main dancers screen
- **Show Archived**: Display archived dancers on main dancers screen with visual distinction
- **Visual Distinction**: Archived dancers have muted appearance with grey "archived" label
- **Same Capabilities**: Search, view history, and manage archived dancers like active dancers
- **Reactivation**: "Archive" becomes "Reactivate" in context menu for archived dancers

### 2. Event Planning Integration
- **Skip Archived**: Archived dancers are automatically excluded from event planning dancer selection
- **Simple Behavior**: No complex toggles or options - just clean separation

## User Benefits

### 1. Cleaner Planning Experience
- **Focused Lists**: Only see currently active community members
- **Faster Selection**: Less scrolling and searching through inactive dancers
- **Better Memory**: Easier to remember who's actually likely to attend

### 2. Community Management
- **Historical Preservation**: Keep all dance history without cluttering current view
- **No Guilt**: Archiving feels less permanent than deletion
- **Easy Recovery**: No fear of losing important relationships

## User Scenarios

### Scenario 1: Weekly Social Planning
**Context**: Planning weekly social dance event
**Problem**: 150+ dancers in list, but only 30-40 actually attend regularly
**Solution**: Archive 100+ inactive dancers, focus on active community
**Result**: Clean list of likely attendees, faster planning

### Scenario 2: Dancer Returns
**Context**: Former regular dancer shows up at event after 6-month absence
**Problem**: They're not in active list, need to add them back
**Solution**: Go to Dancers screen → find archived dancer → Reactivate
**Result**: All their history preserved, immediately back in active list

### Scenario 3: Event Planning with Clean Lists
**Context**: Adding dancers to upcoming event planning
**Problem**: Event planning shows all 150+ dancers including inactive ones
**Solution**: Archived dancers are automatically excluded from planning selection
**Result**: Only see active dancers in planning, faster and more focused selection

### Scenario 4: Managing Community Growth
**Context**: Dance community has grown from 20 to 80 regulars over 2 years
**Problem**: Old inactive dancers clutter the main dancers list
**Solution**: Archive dancers who moved away or changed styles, they remain visible with "archived" label
**Result**: Cleaner main list while preserving all historical data and relationships

## Success Metrics
- **Reduced Planning Time**: Faster dancer selection for events
- **Improved Focus**: Users can concentrate on active community members
- **Preserved Relationships**: No loss of important dance history
- **User Satisfaction**: Less frustration with cluttered lists 