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
- Spans the full width of the dancer card row for better readability
- Automatically updates when new attendances are recorded
- Only displays for dancers with actual attendance records (excludes absent status)
- Uses reactive stream for real-time updates

**Dancer Notes**:
- Displayed on a separate line below the last met information
- Only shown when notes are not empty
- Uses consistent styling with last met info for visual hierarchy

**Real-Time Filtering**:
- Uses streaming architecture for immediate updates when data changes
- Dancer list updates automatically when dancers are added, edited, or deleted
- Search and tag filtering work with real-time data streams
- No manual refresh required - changes appear immediately

## 3. Real-Time Filtering Architecture

**Purpose**: Provide immediate updates across all dancer filtering components

**Key Features**:
- **Streaming Data**: All dancer filtering uses Stream<List<DancerWithTags>> for real-time updates
- **Immediate Updates**: Dancer lists update automatically when data changes
- **Consistent Architecture**: All filtering components use same streaming pattern
- **Performance Optimized**: Reduces unnecessary rebuilds with streaming approach

**Implementation**:
- **DancersScreen**: Uses `watchDancersWithTagsAndLastMet()` stream for real-time updates
- **BaseDancerSelectionScreen**: Supports streaming data sources for live filtering
- **DancerListFilterWidget**: Uses StreamBuilder for immediate UI updates
- **Filtering Logic**: Search and tag filtering applied to streaming data

**Benefits**:
- **Immediate Feedback**: Changes appear instantly without manual refresh
- **Better UX**: Users see updates as they happen
- **Consistent Behavior**: All dancer lists behave the same way
- **Reduced Complexity**: No need for manual refresh mechanisms

## 4. UI Consistency & Dialog Patterns

**Purpose**: Ensure consistent user experience across all dialog components

**Key Features**:
- **Consistent Dialog Structure**: All dialogs follow same layout patterns
- **Standardized Presentation**: Modal bottom sheets with consistent styling
- **Unified Action Buttons**: Cancel/Save button layout with loading states
- **RadioListTile Selection**: Consistent selection UX across all choice dialogs
- **Proper Visual Hierarchy**: Clear sections, spacing, and typography

**Dialog Components**:
- **RankingDialog**: Template for all selection dialogs with proper structure
- **ScoreDialog**: Updated to match RankingDialog patterns and styling
- **Static Show Methods**: Consistent `Dialog.show()` pattern for presentation
- **Loading States**: Proper loading indicators during async operations
- **Error Handling**: Consistent error display and user feedback

**Implementation**:
- **Header Section**: Title with close button in consistent layout
- **Description Text**: Clear explanation of dialog purpose
- **Options Section**: RadioListTile for selection with proper spacing
- **Action Buttons**: Cancel and primary action with loading states
- **Modal Presentation**: `showModalBottomSheet` with `isScrollControlled: true`

**Benefits**:
- **Consistent UX**: All dialogs feel familiar and predictable
- **Better Usability**: Clear visual hierarchy and intuitive interactions
- **Maintainable Code**: Shared patterns reduce development complexity
- **Professional Appearance**: Polished, consistent interface design

## 5. SimpleSelectionDialog Component

**Purpose**: Provide a reusable component for simple selection dialogs

**Key Features**:
- **Generic Design**: Supports any type of items with customizable title and selection logic
- **One-Tap Selection**: Immediate selection with visual feedback (check_circle vs circle_outlined)
- **Built-in Logging**: Automatic action logging with configurable prefix
- **Loading States**: Built-in loading indicator support
- **Consistent UI**: Standardized header, list, and cancel button layout
- **Error Handling**: Proper error handling and user feedback

**Implementation**:
- **Generic Type**: SimpleSelectionDialog<T> for type-safe usage
- **Configurable Callbacks**: itemTitle, isSelected, onItemSelected, onCancel
- **Action Logging**: Integrated logging with configurable prefixes for different dialogs
- **Visual Feedback**: Clear visual indicators for selected vs unselected items
- **Responsive Design**: Handles overflow with scrollable content and height constraints

**Usage Examples**:
- **ScoreDialog**: Uses SimpleSelectionDialog<Score> for score assignment
- **Merge Dialogs**: Uses SimpleSelectionDialog for target selection in merge operations
- **Custom Dialogs**: Can be used for any simple selection scenario

**Benefits**:
- **Code Reduction**: Eliminates duplicate UI code by 70%
- **Consistent Behavior**: Maintains same functionality with cleaner implementation
- **Better Maintainability**: Easier to modify and extend
- **Type Safety**: Generic design ensures compile-time type checking

## Key Features

### Dancer Management
- **Dancer Profiles**: Create, edit, and manage dancer information with notes and tags
- **Tag System**: Categorize dancers with custom tags for easy filtering and organization
- **Last Met Tracking**: Automatically track and display when you last met each dancer at events
- **Dancer Merging**: Merge duplicate dancer profiles while preserving all historical data
  - **Safe Ranking Merges**: Handles duplicate rankings by preserving target dancer's rankings
  - **Attendance Consolidation**: Merges attendance records while avoiding duplicates
  - **Tag Preservation**: Combines tags from both dancers without duplicates
  - **Data Integrity**: Maintains unique constraints during merge operations
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