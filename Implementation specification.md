# General principles
- Cross-platform application using Flutter framework (supports macOS and Android)
- save the data into SQLite using Drift library
- Material 3 design system ensures consistent experience across platforms

# Coding guidelines
- put each component class into separate file
- use Drift expressions instead of raw SQL queries

# Development workflow
- Follow 5-step workflow: Implement → Update Changelog → Update Specification → Update Next Steps → Commit
- Each improvement gets immediate version bump with complete documentation
- Single commit includes all changes: code, changelog, specification updates, and next steps cleanup
- Maintain synchronized documentation across all specification files

# App structure

## Theme System

Material 3 theme implementation with custom dance-specific color extensions.

**Files**: `lib/theme/app_theme.dart`, `color_schemes.dart`, `theme_extensions.dart`

**Colors**: 
- Primary (Blue), Secondary (Purple), Tertiary (Teal), Error (Red)
- Custom extensions: dance accent, success, warning, present/absent colors
- Automatic light/dark theme switching

**Usage**: `Theme.of(context).colorScheme.primary`, `context.danceTheme.success`

## Database model

### Tables and Relations

**Events Table**
- `id` (Primary Key, Auto Increment)
- `name` (Text, Required) - Event name
- `date` (DateTime, Required) - Event date and time
- `created_at` (DateTime, Auto) - Creation timestamp

**Dancers Table**
- `id` (Primary Key, Auto Increment)
- `name` (Text, Required) - Dancer's name
- `notes` (Text, Optional) - General notes about the dancer
- `first_met_date` (DateTime, Optional) - For dancers met before tracked events
- `created_at` (DateTime, Auto) - Creation timestamp

**Ranks Table** (Dictionary/Lookup Table)
- `id` (Primary Key, Auto Increment)
- `name` (Text, Required) - Display name (e.g., "Really want to dance!")
- `oridinal` (Integer, Required) - Sets the order from great to meh (the lower the better)

**Scores Table** (Post-Dance Rating System)
- `id` (Primary Key, Auto Increment)
- `name` (Text, Required, Unique) - Display name (e.g., "Amazing", "Great")
- `ordinal` (Integer, Required) - Rating order (1 = best, 5 = worst)
- `is_archived` (Boolean, Default: false) - Hide from new events but keep in history
- `created_at` (DateTime, Auto) - Creation timestamp
- `updated_at` (DateTime, Auto) - Last modification timestamp 

**Rankings Table**
- `id` (Primary Key, Auto Increment)
- `event_id` (Foreign Key → Events.id) - Which event
- `dancer_id` (Foreign Key → Dancers.id) - Which dancer
- `rank_id` (Foreign Key → Ranks.id) - Selected eagerness rank
- `reason` (Text, Optional) - Why this ranking
- `created_at` (DateTime, Auto) - Creation timestamp
- `last_updated` (DateTime, Auto) - When ranking was last modified
- **Unique constraint**: (event_id, dancer_id)
- **Note**: Rankings can be adjusted during events based on real-time impressions

**Attendances Table**
- `id` (Primary Key, Auto Increment)
- `event_id` (Foreign Key → Events.id) - Which event
- `dancer_id` (Foreign Key → Dancers.id) - Which dancer
- `marked_at` (DateTime, Auto) - When person was first spotted at event
- `status` (Text, Default: 'present') - Dancer status: 'present', 'served', 'left', 'absent'
- `danced_at` (DateTime, Optional) - When dance occurred
- `impression` (Text, Optional) - Post-dance impression/notes
- `score_id` (Foreign Key → Scores.id, Optional) - Post-dance rating assignment
- **Unique constraint**: (event_id, dancer_id)
- **Note**: Record existence indicates presence at event
- **Status Values**:
  - `'present'`: Dancer is at event but haven't danced yet
  - `'served'`: Have danced with this dancer
  - `'left'`: Dancer left before being asked to dance
  - `'absent'`: Not present at event (used for untracked dancers)
- **Special case**: When adding new dancer with "already danced" option, creates record with status='served'

**Tags Table** (Categorization System)
- `id` (Primary Key, Auto Increment)
- `name` (Text, Required, Unique) - Tag name (e.g., "regular", "dance-class")
- `created_at` (DateTime, Auto) - Creation timestamp

**DancerTags Table** (Many-to-Many Relationship)
- `dancer_id` (Foreign Key → Dancers.id) - Which dancer
- `tag_id` (Foreign Key → Tags.id) - Which tag
- `created_at` (DateTime, Auto) - When tag was assigned
- **Primary Key**: (dancer_id, tag_id)
- **Cascade Delete**: Tags removed when dancer deleted

### Key Relationships
- One Event has many Rankings and Attendances
- One Dancer has many Rankings and Attendances  
- One Rank has many Rankings (many-to-one)
- One Score has many Attendances (many-to-one)
- Many Dancers have many Tags (many-to-many via DancerTags)
- Rankings track pre-event planning (rank selection + reasons)
- Attendances track actual presence (record creation), dance completion, impressions, and post-dance scores
- Tags provide categorization for dancers (context, frequency, skill level)
- Scores provide post-dance rating system for tracking dance quality

### Default Rank Data
The Ranks table should be pre-populated with:
1. Ordinal 1: "Really want to dance!" (best rank)
2. Ordinal 2: "Would like to dance"
3. Ordinal 3: "Neutral / Default" 
4. Ordinal 4: "Maybe later"
5. Ordinal 5: "Not really interested" (lowest rank)

### Default Score Data
The Scores table should be pre-populated with:
1. Ordinal 1: "Amazing" (best score)
2. Ordinal 2: "Great"
3. Ordinal 3: "Good" (default score)
4. Ordinal 4: "Okay"
5. Ordinal 5: "Meh" (lowest score)

### Default Tag Data
The Tags table should be pre-populated with:
- **Frequency tags**: `regular`, `occasional`, `rare`, `new`
- **Context tags**: `dance-class`, `dance-school`, `workshop`, `social`

These tags help categorize dancers by how often they attend and where you met them.

### Dynamic Ranking Use Cases
Users can adjust rankings during events for various reasons:
- **Better presentation**: Person looks particularly good/stylish that night
- **Mood changes**: Person seems more/less engaging than usual
- **Long absence**: Haven't seen this person for a while, want to prioritize
- **Recent interaction**: Had a great conversation, want to dance now
- **Energy levels**: Person seems tired/energetic, affecting dance appeal
- **Context changes**: Different music style suits this person better
- **New person met**: Just danced with someone new, want to rank them immediately
- **Post-dance addition**: Add someone you just danced with and mark dance completion instantly

## Screens

### 1. Home Screen (`HomeScreen`)
**Purpose**: Main entry point showing all events
**Actions**:
- View list of all events (past and upcoming) **sorted by date descending (newest first)**
- Navigate to event details by tapping event
- Create new event (FAB)
- Navigate to dancers management (app bar icon)
- Navigate to ranks management (app bar icon)
- Navigate to tags management (app bar icon)
- Import events from JSON files (overflow menu)
- Export all data (overflow menu)
**Navigation**:
- → Create Event Screen (FAB)
- → Event Screen (tap event)
- → Dancers Screen (app bar action)
- → Rank Editor Screen (app bar action)
- → Tags Screen (app bar action)
- → Event Import Dialog (overflow menu action)
- → Export Data Dialog (overflow menu action)

### 2. Create Event Screen (`CreateEventScreen`)
**Purpose**: Form to create new dance events
**Actions**:
- Enter event name (required)
- Enter event description (optional)
- Select date and time
- Save event
**Navigation**:
- ← Back to Home Screen
- → Home Screen (after successful creation)

### 3. Event Screen (`EventScreen`)
**Purpose**: Main event management with swipe-based navigation
**AppBar Design**:
- **Title**: Event name with bullet separator and compact date format (e.g., "Salsa Night • Dec 15")
- **Subtitle**: 
  - For current/future events: Dynamic tab indicator showing both tabs with active one in brackets (e.g., "[Planning] • Present")
  - For past events: Static text "Event Concluded"
- **Navigation**: Pure swipe-based using PageController for current/future events. Swiping is disabled for past events.
**Conditional View**:
- **Current/Future Events**: Shows a two-tab view with "Planning" and "Present" tabs.
- **Past Events**: Shows a simplified single-page view containing only the "Present" tab to review attendance.
**Pages**:

**Planning Tab** (Only for current/future events):
- View only ranked dancers who are NOT present yet (focused on marking presence)
- Set/edit rank selection (using predefined ranks)
- Add reasons for rankings (pre-event planning)
- **Add multiple existing dancers** (FAB → Select Dancers Screen)
  - Select from unranked dancers in database
  - Bulk add with default "Neutral" ranking
  - Planning-only actions: rank editing, notes editing
- **Smart empty state**: Shows different messages based on whether all ranked dancers are present
- **Import Rankings** (when no dancers added yet): Copy rankings from another event

**Present Tab**:
- View only dancers who are currently at the event (status 'present' or 'served', excludes 'left' or 'absent')
- Quick access to ranking adjustments and dance recording
- Shows when each person was first spotted
- Easy ranking modification based on current presentation/mood
- **Add newly met dancers** (FAB → Add Dancer Dialog)
  - Create new dancer and add to database
  - Option to mark as "already danced with"
  - Immediately adds to event attendance

**Planning Tab Actions**:
- **FAB**: Opens Select Dancers Screen → add multiple existing dancers to event ranking
- **Tap dancer**: Opens Planning Actions Dialog → rank editing, notes editing, mark present
- **Import Rankings Button**: Opens ImportRankingsDialog → copy rankings from another event (only when no dancers added yet)

**Present Tab Actions**:
- **FAB**: Shows modal menu with dual options
  - **"Add New Dancer"** → Opens Add Dancer Dialog to create new dancer and add to event
    - Option to mark as "already danced with" + impression
  - **"Add Existing Dancer"** → Opens Add Existing Dancer Screen to mark unranked and absent dancers as present
    - Shows only unranked AND absent dancers (excludes ranked dancers and already present dancers)
    - One-tap selection with immediate "Mark Present" action
    - Search functionality by name or notes
    - Smart filtering prevents suggesting dancers who are already present
- **Tap dancer**: Opens Full Actions Dialog with:
  - Set/edit dancer ranking in real-time (→ Ranking Dialog)
  - Mark present / Mark absent (attendance management)
  - **Mark Present & Record Dance** (combo action for absent dancers) → marks present + opens Dance Recording Dialog
  - **Record dance / Edit impression** (context-aware) → opens Dance Recording Dialog with appropriate action text
  - Edit dancer notes

**Navigation**:
- ← Back to Home Screen
- → Dancers Screen (app bar action)
- **Planning Tab FAB** → Select Dancers Screen (multi-select existing dancers)
- **Planning Tab Import Rankings** → ImportRankingsDialog (when no dancers added yet)
- **Present Tab FAB** → Modal Menu → Add Dancer Dialog OR Add Existing Dancer Screen
- **Planning Tab Actions** → Ranking Dialog, Notes editing only
- **Present Tab Actions** → Full Actions Dialog → Ranking, Dance Recording, Attendance


### 4. Select Dancers Screen (`SelectDancersScreen`)
**Purpose**: Select multiple existing dancers to add to event ranking (for planning phase)
**Actions**:
- View list of unranked dancers only (dancers not yet added to this event)
- Search dancers by name or notes
- Multi-select dancers using checkboxes
- Add selected dancers to event with default rank (Neutral)
**Navigation**:
- ← Back to Event Screen

### 4b. Add Existing Dancer Screen (`AddExistingDancerScreen`)
**Purpose**: Mark unranked and absent dancers as present when they appear at events
**Actions**:
- View list of unranked AND absent dancers only (excludes ranked dancers and already present dancers)
- Search dancers by name or notes
- One-tap "Mark Present" action for each dancer
- **Persistent Screen**: Screen stays open after marking dancers to enable bulk operations
- **Efficient Feedback**: Brief 1-second snackbar confirmations for rapid marking
- Info banner explaining scope and guiding users about present dancers
- Shows dancer context: notes for identification
- **Smart filtering**: Automatically excludes dancers who are already present to prevent duplicates
**Navigation**:
- ← Back to Event Screen

### 5. Dancers Screen (`DancersScreen`)
**Purpose**: Manage all dancers in the database with comprehensive tag display
**Actions**:
- View list of all dancers with their tags
- Search dancers by name or notes
- Add new dancer (FAB)
- Edit existing dancer (tap → context menu)
- Delete dancer (tap → context menu, with confirmation)
**UI Design**:
- **Enhanced Card Layout**: Name with notes and tags displayed below
- **Tag Display**: Colored chip badges under dancer name showing assigned tags
- **Clean Organization**: Tags appear only on main Dancers screen, not on event screens
- **Tap for Context Actions**: Single tap on any dancer card opens modal bottom sheet with Edit and Delete options
- **Consistent Interaction**: Follows same pattern as Tags, Ranks, and Events screens
- **Clean Design**: No visual clutter with hidden context menus
- **Tag Chips Styling**: Small rounded containers with primary container color
**Navigation**:
- ← Back to previous screen
- → Add/Edit Dancer Dialog (modal) with tag selection

### 6. Tags Screen (`TagsScreen`)
**Purpose**: Manage all tags in the system for dancer categorization
**Actions**:
- View list of all tags (predefined and custom)
- Add new custom tags via dialog
- Simple tag management interface
**UI Design**:
- **Simple List Layout**: Clean ListTile showing just tag names
- **Minimalist Interface**: Focus on tag names without clutter
- **Icon Indicators**: Label outline icon for each tag
- **Add Tag FAB**: Floating action button to create new tags
**Add Tag Dialog**:
- **Simple Text Input**: Enter tag name with validation
- **Immediate Feedback**: Success/error messages via SnackBar
- **Duplicate Prevention**: TagService handles duplicate tag creation
- **Auto-focus**: Text field automatically focused for quick entry
**Navigation**:
- ← Back to Home Screen
- → Add Tag Dialog (FAB)

  ### 7. Dialogs and Modals

**Ranking Dialog (`RankingDialog`)**:
- Interactive rank selection from predefined options
- Display rank names in ordinal order
- Optional reason text field for current situation context
- Shows when ranking was last updated
- Save/cancel actions (updates `last_updated` timestamp)

**Score Dialog (`ScoreDialog`)**:
- Simple score assignment from predefined score options for any present attendant
- Display score names with ordinal ratings (1=Amazing, 5=Meh) as radio buttons
- Auto-selects current score if already assigned, otherwise defaults to "Good"
- Save/cancel actions only - simplified interface without removal options
- **Context**: Accessible for any present attendant regardless of dance completion status
- **Integration**: Launched from Dancer Actions Dialog for any attendant with flexible rating criteria

**Dancer Actions Dialog (`DancerActionsDialog`)**:
- Context-aware actions based on dancer state and tab mode
- **Auto-Closing Behavior**: All actions close the dialog after completion for focused workflows
- **Visual Feedback**: Snackbar notifications provide immediate feedback after dialog closes
- **Tab-Specific Actions**: Different action sets available based on Planning vs Present mode
- **Efficient Navigation**: Quick action → feedback → return to main view for next task
- **Action Types**: Set/Edit Ranking, Mark/Remove Present, Record Dance, Edit Notes, Remove from Event, Mark as Left, Combo Actions
- **Event Management**: "Remove from event" action only appears for ranked dancers in Planning mode, allowing cleanup of event rankings
- **Left Tracking**: "Mark as left" action only appears for present dancers who haven't been danced with yet, tracking early departures

**Add/Edit Dancer Dialog**:
- Name input (required)
- Notes input (optional)
- **Tag Selection**: Interactive pill-based interface for selecting predefined tags
  - Shows all available tags as toggleable filter chips
  - Selected tags highlighted with primary container color
  - Supports multiple tag selection per dancer
  - Tags load automatically for existing dancers
- Save/cancel actions
- **Accessible from Event Screen**: Create new dancers during events without navigation
  - **Special Event Context Features**:
    - "Already danced with this person" checkbox
    - Optional impression field (if already danced checked)
    - Automatically adds to current event and marks dance completion
- **Accessible from Dancers Screen**: Full dancer management with tag selection

**Dance Recording Dialog**:
- Confirmation of dance partner
- Optional impression text field
- Updates attendance record with dance completion
- Prevents duplicate dance records
- Save/cancel actions

**Event Import Dialog (`ImportEventsDialog`)**:
- **Full-screen 3-step stepper interface** for importing historical event data from JSON files
- **Step 1: File Selection**
  - Drag-and-drop file picker with JSON validation
  - 5MB file size limit with clear error messages
  - Format requirements display with JSON structure example
  - File validation with immediate feedback
- **Step 2: Data Preview**
  - Rich preview with statistics cards showing events, attendances, unique dancers, and **new dancers to be created**
  - Expandable event cards with comprehensive details
  - Color-coded attendance status icons (present/served/left) for visual clarity
  - Automatic behavior information about duplicate skipping and missing dancer creation
- **Step 3: Results**
  - Comprehensive import results with detailed statistics breakdown
  - Skipped events display with reasons (duplicates)
  - Error reporting with specific failure details
  - Action buttons for closing dialog or starting new import
- **Integration**: Accessible from Home screen overflow menu as a full-screen dialog
- **Automatic Processing**: Phase 1 implementation with full automation - skips duplicates and creates missing dancers
- **Progress Tracking**: Step progression with enabled/disabled state management
- **Error Handling**: Comprehensive validation and user-friendly error messages
- **Pre-import Analysis**: Service performs a dry run to calculate statistics (like new dancers) before the import begins

### Navigation Flow
```
Home Screen
├── Create Event Screen
├── Event Import Dialog (overflow menu) - 3-step wizard for bulk event import
│   ├── Step 1: File Selection (JSON file picker with validation)
│   ├── Step 2: Data Preview (statistics and expandable event cards)
│   └── Step 3: Results (import summary and action buttons)
├── Event Screen (Swipe-based Three-Tab Pages)
│   ├── Planning Page (Page 0)
│   │   ├── FAB → Select Dancers Screen (page-specific action)
│   │   ├── Import Rankings Button → ImportRankingsDialog (when no dancers added yet)
│   │   ├── Tap dancer → Planning Actions Dialog (rank/notes editing only)
│   │   └── Blue location icon → Instant "Mark Present" (context action)
│   ├── Present Page (Page 1) - Enhanced with score display and first met indicators
│   │   ├── FAB → Modal Menu
│   │   │   ├── → Add Dancer Dialog (create new dancer)
│   │   │   └── → Add Existing Dancer Screen (mark existing as present)
│   │   ├── Tap dancer → Full Actions Dialog (context-aware with score management)
│   │   │   ├── → Ranking Dialog
│   │   │   ├── → Dance Recording Dialog
│   │   │   ├── → Score Dialog (for any present attendant regardless of dance status)
│   │   │   └── → Attendance management
│   │   ├── **Score Pills**: Score names displayed as colored pills for any attendant with assigned scores
│   │   └── **First Met Indicators**: ⭐ emoji for dancers met for the first time at this event (any attendance status)
│   ├── Summary Page (Page 2) - Post-dance analysis and score management tab
│   │   ├── **Dance Summary Card**: Statistics showing total dances, scored/unscored counts, first meetings
│   │   ├── **Score Groups**: Dancers grouped by score (Amazing, Great, Good, Okay, Meh, No score assigned)
│   │   ├── **Count Badges**: Each score group shows dancer count in primary container styling
│   │   ├── **Post-Party Editing**: Primary use for reviewing and editing scores/impressions after events
│   │   └── Tap dancer → Full Actions Dialog (same as Present tab for score management)
│   └── Swipe Left/Right → Switch between Planning, Present, and Summary pages
├── Dancers Screen
│   └── Add/Edit Dancer Dialog (modal) - Full dancer management with tag selection
└── Tags Screen
    └── Add Tag Dialog (FAB) - Create new custom tags
```

### Event Workflow with Dynamic Rankings

**Phase 1: Pre-event Planning**
1. **Planning Tab** → **FAB** → **Select Dancers Screen**
2. **Multi-select existing dancers** from database to add to event ranking
3. **All selected dancers get default "Neutral" rank** initially
4. **Adjust individual rankings** by tapping dancers → Ranking Dialog
5. **Add reasons for rankings** based on general preferences

**Phase 2: At the Event**
1. **Spot ranked dancers** → **Planning Tab** → click blue location icon for instant "Mark Present"
   - No dialog needed - immediate action with visual feedback
   - Dancer disappears from Planning tab once marked present (focuses on remaining absent dancers)
   - Stay on Planning tab for efficient batch processing
2. **Adjust rankings** → tap dancers for Planning Actions Dialog (rank/notes only)
3. **Switch to Present Tab** for live event management when needed
4. **Meet new people** → **Present Tab FAB** → **Add Dancer Dialog**
   - Create new dancer in database
   - Option to mark as "already danced with" + add impression
   - Automatically adds to event attendance
5. **Dance and record** → Present Tab → choose from present dancers, record completion

### Key Features
- **Pre-event planning**: Add dancers, set initial rank preferences with reasons
- **Dynamic ranking adjustment**: Change rankings during events based on real-time impressions
- **Efficient presence tracking**: One-click "Mark Present" with instant feedback and automatic list refresh
- **Context-aware actions**: Different dialog contents based on Planning vs Present mode
- **Streamlined workflow**: Stay on Planning tab for batch presence marking, focuses only on absent dancers
- **Dual FAB behavior**: Tab-specific actions (Select Dancers vs Add Dancer)
- **Dance prioritization**: Present tab shows dancers sorted by rank ordinal for decision making
- **Integrated dance tracking**: Record completed dances and impressions in attendance records
- **Streamlined combo actions**: One-click "Mark Present & Record Dance" for absent dancers
- **Efficient bulk operations**: Persistent "Add Existing Dancer" screen for marking multiple dancers
- **Seamless dancer management**: Add new people during events without leaving screen
- **Post-dance integration**: Mark new dancers as already danced with immediate impression capture
- **Rich context**: Notes, reasons, and impressions for informed decisions
- **Ranking history**: Track when rankings were last updated for context
- **Streamlined data model**: Record existence indicates presence, no boolean flags needed
- **Import rankings from other events**: Copy rankings between similar events to leverage existing preferences
  - **Smart source filtering**: Only shows events that have existing rankings as import options
  - **Conflict resolution**: Choose to skip or overwrite existing rankings for dancers already ranked in target event
  - **Batch import processing**: Efficiently copy multiple rankings in a single operation
  - **Context preservation**: Imported rankings marked with source event context while preserving original reasons
  - **Detailed feedback**: Shows summary of imported, skipped, and overwritten rankings for transparency
  - **Contextual placement**: Available in Planning tab when setting up event rankings (when no dancers added yet)
- **Compact dancer cards**: Display all information inline for maximum vertical space efficiency
  - **Single-line layout**: Name followed by bullet-separated information: "Name • Notes • Ranking • Dance Status"
  - **Personal notes**: General dancer notes displayed inline (hidden for danced dancers in Present tab)
  - **Ranking reasons**: Italic event-specific reasoning in blue (hidden for danced dancers in Present tab)
  - **Dance status with impressions**: "Danced!" text followed by italicized impression text when available
  - **Context-aware display**: Pre-event information (notes, ranking reasons) hidden after dancing in Present tab to focus on post-dance impressions
  - **Responsive design**: Uses RichText with TextSpan elements for flexible text styling within single line

### Tags on Persons Feature
**Purpose**: Categorize dancers by context and frequency to enable better organization and future filtering

**Tag System**:
- **8 predefined tags**: `regular`, `occasional`, `rare`, `new`, `dance-class`, `dance-school`, `workshop`, `social`
- **Custom tags**: Users can create additional tags as needed
- **Frequency categories**: regular, occasional, rare, new (attendance patterns)  
- **Context categories**: dance-class, dance-school, workshop, social (where you met them)
- **Duplicate prevention**: TagService prevents duplicate tag creation

**Tag Selection UI**:
- **Pill-based interface**: FilterChip widgets that can be toggled on/off
- **Visual feedback**: Selected tags show primary container background color
- **Multi-selection**: Dancers can have multiple tags (many-to-many relationship)
- **Integrated into Add/Edit Dancer Dialog**: Tags appear below notes field

**Tag Display**:
- **Dancers Screen only**: Tags displayed as colored chips under dancer names
- **Event screens clean**: Tags not shown on event screens to avoid clutter
- **Chip styling**: Small rounded containers with subtle primary container coloring

**Tag Management Screen**:
- **Tags Screen Navigation**: Accessible from Home screen app bar with label icon button
- **Complete CRUD Operations**: Full Create, Read, Update, Delete functionality for tags
- **Context Menu Actions**: Tap any tag to access Edit and Delete options via modal bottom sheet
- **Tag Creation**: FloatingActionButton with dialog to create custom tags
- **Tag Editing**: Simple text field with validation and duplicate checking
- **Tag Deletion**: Confirmation dialog with warning about permanent action and dancer impact
- **Real-time Updates**: StreamBuilder automatically refreshes when tags are modified
- **User Feedback**: Success/error notifications via SnackBar for all operations
- **Database Integrity**: Cascade delete automatically removes tag from all associated dancers
- **Responsive layout**: Tags wrap to multiple lines when needed

**Data Architecture**:
- **Database migration**: Seamless upgrade from version 3 to 4 with automatic tag insertion
- **Many-to-many relationship**: DancerTags table links dancers to tags
- **Cascade deletion**: Tags automatically removed when dancers are deleted
- **Backward compatibility**: Existing data remains intact during migration

**Implementation Components**:
- **TagService**: Full CRUD operations for tag management
- **TagSelectionWidget**: Reusable component for tag selection interface
- **DancerCardWithTags**: Enhanced dancer display with tag chips
- **DancerWithTags**: Model combining dancer data with associated tags

### Code Architecture
- **Reactive Data Layer**: Drift database streams with automatic UI updates via StreamBuilder
- **Modular Structure**: Components split into focused, single-responsibility modules
- **Tab Actions Interface**: Clean abstraction for tab-specific FAB behaviors
- **Reusable Components**: Shared widgets across tabs with different behavioral modes
- **Separation of Concerns**: UI components separated from business logic and data access
- **Automatic Refresh**: No manual callbacks - UI updates automatically when any data changes

# Implementation Specification

## Overview
This document serves as the technical specification for implementing the Dancer Ranking App features. It describes the database schema, services, UI components, and workflows needed to support the core functionality.

## Debugging and Development Features

### Action Logging System
The app includes a comprehensive structured action logging system for debugging and development:

#### Logging Categories
- **`[ACTION_LOG]`**: User interactions, service calls, state changes, navigation events
- **`[LIST_LOG]`**: UI list contents with item IDs and key properties for data visibility  
- **`[STATE_LOG]`**: Before/after states, data transitions, filtering results
- **`[ERROR_LOG]`**: Errors with full operational context and parameters
- **`[Database]`**: CRUD operations with affected records and success status

#### Coverage Areas
- **Screen Lifecycle**: Initialization, disposal, tab changes with context
- **User Interactions**: All taps, form submissions, dialog actions with parameters
- **Service Operations**: All CRUD methods with input/output data
- **Navigation**: Route changes, screen parameters, navigation method tracking
- **Data Flow**: Database operations, filtering, list rendering with item details
- **Error Handling**: Complete error context for debugging failures

#### Log Format
```
[CATEGORY] TIMESTAMP | Component | Action | key1=value1, key2=value2
```

Example logs:
```
[ACTION_LOG] 2025-01-11T12:34:56.789 | UI_EventCard | event_tapped | eventId=2, eventName="DaMeTimba"
[LIST_LOG] 2025-01-11T12:34:57.123 | UI_PresentTab | present_dancers | count=3 | items=[id=1, name="Alice", status="present"]
[Database] 2025-01-11T12:34:57.456 | UPDATE attendances | id=22, oldStatus="present", newStatus="served", success=true
```

#### Development Benefits
- **Bug Reproduction**: Complete action trails for recreating issues
- **Workflow Analysis**: Step-by-step user interaction tracking
- **Performance Monitoring**: Service call timing and database operation efficiency
- **Data Visibility**: Real-time view of list contents and filtering results
- **Error Debugging**: Full context for operation failures

## Services

### ScoreService (`lib/services/score_service.dart`)
**Purpose**: Complete CRUD operations for score management in post-dance rating system
**Key Methods**:
- `getAllScores()` - Get all scores ordered by ordinal (best first)
- `getActiveScores()` - Get non-archived scores for dropdowns
- `getDefaultScore()` - Get default "Good" score (ordinal 3)
- `getScoreByName(name)` - Find score by name (for imports)
- `createScore(name, ordinal, isArchived)` - Create new score
- `updateScore(id, name, ordinal, isArchived)` - Update existing score
- `archiveScore(id)` / `unarchiveScore(id)` - Archive management
- `deleteScore(id, replacementScoreId)` - Safe deletion with reassignment

**Features**:
- **Default Scores**: Pre-populated with "Amazing", "Great", "Good", "Okay", "Meh"
- **Archive Support**: Hide scores from new events while preserving history
- **Safe Deletion**: Requires replacement score for existing assignments
- **Transaction Safety**: Atomic operations with rollback on errors
- **Action Logging**: Comprehensive logging for debugging and audit
- **Import Support**: Name-based lookup for data import operations

### Enhanced AttendanceService
**New Score Management Methods**:
- `assignScore(eventId, dancerId, scoreId)` - Assign post-dance score
- `removeScore(eventId, dancerId)` - Remove score assignment
- `getAttendanceScore(eventId, dancerId)` - Get current score
- `updateFirstMet(eventId, dancerId, isFirstMet)` - Update first met flag

**Features**:
- **Score Integration**: Seamless score assignment to attendance records
- **First Met Tracking**: Boolean flag for tracking first meetings
- **Error Handling**: Graceful handling of missing attendance records
- **Consistency**: Follows established service patterns with action logging

### Enhanced DancerService
**New First Met Management**:
- `updateFirstMetDate(id, firstMetDate)` - Set explicit pre-tracking meeting date

**Features**:
- **Pre-tracking Dates**: Support for dancers met before event tracking began
- **Null Handling**: Optional dates for normal tracked dancers
- **Backward Compatibility**: Existing functionality unchanged

### Dancer Import Services

#### DancerImportService (`lib/services/dancer_import_service.dart`)
**Purpose**: Main orchestrator for dancer import operations
**Key Methods**:
- `importDancersFromJson(jsonContent, options)` - Complete import workflow with atomic transactions
- `validateImportFile(jsonContent)` - Validation-only mode for preview
- `getImportPreview(jsonContent)` - Quick preview information without full parsing

**Features**:
- **Atomic Transactions**: All imports wrapped in database transactions with rollback on errors
- **Conflict Resolution**: Three strategies - skip duplicates, update existing, import with suffix
- **Automatic Tag Creation**: Creates missing tags when enabled in options
- **Comprehensive Logging**: Action logging throughout all import operations
- **Error Handling**: Graceful error handling with user-friendly messages
- **Performance Optimized**: Batch operations and efficient database queries

#### DancerImportParser (`lib/services/dancer_import_parser.dart`)
**Purpose**: JSON parsing and data extraction service
**Key Methods**:
- `parseJsonContent(jsonContent)` - Main JSON parsing with validation
- `validateJsonStructure(jsonContent)` - Quick structure validation
- `getImportPreview(jsonContent)` - Preview without full parsing

**Features**:
- **JSON Format Support**: Handles dancers array with optional metadata
- **Size Limits**: Maximum 1000 dancers per import file
- **Duplicate Detection**: Identifies duplicate names within import file
- **Field Validation**: Validates all dancer fields (name, tags, notes) according to database constraints
- **Error Aggregation**: Collects all parsing errors with detailed messages

#### DancerImportValidator (`lib/services/dancer_import_validator.dart`)
**Purpose**: Validation and conflict detection service
**Key Methods**:
- `validateImport(dancers, options)` - Main validation orchestrator
- `isDancerNameTaken(name)` - Check existing dancer names
- `generateUniqueName(baseName)` - Create unique names with suffixes
- `canProceedWithImport(conflicts, options)` - Determine if import is safe

**Features**:
- **Conflict Detection**: Identifies duplicate names and validation errors
- **Database Validation**: Checks against existing dancers and tags
- **Unique Name Generation**: Creates unique names with numbered suffixes
- **Missing Tag Detection**: Identifies tags that don't exist when auto-creation disabled
- **Import Safety**: Validates all constraints before allowing import to proceed

#### Import Data Models (`lib/models/import_models.dart`)
**Purpose**: Complete data model set for import operations

**Key Classes**:
- `ImportableDancer` - Represents a dancer to be imported with name, tags, and notes
- `DancerImportResult` - Parse results with validation status and error messages
- `DancerImportSummary` - Import operation summary with counts and detailed results
- `DancerImportOptions` - Configuration options for conflict resolution and tag creation
- `DancerImportConflict` - Conflict detection results with suggestions for resolution

**JSON Format Specification**:
```json
{
  "dancers": [
    {
      "name": "Dancer Name",
      "tags": ["tag1", "tag2"],
      "notes": "Optional notes"
    }
  ],
  "metadata": {
    "version": "1.0",
    "created_at": "2024-01-01T12:00:00Z",
    "total_count": 100,
    "source": "Manual export"
  }
}
```

**Validation Rules**:
- Names: Required, 1-100 characters, unique within import
- Tags: Optional, 1-50 characters each, fully case-sensitive with trimming only
- Notes: Optional, up to 500 characters
- File size: Maximum 1000 dancers per import

### 5. Rank Editor Screen (`RankEditorScreen`)
**Purpose**: Comprehensive rank management system with clean, modern interface
**Actions**:
- View all ranks ordered by priority (visual position indicates priority)
- Drag-to-reorder ranks to change priority
- Add new rank (FloatingActionButton)
- Edit rank name (tap rank → menu → edit)
- Archive rank (tap rank → menu → archive)
- Delete rank with reassignment (tap rank → menu → delete)
- Visual feedback for all operations
**UI Design**:
- **Minimalist Cards**: Clean rank name display without visual clutter
- **Single Tap Interaction**: Context menu via tap gesture showing modal bottom sheet with all actions
- **Visual Priority**: Position in list clearly indicates priority order (no numbers needed)
- **Unified Actions**: Single tap opens menu with Edit, Archive, and Delete options
- **Simple Pattern**: Clean single-action interface eliminates interaction confusion
- **Archived Status**: Shows "Archived" subtitle only when relevant
**Features**:
- **Smart Filtering**: Only active (non-archived) ranks shown in ranking dialogs
- **Safe Deletion**: Requires replacement rank selection for existing rankings
- **Real-time Updates**: Immediate UI refresh after operations
- **Error Handling**: Comprehensive validation and user feedback
- **Database Migration**: Proper schema versioning for backward compatibility
**Navigation**:
- ← Back to Home Screen
- No sub-navigation (self-contained management)

### 11. Event Import Dialog (`ImportEventsDialog`)
**Purpose**: Full-screen dialog for importing events from a JSON file.
**Workflow**:
1.  **File Selection**: User selects a JSON file.
2.  **Parsing & Validation**: The app parses the file and performs a "dry run" to validate the data.
    - It checks for duplicate events and identifies new dancers that will be created.
3.  **Data Preview**: The user is shown a preview of the events to be imported.
    - Each event in the list displays its name, date, and number of attendees. The new dancer count is appended to the attendance info (e.g., "15 attendances (3 new)").
    - **Duplicate Indication**: Events that already exist in the database are clearly marked and shown as "Skipped".
    - Users can expand each event to see the list of attendees.
    - **New Dancer Highlighting**: Within the attendee list, dancers who do not yet exist in the database are marked with a " (new)" text label next to their name.
4.  **Confirmation**: User confirms the import.
5.  **Import**: The app imports the valid events and attendees.
    - Duplicate events are automatically skipped.
    - New dancers are automatically created.
**Navigation**:
- Opened from Home Screen's overflow menu.
- Closes upon completion or cancellation.

## Navigation Flow

```mermaid
graph TD
// ... existing code ...

```

## Scoring System Design

### Score Assignment Philosophy
The scoring system is designed to be **completely independent** from dance completion status, providing maximum flexibility for rating attendants based on various criteria:

**Scoring Availability**:
- Any present attendant can be assigned a score
- Scores can be assigned before, during, or after dancing
- Multiple rating criteria supported (dance skill, attractiveness, conversation, overall impression)

**Score Display**:
- Score pills appear on the right side of dancer rows for any attendant with assigned scores
- Visual distinction independent of "Danced!" status or impression text
- Consistent styling across Planning, Present, and Summary tabs

**Use Cases**:
- **Pre-dance impressions**: Rate based on initial conversations or visual assessment
- **Post-dance evaluation**: Traditional dance skill/chemistry rating
- **Overall event rating**: Comprehensive assessment including non-dance interactions
- **Flexible criteria**: Any personal rating system (attractiveness, personality, dance ability, etc.)

This design allows users to maintain their rating system flexibly without being constrained by whether they've actually danced with someone.