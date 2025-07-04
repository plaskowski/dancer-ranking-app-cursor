# Dancer Archival Feature

## Problem Statement
As the dance community grows and evolves, some dancers become inactive (stop attending events, move away, or change dance styles). Currently, all dancers remain in the active list, making it harder to focus on currently active community members during event planning and management.

## User Pain Points
- **Cluttered Lists**: Active dancer lists become overwhelming with 100+ inactive dancers
- **Planning Difficulty**: Hard to focus on who's actually likely to attend current events
- **Memory Overload**: Too many names to scan through when planning events
- **Community Evolution**: No way to acknowledge that some dancers have moved on
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
- **Life Changes**: Dancers who got busy with work, family, or other commitments
- **Long Absence**: Dancers who haven't attended events in 6+ months
- **Community Evolution**: Natural turnover as dance communities grow and change

### 3. User Workflows

#### Archiving a Dancer
1. **Trigger**: User notices dancer hasn't been seen in a while
2. **Action**: Navigate to Dancers screen → tap dancer → "Archive"
3. **Confirmation**: Dialog explains what archival means (preserves history, reversible)
4. **Optional Note**: Add reason like "moved to NYC" or "switched to tango"
5. **Result**: Dancer disappears from active list, appears in archived section

#### Reactivating a Dancer
1. **Trigger**: Dancer returns to community or user wants to include them
2. **Action**: Go to Archived Dancers → find dancer → "Reactivate"
3. **Result**: Dancer immediately returns to active list with all history intact

#### Event Planning with Archived Dancers
1. **Scenario**: Planning a special event where archived dancers might attend
2. **Action**: Toggle "Include Archived" during dancer selection
3. **Result**: Archived dancers appear with visual indicator, can be selected normally

## User Interface Design

### 1. Dancers Screen Enhancement
- **Archive Option**: Add "Archive" to existing context menu (Edit, Merge, Delete)
- **Archive Count**: Small badge showing number of archived dancers
- **View Archived**: Subtle link/button to access archived section
- **Visual Hierarchy**: Clear separation between active and archived sections

### 2. Archived Dancers Screen
- **Dedicated Space**: Separate screen for archived dancer management
- **Same Capabilities**: Search, filter, and view history like active dancers
- **Reactivation**: Prominent "Reactivate" button for each dancer
- **Archive Details**: Show when and why dancer was archived
- **Bulk Operations**: Select multiple dancers to reactivate at once

### 3. Event Planning Integration
- **Include Archived Toggle**: Simple toggle during dancer selection
- **Visual Indicators**: Archived dancers clearly marked in selection lists
- **Smart Suggestions**: System suggests including archived dancers for events they historically attended
- **Automatic Reactivation**: If archived dancer is added to event, they're automatically reactivated

## User Benefits

### 1. Cleaner Planning Experience
- **Focused Lists**: Only see currently active community members
- **Faster Selection**: Less scrolling and searching through inactive dancers
- **Better Memory**: Easier to remember who's actually likely to attend

### 2. Community Management
- **Natural Evolution**: Acknowledge that communities change over time
- **Historical Preservation**: Keep all dance history without cluttering current view
- **Flexible Inclusion**: Can still include archived dancers when appropriate

### 3. Emotional Benefits
- **No Guilt**: Archiving feels less permanent than deletion
- **Easy Recovery**: No fear of losing important relationships
- **Community Growth**: Supports natural community turnover and evolution

## User Scenarios

### Scenario 1: Weekly Social Planning
**Context**: Planning weekly social dance event
**Problem**: 150+ dancers in list, but only 30-40 actually attend regularly
**Solution**: Archive 100+ inactive dancers, focus on active community
**Result**: Clean list of likely attendees, faster planning

### Scenario 2: Special Event Planning
**Context**: Planning anniversary party or special event
**Problem**: Want to invite some dancers who haven't been active recently
**Solution**: Toggle "Include Archived" during planning
**Result**: Can easily include former regulars for special occasions

### Scenario 3: Dancer Returns
**Context**: Former regular dancer shows up at event after 6-month absence
**Problem**: They're not in active list, need to add them back
**Solution**: Go to Archived Dancers → find them → Reactivate
**Result**: All their history preserved, immediately back in active list

### Scenario 4: Community Evolution
**Context**: Dance community has grown from 20 to 80 regulars over 2 years
**Problem**: Old inactive dancers clutter current planning
**Solution**: Archive dancers who moved away or changed styles
**Result**: Focus on current community while preserving history

## Success Metrics
- **Reduced Planning Time**: Faster dancer selection for events
- **Improved Focus**: Users can concentrate on active community members
- **Preserved Relationships**: No loss of important dance history
- **Community Growth**: Support for natural community evolution
- **User Satisfaction**: Less frustration with cluttered lists

## Future Considerations
- **Automatic Suggestions**: System could suggest archival for very inactive dancers
- **Archival Analytics**: Insights into community turnover patterns
- **Smart Reactivation**: Automatic suggestions when archived dancers might return
- **Community Insights**: Understanding of community growth and evolution over time 