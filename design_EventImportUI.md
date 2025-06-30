# Event Import UI Design Document

## Overview
This document outlines the user interface design for the Event Import feature, enabling users to bulk import historical event data with attendance information from JSON files.

## Design Principles

### Following Established Patterns
- **Multi-step dialog approach**: Similar to existing DancerImportDialog with stepper navigation
- **Consistent visual language**: Material Design components with app color scheme
- **Action logging integration**: Comprehensive logging following app patterns
- **Error handling**: User-friendly messages with snackbar notifications
- **Progress indication**: Clear feedback during import operations

### User Experience Goals
- **Simple workflow**: Guided step-by-step process
- **Data preview**: Users can review before importing
- **Safe operation**: Clear confirmation and rollback capabilities
- **Informative feedback**: Detailed results and statistics

## Component Architecture

### Main Components
1. **ImportEventsDialog**: Main dialog component with stepper navigation
2. **FileSelectionStep**: JSON file picker and initial validation
3. **DataPreviewStep**: Preview events and attendances before import
4. **ImportOptionsStep**: Configure import settings and handle conflicts
5. **ResultsStep**: Display import results and statistics

### Supporting Components
- **EventPreviewCard**: Display individual event information
- **AttendancePreviewList**: Show attendance records for events
- **ConflictResolutionWidget**: Handle duplicate events and missing dancers
- **ImportProgressIndicator**: Show import progress during execution

## Dialog Flow Design

### Step 1: File Selection
```
┌─────────────────────────────────────────┐
│ Import Events                       [X] │
├─────────────────────────────────────────┤
│ Step 1 of 4: Select File               │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │  📁 Select JSON File                │ │
│ │                                     │ │
│ │  Drop file here or click to browse │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ Supported format: JSON files with      │
│ events and attendance data              │
│                                         │
│           [Cancel]      [Next]          │
└─────────────────────────────────────────┘
```

**Functionality:**
- File picker button to select JSON file
- Drag & drop support (if supported by platform)
- Initial file validation (JSON structure check)
- Progress indicator during file parsing
- Error display for invalid files

### Step 2: Data Preview
```
┌─────────────────────────────────────────┐
│ Import Events                       [X] │
├─────────────────────────────────────────┤
│ Step 2 of 4: Preview Data              │
│                                         │
│ 📊 Import Summary                       │
│ • 3 events to import                    │
│ • 15 total attendances                  │
│ • 8 unique dancers                      │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ 🎉 Salsa Night at Club XYZ         │ │
│ │ 📅 January 15, 2024                 │ │
│ │ 👥 5 attendances                    │ │
│ │   • Anna Kowalska (served)          │ │
│ │   • Maria Nowak (present)           │ │
│ │   • Kasia Panterka (left)           │ │
│ │   • ... 2 more                      │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ⚠️  2 potential conflicts detected      │
│                                         │
│      [Back]      [Cancel]      [Next]   │
└─────────────────────────────────────────┘
```

**Functionality:**
- Import statistics summary at top
- Scrollable list of events to be imported
- Expandable event cards showing attendance details
- Conflict indicator if issues detected
- Data validation status display

### Step 3: Import Options & Conflicts
```
┌─────────────────────────────────────────┐
│ Import Events                       [X] │
├─────────────────────────────────────────┤
│ Step 3 of 4: Configure Import          │
│                                         │
│ ⚙️ Import Options                       │
│ ☑️ Create missing dancers automatically │
│ ☑️ Skip duplicate events                │
│ ☐ Validation only (don't import)       │
│                                         │
│ ⚠️ Conflicts Found                      │
│ ┌─────────────────────────────────────┐ │
│ │ 🔄 Event "Friday Salsa" (Jan 12)    │ │
│ │    Already exists in database       │ │
│ │    Action: Skip (due to settings)   │ │
│ └─────────────────────────────────────┘ │
│ ┌─────────────────────────────────────┐ │
│ │ 👤 Missing dancer: "Alex Unknown"   │ │
│ │    Will be created automatically    │ │
│ └─────────────────────────────────────┘ │
│                                         │
│      [Back]      [Cancel]      [Import] │
└─────────────────────────────────────────┘
```

**Functionality:**
- Checkboxes for import configuration options
- List of detected conflicts with resolution strategies
- Real-time conflict update based on option changes
- Clear indication of what will happen during import
- Import button enabled only when conflicts are resolved

### Step 4: Import Results
```
┌─────────────────────────────────────────┐
│ Import Events                       [X] │
├─────────────────────────────────────────┤
│ Step 4 of 4: Import Complete           │
│                                         │
│ ✅ Import Successful!                   │
│                                         │
│ 📊 Results Summary                      │
│ • Events processed: 3                   │
│ • Events created: 2                     │
│ • Events skipped: 1                     │
│ • Attendances created: 10               │
│ • Dancers created: 3                    │
│                                         │
│ ⚠️ Warnings (if any)                    │
│ • 1 event was skipped due to duplicate │
│                                         │
│ 🔍 View Details                         │
│ [Show detailed log]                     │
│                                         │
│                    [Done]               │
└─────────────────────────────────────────┘
```

**Functionality:**
- Success/failure status with appropriate icons
- Detailed statistics of import results
- Warning section for non-critical issues
- Expandable detailed log section
- Navigation back to application

## Integration Points

### Home Screen Integration
- **Import button**: Add import button to Home screen app bar
- **Location**: Next to existing manage buttons (tags, ranks)
- **Icon**: `Icons.upload_file` or `Icons.import_export`
- **Action**: Opens ImportEventsDialog

### Event Screen Integration
- **Refresh trigger**: Refresh event list after successful import
- **Navigation**: Option to navigate to newly imported events
- **Status indication**: Show recent import status if applicable

## UI Components Specification

### ImportEventsDialog
```dart
class ImportEventsDialog extends StatefulWidget {
  const ImportEventsDialog({super.key});

  @override
  State<ImportEventsDialog> createState() => _ImportEventsDialogState();
}
```

**Properties:**
- Full-screen modal dialog on mobile, large dialog on desktop
- Stepper widget for navigation between steps
- AppBar with title and close button
- Progress indicator during operations
- Keyboard shortcuts support (ESC to close)

### EventPreviewCard
```dart
class EventPreviewCard extends StatelessWidget {
  final ImportableEvent event;
  final bool showAttendances;
  
  const EventPreviewCard({
    super.key,
    required this.event,
    this.showAttendances = true,
  });
}
```

**Visual Design:**
- Card with elevation and rounded corners
- Event name as title with event icon
- Date display with calendar icon
- Attendance count summary
- Expandable attendance list with status icons
- Status color coding (present: blue, served: green, left: orange)

### ConflictIndicator
```dart
class ConflictIndicator extends StatelessWidget {
  final List<EventImportConflict> conflicts;
  final EventImportOptions options;
  
  const ConflictIndicator({
    super.key,
    required this.conflicts,
    required this.options,
  });
}
```

**Visual Design:**
- Warning card with amber background
- Conflict type icons (duplicate, missing dancer, invalid data)
- Resolution strategy display
- Action buttons for conflict resolution

## Error Handling

### Parse Errors
- **Display**: Red error card with error icon
- **Message**: User-friendly explanation of JSON issues
- **Action**: Back to file selection step
- **Example**: "Invalid JSON format. Please check your file and try again."

### Validation Errors
- **Display**: Warning cards in conflicts section
- **Message**: Specific field validation issues
- **Action**: User can choose to continue or fix issues
- **Example**: "Event name too long (max 100 characters)"

### Import Errors
- **Display**: Error section in results step
- **Message**: Detailed error information
- **Action**: Option to retry or export error log
- **Example**: "Failed to create 2 events due to database error"

## Accessibility Features

### Keyboard Navigation
- Tab navigation through all interactive elements
- Enter key activates primary actions
- ESC key closes dialog
- Arrow keys navigate through lists

### Screen Reader Support
- Semantic labels for all icons and buttons
- Progress announcements during operations
- Status announcements for success/failure
- Descriptive text for visual elements

### Visual Accessibility
- High contrast colors for status indicators
- Large touch targets (minimum 44px)
- Clear focus indicators
- Readable font sizes throughout

## Performance Considerations

### Large File Handling
- **Chunked parsing**: Process large JSON files in chunks
- **Progress indication**: Show progress for file parsing
- **Memory management**: Stream processing for very large imports
- **Timeout handling**: Graceful handling of slow operations

### UI Responsiveness
- **Async operations**: All import operations run asynchronously
- **Loading states**: Clear loading indicators during operations
- **Debounced validation**: Avoid excessive validation calls
- **Efficient updates**: Minimal rebuilds during preview

## Mobile Adaptations

### Small Screen Layout
- **Full-screen dialog**: Use full screen on mobile devices
- **Simplified navigation**: Larger buttons and touch targets
- **Collapsible sections**: Expandable details to save space
- **Scrollable content**: Proper scrolling for long lists

### Platform-Specific Features
- **File picker**: Native file picker integration
- **Share integration**: Import from shared files (if supported)
- **Notifications**: System notifications for completed imports
- **Background processing**: Handle app backgrounding during import

## Testing Strategy

### Unit Testing
- Component rendering tests
- File parsing validation
- Error handling scenarios
- Option configuration tests

### Integration Testing
- Complete import workflow
- Service integration testing
- Database transaction testing
- Error recovery testing

### User Testing
- File selection usability
- Preview clarity and completeness
- Option configuration understanding
- Results interpretation

## Implementation Priority

### Phase 1: Core Functionality
1. Basic ImportEventsDialog with stepper
2. File selection and parsing
3. Simple data preview
4. Basic import execution

### Phase 2: Enhanced UX
1. Conflict detection and resolution
2. Import options configuration
3. Detailed progress indication
4. Comprehensive error handling

### Phase 3: Polish & Optimization
1. Performance optimizations
2. Accessibility improvements
3. Mobile adaptations
4. Advanced features (retry, export logs)

This design follows the established patterns in the Dancer Ranking App while providing a comprehensive and user-friendly interface for event import functionality. 