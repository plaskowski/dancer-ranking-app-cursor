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
```dart
class DancerCrudService {
  // Archive a dancer
  Future<bool> archiveDancer(int dancerId) async {
    // Set isArchived = true, archivedAt = current timestamp
    // Preserve all existing data
  }

  // Reactivate a dancer
  Future<bool> reactivateDancer(int dancerId) async {
    // Set isArchived = false, archivedAt = null
    // Restore to active status
  }

  // Get archived dancers
  Future<List<Dancer>> getArchivedDancers() async {
    // Query dancers where isArchived = true
    // Order by archivedAt descending (most recently archived first)
  }
}
```

### DancerService Extensions
```dart
class DancerService {
  // Watch active dancers (exclude archived)
  Stream<List<DancerWithTags>> watchActiveDancersWithTags() {
    // Filter out archived dancers from existing watchDancersWithTags
  }

  // Watch all dancers (including archived)
  Stream<List<DancerWithTags>> watchAllDancersWithTags() {
    // Include archived dancers with visual distinction
  }

  // Get dancers for event planning (exclude archived)
  Stream<List<DancerWithEventInfo>> watchActiveDancersForEvent(int eventId) {
    // Filter out archived dancers from existing watchDancersForEvent
  }
}
```

## UI Component Changes

### DancerCardWithTags Modifications
```dart
class DancerCardWithTags extends StatelessWidget {
  final DancerWithTags dancer;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Expanded(child: Text(dancer.name)),
            if (dancer.isArchived) 
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'archived',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
        // ... existing content
      ),
    );
  }
}
```

### DancersScreen Enhancements
```dart
class DancersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dancers'),
        actions: [
          // Archive option in context menu
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'merge', child: Text('Merge into...')),
              PopupMenuItem(value: 'archive', child: Text('Archive')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            onSelected: (value) {
              if (value == 'archive') {
                _showArchiveConfirmation(context, dancer);
              }
              // ... other actions
            },
          ),
        ],
      ),
      body: StreamBuilder<List<DancerWithTags>>(
        stream: dancerService.watchAllDancersWithTags(), // Show all including archived
        builder: (context, snapshot) {
          // ... existing builder logic
        },
      ),
    );
  }
}
```

### Archive Confirmation Dialog
```dart
class ArchiveConfirmationDialog extends StatelessWidget {
  final Dancer dancer;
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Archive Dancer'),
      content: Text(
        'Archive "${dancer.name}"? This will:\n'
        '• Hide them from event planning\n'
        '• Preserve all dance history\n'
        '• Allow easy reactivation later',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Archive'),
        ),
      ],
    );
  }
}
```

## Event Planning Integration

### SelectDancersScreen Modifications
```dart
class SelectDancersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DancerWithTags>>(
      // Use watchActiveDancersWithTags() instead of watchDancersWithTags()
      stream: dancerService.watchActiveDancersWithTags(),
      builder: (context, snapshot) {
        // Archived dancers automatically excluded
        // No UI changes needed - just cleaner data
      },
    );
  }
}
```

### AddExistingDancerScreen Modifications
```dart
class AddExistingDancerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DancerWithEventInfo>>(
      // Use watchActiveDancersForEvent() instead of watchDancersForEvent()
      stream: dancerService.watchActiveDancersForEvent(eventId),
      builder: (context, snapshot) {
        // Archived dancers automatically excluded from event attendance
      },
    );
  }
}
```

## Data Flow

### Archival Process
1. User taps dancer → "Archive" in context menu
2. ArchiveConfirmationDialog shows
3. User confirms → DancerCrudService.archiveDancer() called
4. Database updated: isArchived = true, archivedAt = now
5. UI automatically updates via StreamBuilder
6. Dancer appears with "archived" label

### Reactivation Process
1. User finds archived dancer in main list
2. User taps dancer → "Reactivate" in context menu
3. DancerCrudService.reactivateDancer() called
4. Database updated: isArchived = false, archivedAt = null
5. UI automatically updates via StreamBuilder
6. Dancer appears without "archived" label

### Event Planning Filtering
1. Event planning screens use active-only streams
2. Archived dancers automatically excluded
3. No UI changes needed - just cleaner data
4. Users see only active dancers in planning contexts

## Migration Strategy

### Phase 1: Database Migration
- Add new columns to dancers table
- Set default values for existing data
- Test migration on sample data

### Phase 2: Service Layer
- Implement archival methods in DancerCrudService
- Add active-only streams to DancerService
- Update existing queries to respect archival status

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

## Testing Strategy

### Unit Tests
- DancerCrudService archival methods
- DancerService stream filtering
- Database migration scripts

### Integration Tests
- End-to-end archival workflow
- Event planning integration
- Data preservation verification

### UI Tests
- Archive confirmation dialog
- Archived dancer display
- Context menu interactions 