# Dancer Archival - Technical Specification

## Database Schema Changes

### Dancers Table Modifications
```sql
ALTER TABLE dancers ADD COLUMN isArchived BOOLEAN DEFAULT FALSE;
ALTER TABLE dancers ADD COLUMN archivedAt DATETIME;
```

**New Fields:**
- `isArchived` (Boolean, Default: false) - Archive status flag
- `archivedAt` (DateTime, Nullable) - When dancer was archived

**Migration Strategy:**
- Add columns with default values
- Existing dancers remain active (isArchived = false)
- archivedAt is null for active dancers

## Service Layer Changes

### DancerCrudService Extensions
- `archiveDancer(int dancerId)` - Set isArchived = true, archivedAt = current timestamp
- `reactivateDancer(int dancerId)` - Set isArchived = false, archivedAt = null
- `getArchivedDancers()` - Query dancers where isArchived = true, ordered by archivedAt
- `watchActiveDancers()` - Stream of active dancers only

### DancerService Extensions
- `watchActiveDancersWithTags()` - Filter out archived dancers from existing streams
- `watchAllDancersWithTags()` - Include archived dancers with visual distinction
- `watchActiveDancers()` - Stream of active dancers only
- `searchActiveDancers(String query)` - Search only active dancers
- `getActiveDancersWithTags()` - Get active dancers with tags
- `watchActiveDancersWithTags()` - Stream of active dancers with tags

### DancerSearchService Extensions
- `searchActiveDancers(String query)` - Search only active dancers by name

### DancerTagService Extensions
- `getActiveDancersWithTags()` - Get active dancers with their tags
- `watchActiveDancersWithTags()` - Stream of active dancers with tags

## Screen Wireframes

### 1. Dancers Screen - Main View
```
┌─────────────────────────────────────┐
│ Dancers                    [+ FAB]  │
├─────────────────────────────────────┤
│ [Search dancers...]                 │
│                                     │
│ [Monday Class] [Friday Social] [✕]  │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ Alice Rodriguez                 │ │
│ │ Great dancer, very friendly     │ │
│ │ [Monday Class] [Friday Social]  │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Bob Martinez              [archived] │
│ │ Moved to NYC last month        │ │
│ │ [Cuban DC Festival]            │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Carlos Thompson                 │ │
│ │ Regular at Monday classes       │ │
│ │ [Monday Class]                  │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

### 2. Dancer Context Menu
```
┌─────────────────────────────────────┐
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Edit                            │ │
│ ├─────────────────────────────────┤ │
│ │ Merge into...                   │ │
│ ├─────────────────────────────────┤ │
│ │ Archive                         │ │
│ ├─────────────────────────────────┤ │
│ │ Delete                          │ │
│ └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

### 3. Archive Confirmation Dialog
```
┌─────────────────────────────────────┐
│ Archive Dancer                     │
├─────────────────────────────────────┤
│                                     │
│ Archive "Bob Martinez"? This will:  │
│                                     │
│ • Hide them from event planning     │
│ • Preserve all dance history        │
│ • Allow easy reactivation later     │
│                                     │
├─────────────────────────────────────┤
│ [Cancel]        [Archive]           │
└─────────────────────────────────────┘
```

### 4. Event Planning - Select Dancers Screen
```
┌─────────────────────────────────────┐
│ Select Dancers to Add               │
├─────────────────────────────────────┤
│ [Search dancers...]                 │
│                                     │
│ [Monday Class] [Friday Social] [✕]  │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ ☐ Alice Rodriguez               │ │
│ │ Great dancer, very friendly     │ │
│ │ [Monday Class] [Friday Social]  │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ ☐ Carlos Thompson               │ │
│ │ Regular at Monday classes       │ │
│ │ [Monday Class]                  │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ ☐ Diana Chang                   │ │
│ │ Festival dancer, great energy   │ │
│ │ [Cuban DC Festival] [Friday Social] │
│ └─────────────────────────────────┘ │
│                                     │
│ [Add Selected Dancers]              │
└─────────────────────────────────────┘
```

### 5. Reactivation Context Menu
```
┌─────────────────────────────────────┐
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Edit                            │ │
│ ├─────────────────────────────────┤ │
│ │ Merge into...                   │ │
│ ├─────────────────────────────────┤ │
│ │ Reactivate                      │ │
│ ├─────────────────────────────────┤ │
│ │ Delete                          │ │
│ └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

## Visual Design Specifications

### Archived Dancer Label
- **Style**: Grey pill with italic text
- **Text**: "archived" in lowercase
- **Color**: Grey with 20% opacity background
- **Position**: Right side of dancer name
- **Size**: 12px font, compact padding

### Context Menu Changes
- **Archive Option**: Added between "Merge into..." and "Delete"
- **Reactivation**: "Archive" becomes "Reactivate" for archived dancers
- **Icon**: Archive icon (box with arrow) for visual clarity

### Event Planning Integration
- **No UI Changes**: Archived dancers simply don't appear
- **Clean Lists**: Only active dancers shown in selection screens
- **Automatic Filtering**: No toggles or options needed

## Data Flow

### Archival Process
1. User navigates to Dancers Screen
2. User taps dancer → "Archive" in context menu
3. ArchiveConfirmationDialog shows
4. User confirms → Database updated
5. UI automatically updates via StreamBuilder
6. Dancer appears with "archived" label on Dancers Screen

### Reactivation Process
1. User navigates to Dancers Screen
2. User finds archived dancer in main list (shows "archived" label)
3. User taps dancer → "Reactivate" in context menu
4. Database updated: isArchived = false
5. UI automatically updates via StreamBuilder
6. Dancer appears without "archived" label on Dancers Screen

### Event Planning Filtering
1. Event planning screens use active-only streams
2. Archived dancers automatically excluded
3. No UI changes needed - just cleaner data
4. Users see only active dancers in planning contexts

## Migration Strategy

### Phase 1: Database Migration ✅ COMPLETED
- Add new columns to dancers table
- Set default values for existing data
- Test migration on sample data

### Phase 2: Service Layer ✅ COMPLETED
- Implement archival methods in DancerCrudService
- Add active-only streams to DancerService
- Update existing queries to respect archival status
- Add active-only search functionality
- Add active-only tag filtering

### Phase 3: UI Components
- Update DancerCardWithTags to show archived label
- Add archive option to context menus
- Implement ArchiveConfirmationDialog
- Update event planning screens to use active-only data

### Phase 4: Testing
- Test archival workflow end-to-end
- Verify event planning excludes archived dancers
- Test reactivation process
- Verify data preservation

## Error Handling

### Database Errors
- Transaction rollback on archival failures
- User feedback via toast notifications
- Graceful degradation if archival fails

### UI State Management
- Loading states during archival operations
- Error states with retry options
- Optimistic updates with rollback on failure

## Performance Considerations

### Query Optimization
- Index on isArchived column for fast filtering
- Separate streams for active vs all dancers
- Efficient joins with archival status

### UI Performance
- Minimal re-renders during archival operations
- Efficient list updates via StreamBuilder
- Smooth transitions between archived/active states

## Test Cases

### Database Tests

#### Migration Tests
- **Test**: Migration adds columns with correct defaults
  - **Given**: Existing dancers table with data
  - **When**: Migration runs
  - **Then**: isArchived = false, archivedAt = null for all existing dancers

- **Test**: Migration preserves existing data
  - **Given**: Dancers with names, notes, tags, and history
  - **When**: Migration runs
  - **Then**: All existing data remains intact

#### Archival Tests
- **Test**: Archive dancer sets correct fields
  - **Given**: Active dancer
  - **When**: archiveDancer() called
  - **Then**: isArchived = true, archivedAt = current timestamp

- **Test**: Reactivate dancer clears fields
  - **Given**: Archived dancer
  - **When**: reactivateDancer() called
  - **Then**: isArchived = false, archivedAt = null

- **Test**: Archive preserves all related data
  - **Given**: Dancer with rankings, attendances, tags, notes
  - **When**: archiveDancer() called
  - **Then**: All rankings, attendances, tags, notes remain intact

### Service Layer Tests

#### DancerCrudService Tests
- **Test**: archiveDancer returns success
  - **Given**: Valid dancer ID
  - **When**: archiveDancer() called
  - **Then**: Returns true, database updated

- **Test**: archiveDancer handles invalid dancer
  - **Given**: Non-existent dancer ID
  - **When**: archiveDancer() called
  - **Then**: Returns false, no database changes

- **Test**: reactivateDancer returns success
  - **Given**: Archived dancer ID
  - **When**: reactivateDancer() called
  - **Then**: Returns true, database updated

- **Test**: getArchivedDancers returns correct list
  - **Given**: Mix of active and archived dancers
  - **When**: getArchivedDancers() called
  - **Then**: Returns only archived dancers, ordered by archivedAt desc

#### DancerService Stream Tests
- **Test**: watchActiveDancersWithTags excludes archived
  - **Given**: Mix of active and archived dancers
  - **When**: watchActiveDancersWithTags() stream
  - **Then**: Only active dancers appear in stream

- **Test**: watchAllDancersWithTags includes archived
  - **Given**: Mix of active and archived dancers
  - **When**: watchAllDancersWithTags() stream
  - **Then**: All dancers appear with archived status

- **Test**: watchActiveDancersForEvent excludes archived
  - **Given**: Event with active and archived dancers
  - **When**: watchActiveDancersForEvent() stream
  - **Then**: Only active dancers appear for event planning

### UI Component Tests

#### DancerCardWithTags Tests
- **Test**: Active dancer shows no archived label
  - **Given**: Dancer with isArchived = false
  - **When**: DancerCardWithTags rendered
  - **Then**: No "archived" label visible

- **Test**: Archived dancer shows archived label
  - **Given**: Dancer with isArchived = true
  - **When**: DancerCardWithTags rendered
  - **Then**: Grey "archived" label visible on right side

- **Test**: Archived label has correct styling
  - **Given**: Archived dancer
  - **When**: DancerCardWithTags rendered
  - **Then**: Label has grey background, italic text, 12px font

#### Context Menu Tests
- **Test**: Active dancer shows Archive option
  - **Given**: Active dancer context menu
  - **When**: Menu opened
  - **Then**: "Archive" option appears between "Merge into..." and "Delete"

- **Test**: Archived dancer shows Reactivate option
  - **Given**: Archived dancer context menu
  - **When**: Menu opened
  - **Then**: "Reactivate" option appears instead of "Archive"

#### ArchiveConfirmationDialog Tests
- **Test**: Dialog shows correct dancer name
  - **Given**: Dancer "Bob Martinez"
  - **When**: ArchiveConfirmationDialog opened
  - **Then**: Dialog shows "Archive 'Bob Martinez'?"

- **Test**: Dialog explains archival effects
  - **Given**: ArchiveConfirmationDialog opened
  - **When**: Content displayed
  - **Then**: Shows bullet points about hiding from planning, preserving history, allowing reactivation

- **Test**: Cancel button closes dialog
  - **Given**: ArchiveConfirmationDialog open
  - **When**: Cancel button tapped
  - **Then**: Dialog closes, no archival occurs

- **Test**: Archive button triggers archival
  - **Given**: ArchiveConfirmationDialog open
  - **When**: Archive button tapped
  - **Then**: Dialog closes, dancer archived

### Integration Tests

#### End-to-End Archival Workflow
- **Test**: Complete archival process
  - **Given**: Active dancer in Dancers screen
  - **When**: User taps dancer → Archive → confirms
  - **Then**: Dancer shows "archived" label, excluded from event planning

- **Test**: Complete reactivation process
  - **Given**: Archived dancer in Dancers screen
  - **When**: User taps dancer → Reactivate
  - **Then**: Dancer loses "archived" label, included in event planning

#### Event Planning Integration
- **Test**: Event planning excludes archived dancers
  - **Given**: Mix of active and archived dancers
  - **When**: User opens Select Dancers screen
  - **Then**: Only active dancers appear in selection list

- **Test**: Add Existing Dancer excludes archived
  - **Given**: Mix of active and archived dancers
  - **When**: User opens Add Existing Dancer screen
  - **Then**: Only active dancers appear in list

#### Data Preservation Tests
- **Test**: Archived dancer history preserved
  - **Given**: Dancer with event history, rankings, scores
  - **When**: Dancer archived then reactivated
  - **Then**: All history, rankings, scores remain intact

- **Test**: Archived dancer tags preserved
  - **Given**: Dancer with multiple tags
  - **When**: Dancer archived then reactivated
  - **Then**: All tags remain assigned

### Error Handling Tests

#### Database Error Tests
- **Test**: Archive fails gracefully
  - **Given**: Database connection error
  - **When**: archiveDancer() called
  - **Then**: User sees error message, dancer remains active

- **Test**: Reactivate fails gracefully
  - **Given**: Database connection error
  - **When**: reactivateDancer() called
  - **Then**: User sees error message, dancer remains archived

#### UI Error Tests
- **Test**: Loading state during archival
  - **Given**: Slow database operation
  - **When**: Archive button tapped
  - **Then**: Loading indicator shows, buttons disabled

- **Test**: Error state with retry
  - **Given**: Archival operation fails
  - **When**: Error occurs
  - **Then**: Error message shows with retry option

### Performance Tests

#### Query Performance
- **Test**: Active dancers query performance
  - **Given**: 1000 dancers (100 archived, 900 active)
  - **When**: watchActiveDancersWithTags() called
  - **Then**: Query completes in <100ms

- **Test**: All dancers query performance
  - **Given**: 1000 dancers (100 archived, 900 active)
  - **When**: watchAllDancersWithTags() called
  - **Then**: Query completes in <100ms

#### UI Performance
- **Test**: List rendering with archived dancers
  - **Given**: 100 dancers (20 archived)
  - **When**: Dancers screen loads
  - **Then**: Screen renders in <200ms

- **Test**: Archive operation responsiveness
  - **Given**: Active dancer
  - **When**: Archive operation performed
  - **Then**: UI updates within 100ms

### Edge Case Tests

#### Boundary Conditions
- **Test**: Archive already archived dancer
  - **Given**: Already archived dancer
  - **When**: archiveDancer() called
  - **Then**: No change, returns false

- **Test**: Reactivate already active dancer
  - **Given**: Already active dancer
  - **When**: reactivateDancer() called
  - **Then**: No change, returns false

#### Data Integrity
- **Test**: Archive dancer with ongoing event
  - **Given**: Dancer with active event attendance
  - **When**: Dancer archived
  - **Then**: Event attendance preserved, dancer excluded from future planning

- **Test**: Archive dancer with pending rankings
  - **Given**: Dancer with rankings for future events
  - **When**: Dancer archived
  - **Then**: Rankings preserved, dancer excluded from event planning

### Accessibility Tests

#### Screen Reader Support
- **Test**: Archived label accessibility
  - **Given**: Archived dancer
  - **When**: Screen reader focuses on dancer card
  - **Then**: "archived" status announced

- **Test**: Context menu accessibility
  - **Given**: Dancer context menu
  - **When**: Screen reader navigates menu
  - **Then**: Archive/Reactivate options properly announced

#### Keyboard Navigation
- **Test**: Archive via keyboard
  - **Given**: Dancer selected via keyboard
  - **When**: Archive option selected via keyboard
  - **Then**: Confirmation dialog opens, can be completed via keyboard 