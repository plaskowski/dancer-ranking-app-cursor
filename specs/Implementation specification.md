## 2. Dancers Screen (`lib/screens/dancers/dancers_screen.dart`)

**Purpose**: View and manage all dancers in the system

**Key Features**:
- List all dancers with their tags and last met information
- Search dancers by name or notes
- Filter by tags
- Add new dancers
- Edit existing dancers
- Delete dancers
- Merge duplicate dancers
- Archive/reactivate dancers

**Actions**:
- **Add Dancer**: Opens AddDancerDialog to create new dancer
- **Edit Dancer**: Opens AddDancerDialog in edit mode
- **Delete Dancer**: Shows confirmation dialog, then deletes dancer and all related records
- **Merge Dancer**: Opens SelectMergeTargetScreen to merge with another dancer
- **Search**: Filters dancers by name or notes (word-start matching)
- **Tag Filter**: Filters dancers by selected tag
- **Archive Dancer**: Shows confirmation dialog, then archives dancer (preserves all data)
- **Reactivate Dancer**: Immediately reactivates archived dancer
- **View History**: Opens DancerHistoryScreen to view all dance history

**Navigation Flow**:
- Home Screen → Dancers (bottom navigation)
- Dancers → AddDancerDialog (FAB)
- Dancers → SelectMergeTargetScreen (merge action)

**Last Met Information**:
- Shows "Last met: [Event Name] • [Date]" for dancers who have attended events
- Automatically updates when new attendances are recorded
- Only displays for dancers with actual attendance records (excludes absent status)
- Uses reactive stream for real-time updates

## Key Features

### Dancer Management
- **Dancer Profiles**: Create, edit, and manage dancer information with notes and tags
- **Tag System**: Categorize dancers with custom tags for easy filtering and organization
- **Last Met Tracking**: Automatically track and display when you last met each dancer at events
- **Dancer Merging**: Merge duplicate dancer profiles while preserving all historical data
- **Dancer Archival**: Archive inactive dancers while preserving all historical records
- **Search & Filter**: Find dancers by name, notes, or tags with real-time filtering

### Event Management 

**Visual Design**:
- **Archived Dancers**: Show gray "archived" pill in tags section with consistent styling
- **Last Met Info**: Displays "Last met: [Event Name] • [Date]" when available
- **Tag Display**: Shows dancer tags as colored pills below dancer info
- **Error Handling**: Consistent error display with proper logging and user-friendly messages 

### Technical Architecture: Theme System

- For Flutter 3.32.5 and later, use `CardThemeData` and `DialogThemeData` for `ThemeData.cardTheme` and `ThemeData.dialogTheme` respectively. Do not use `CardTheme` or `DialogTheme` as these are not accepted types for ThemeData properties.
- This ensures compatibility with the latest Flutter SDK and prevents build errors.

### Build & Release

- APK build process was verified and fixed after resolving theme constructor errors. The app now builds successfully for release on the main branch. 

## CLI Navigation

The app supports command-line navigation for automated testing and direct access to specific screens and actions.

### Navigation Format
- **Path-based**: `/event/{eventId}/{tab}/{action}`
- **Index-based**: Event index with optional tab and action parameters

### Supported Actions
- `add-existing-dancer`: Opens the add existing dancer dialog on the present tab

### Audit Logging
All CLI navigation events are logged using the ActionLogger system for debugging and tracking:
- Navigation path resolution
- Event loading and validation
- Tab mapping and action execution
- Error handling and fallback behavior

### Implementation Files
- `lib/cli_navigation.dart`: Main CLI navigation logic
- `lib/screens/event/event_screen.dart`: Event screen with CLI action handling
- `lib/screens/event/tabs/present_tab.dart`: Present tab with CLI action execution
- `lib/screens/home/services/home_navigation_service.dart`: Navigation service with logging 