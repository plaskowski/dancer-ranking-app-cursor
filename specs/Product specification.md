# Problem statement
I am a social dancer. I attend many social dancing parties where I can with a lot of partners.
I know most of them, some I meet there the first time.
My problem is the overwhelming decision making who should I ask for a dance.
This should be decided based on my overall attitude toward given person but can be influenced by current situation,
e.g. I may have not seen given person for a long time or they are looking really good that day.
The other problem is that there are so many people at the party that I quickly forget who is there 
and that I wanted to ask that person for a dance later that day.

# Proposed solution
A mobile app called "dancer ranking" that lets me plan an upcoming dance event, 
by listing people I expect might attend the event and state how eager I am to dance with them.
Then, during the party it lets me quickly note down who is present and see what is my planned attitute towards them.
There can be multiple reasons why I either want or don't want to dance with them.
Then, after the dance I want to mark that I have danced with them.
Sometimes I meet new people, so I want to add a new person.
I may want to add a comment why I am eager to dance with given person.
Later I may want to add a comment on my impression on given person that night.

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
1. Ordinal 1: "Really want to dance!" (highest priority)
2. Ordinal 2: "Would like to dance"
3. Ordinal 3: "Maybe later"
4. Ordinal 4: "Not interested" (lowest priority)

### Default Score Data
The Scores table should be pre-populated with:
1. Ordinal 1: "Good" (best score)
2. Ordinal 2: "Okay"
3. Ordinal 3: "Poor" (lowest score)

### Default Tag Data
The Tags table should be pre-populated with contextual venue/event tags:
- **Monday Class**: For dancers met in weekly dance classes
- **Cuban DC Festival**: For dancers met at specific dance festivals
- **Friday Social**: For dancers met at regular social dance events

These tags help categorize dancers by where you know them from, enabling venue-based filtering during event planning.

### Sample Data for Testing
For easier testing and demonstration, the database initialization includes comprehensive sample data:

**Sample Events (4 events with varied timing)**:
- "Salsa Night at Cuban Bar" (1 week ago)
- "Weekend Social Dance" (yesterday)
- "Monthly Bachata Workshop" (next week)
- "Summer Salsa Festival" (next month)

**Sample Dancers (7 dancers with diverse tag combinations)**:
- **Alice Rodriguez**: Monday Class + Friday Social (multi-venue dancer)
- **Bob Martinez**: Cuban DC Festival only (festival-focused)
- **Carlos Thompson**: Monday Class only (class student)
- **Diana Chang**: Cuban DC Festival + Friday Social (festival + social)
- **Elena Volkov**: Friday Social only (pure social dancer)
- **Frank Kim**: Monday Class only (another class student)
- **Grace Wilson**: All three tags (attends everywhere - perfect for testing!)

This sample data provides realistic scenarios for testing:
- Single-tag filtering (Bob, Carlos, Frank, Elena)
- Multi-tag filtering (Alice, Diana)
- All-tags filtering (Grace)
- Event planning across different time periods
- Complete tag filtering functionality validation

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
- Access application settings (overflow menu)
- Import events from JSON files (single or multiple files, overflow menu, positioned last)
**Navigation**:
- → Create Event Screen (FAB)
- → Event Screen (tap event)
- → Dancers Screen (app bar action)
- → Settings Screen (overflow menu action)
- → Event Import Dialog (overflow menu action)

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
**Purpose**: Main event management with intelligent tab behavior based on event age
**AppBar Design**:
- **Title**: Event name with bullet separator and compact date format (e.g., "Salsa Night • Dec 15")
- **Subtitle**: 
  - For old events (2+ days ago): Static text "Summary" 
  - For recent past events: Dynamic tab indicator showing available tabs with active one in brackets (e.g., "[Present] • Summary")
  - For far future events (1+ days): Static text "Planning"
- For current events (today/within 1 day): Dynamic tab indicator showing all tabs with active one in brackets (e.g., "[Planning] • Present • Summary")
**Smart Tab Navigation**: Automatically determines tab configuration based on event age for optimal user experience
- **Navigation**: Pure swipe-based using PageController for multi-tab views. Single-tab view for old/far future events eliminates unnecessary navigation.
**Conditional View**:
- **Old Events (2+ days ago)**: Shows only Summary tab with direct focus on reviewing scores and impressions
- **Far Future Events (1+ days from now)**: Shows only Planning tab for focused event preparation
- **Recent Past Events**: Shows Present + Summary tabs for attendance review and scoring
- **Current Events (today/within 1 day)**: Shows full Planning + Present + Summary tabs functionality
**Pages**:

**Planning Tab** (Only for current events and far future events):
- View only ranked dancers who are NOT present yet (focused on marking presence)
- Set/edit rank selection (using predefined ranks)
- Add reasons for rankings (pre-event planning)
- **Add multiple existing dancers** (FAB → Select Dancers Screen)
  - Select from unranked dancers in database
  - Bulk add without automatic rank assignment
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

**Summary Tab**:
- Review and edit post-event scores and impressions for all attendees
- View complete event attendance with dance completion status
- Edit scores for any attendee regardless of dance status
- Review and modify impressions from recorded dances
- **Statistics Display**: Simple header showing "Recorded X dances total. Met Y people for the first time."
- **Score Groupings**: Dancers organized by score with count display and sticky headers
- **Sticky Group Headers**: Score group headers remain pinned at top while scrolling through each group's dancers
  - **Always Visible Context**: Current group name and dancer count visible during scroll
  - **Visual Design**: Headers feature subtle shadows and borders for clear separation
  - **Count Display**: Simple text counter in parentheses "(X)" next to score name
  - **Smooth Performance**: Custom scroll view optimized for large dancer lists
- **Dance Checkmarks**: Show checkmarks (✓) for dancers who have danced, except for past events
  - **Past Event Behavior**: Checkmarks hidden for events in the past to reduce visual clutter
  - **Current/Future Events**: Checkmarks visible to help track dance completion during active events
  - **Memory Aid**: Past events focus on scores and impressions without checkmark distraction
- **Primary use case**: Post-event reflection and score refinement
- **Optimized for Old Events**: Only tab shown for events 2+ days ago to focus on historical review

**Summary Tab Actions**:
- **FAB (Active Events)**: Speed dial menu with two options for flexible attendance management:
  - **Add New Dancer** → Opens Add Dancer Dialog to create new dancer profiles
  - **Add Existing Dancer** → Opens Add Existing Dancer Screen to mark unranked dancers as present
- **FAB (Old Events)**: Hidden for events 2+ days ago to maintain read-only experience
- **Tap dancer**: Opens context-aware actions dialog:
  - **Edit Score** → Opens Score Dialog for any attendee (context-aware text)
  - **Edit Impression** → Quick text editing for dance impressions
  - **Mark as Danced With** → Record dance completion for missed recordings
  - **Attendance Management** → Mark present/absent, mark as left

### 4. Select Dancers Screen (`SelectDancersScreen`)
**Purpose**: Select multiple existing dancers to add to event ranking (for planning phase)
**Actions**:
- View list of unranked dancers only (dancers not yet added to this event)
- **Tag filtering**: Filter dancers by single tag selection using tag filter chips
  - Shows only tags that have associated dancers
  - Single-select behavior with clear button (✕) when tag is selected
  - Combined with text search for refined filtering
- Search dancers by name or notes
- Multi-select dancers using checkboxes
- Add selected dancers to event without automatic rank assignment
**Tag Filtering UI**:
- **Filter Chips**: Horizontal scrollable row of tag chips above dancer list
- **Material 3 Design**: Chips change color when selected, clear button appears
- **Smart Tag Display**: Only shows tags that have associated dancers in database
- **Memory Aid**: Helps recall dancers by venue/context (e.g., "Monday Class" → class students)
**Navigation**:
- ← Back to Event Screen

### 4b. Add Existing Dancer Screen (`AddExistingDancerScreen`)
**Purpose**: Mark unranked and absent dancers as present when they appear at events
**Actions**:
- View list of unranked AND absent dancers only (excludes ranked dancers and already present dancers)
- **Tag filtering**: Filter dancers by single tag selection using tag filter chips
  - Shows only tags that have associated dancers
  - Single-select behavior with clear button (✕) when tag is selected
  - Combined with text search for refined filtering
- **Text search**: Search dancers by name or notes with real-time filtering
  - Debounced search (300ms) for smooth performance
  - Combined with tag filtering for comprehensive results
  - Maintains focus and cursor position during typing
- One-tap "Mark Present" action for each dancer
- **Persistent Screen**: Screen stays open after marking dancers to enable bulk operations
- **Efficient Feedback**: Brief 1-second snackbar confirmations for rapid marking
- Info banner explaining scope and guiding users about present dancers
- Shows dancer context: notes for identification
- **Smart filtering**: Automatically excludes dancers who are already present to prevent duplicates
**Tag Filtering UI**:
- **Filter Chips**: Horizontal scrollable row of tag chips above dancer list
- **Material 3 Design**: Chips change color when selected, clear button appears
- **Smart Tag Display**: Only shows tags that have associated dancers in database
- **Memory Aid**: Essential for remembering dancers by venue when you forget names
- **Enhanced Empty States**: Context-aware messages when no dancers match tag filter
**Navigation**:
- ← Back to Event Screen

### 5. Dancers Screen (`DancersScreen`)
**Purpose**: Manage all dancers in the database with comprehensive filtering and tag display
**Actions**:
- View list of all dancers with their tags
- **Search dancers** by name or notes (intelligent word-start matching with debounced input)
- **Filter dancers by tags** (multi-tag selection with visual feedback)
- **Filter dancers by activity level** (All, Active, Very Active, Core Community, Recent)
- Add new dancer (FAB)
- Edit existing dancer (tap → context menu)
- Delete dancer (tap → context menu, with confirmation)
- **Merge dancers** (tap → context menu → "Merge into...")
**UI Design**:
- **Unified Filtering Component**: CombinedDancerFilter provides single interface for all filtering
- **Self-Managed State**: Component handles its own search, tag, and activity level state
- **Debounced Search**: 300ms debounce for smooth search experience without excessive API calls
- **Multi-Tag Selection**: Support for selecting multiple tags with clear visual feedback
- **Activity Level Filtering**: Radio button selection for different activity levels with descriptions
- **Dropdown UI**: Clean dropdown interface for both tag and activity level selection
- **Visual Feedback**: Clear indication of selected filters with counts and descriptions
- **Loading States**: Proper loading indicators for tag and activity level data
- **Clear Functionality**: Easy clearing of tag selections with "Clear All" button
- **Enhanced Card Layout**: Name with notes and tags displayed below
- **Tag Display**: Colored chip badges under dancer name showing assigned tags
- **Combined Filtering**: Search, tag, and activity level filters work together for precise dancer filtering
- **Intelligent Search**: Word-start matching for precise name and notes searching
- **Tap for Context Actions**: Single tap on any dancer card opens modal bottom sheet with Edit, Merge, and Delete options
- **Context Menu Options**: 
  - **Edit**: Opens Add/Edit Dancer Dialog for name, notes, and tag modifications
  - **Merge into...**: Opens target selection screen for consolidating duplicate dancer records
  - **Delete**: Confirms deletion with warning about related data removal
- **Consistent Interaction**: Follows same pattern as Tags, Ranks, and Events screens
- **Clean Design**: No visual clutter with hidden context menus
- **Tag Chips Styling**: Small rounded containers with primary container color
- **Smart Empty State**: Empty state messages consider all active filters
**Merge Workflow**:
1. **Initiate Merge**: Tap source dancer → Select "Merge into..." from context menu
2. **Target Selection**: Navigate to dedicated screen with search functionality
3. **Choose Target**: Browse/search all other dancers (excluding source dancer)
4. **Confirmation**: Review merge details with clear warning about data transfer
5. **Execute**: Complete merge with transaction safety and success feedback
**Merge Process**:
- **Data Preservation**: All dance history, rankings, attendances, tags, and notes transferred to target dancer
- **Conflict Resolution**: Duplicate attendances handled intelligently (keeps target's record)
- **Tag Combination**: All unique tags from both dancers preserved
- **Notes Merging**: Combined with separator (target | source) when both exist
- **First Met Date**: Preserves earliest date between source and target dancers
- **Transaction Safety**: All operations wrapped in database transaction with rollback on errors
**Navigation**:
- ← Back to previous screen
- → Add/Edit Dancer Dialog (modal) with tag selection
- → Select Merge Target Screen (for dancer consolidation)

### 5a. Select Merge Target Screen (`SelectMergeTargetScreen`)
**Purpose**: Select target dancer for merging duplicate records with comprehensive preview
**Access**: From Dancers Screen → tap dancer → context menu → "Merge into..."
**Actions**:
- Search available dancers by name or notes  
- View all dancers except the source dancer being merged
- Tap any dancer to initiate merge confirmation
- Clear indication of merge operation in progress
**UI Design**:
- **Search Functionality**: Text field at top for filtering dancers by name or notes
- **Info Banner**: Clear explanation of merge operation and data transfer
- **Dancer List**: Card-based layout showing all available target dancers
- **Alphabetical Sorting**: Dancers sorted by name for easy navigation
- **Avatar Indicators**: Circle avatars with first letter of dancer name
- **Notes Display**: Subtitle showing dancer notes when available
- **Empty States**: Helpful messages when no dancers available or no search results
**Merge Confirmation Dialog**:
- **Clear Summary**: Shows source dancer merging into target dancer
- **Operation Preview**: Bullet points explaining what will happen after merge
- **Data Transfer Details**: 
  - All dance history will be transferred
  - All tags will be combined  
  - Notes will be merged
  - Source dancer will be deleted
- **Warning Notice**: Prominent warning that action cannot be undone
- **Action Buttons**: Cancel (safe exit) and Confirm Merge (proceed with operation)
**Error Handling**:
- **Transaction Safety**: Database operations wrapped in transactions
- **User Feedback**: Success and error messages via toast notifications
- **Graceful Failure**: Rollback on errors with clear error reporting
- **Loading States**: Visual feedback during merge operation
**Navigation**:
- ← Back to Dancers Screen (cancel merge)
- → Confirmation Dialog → Back to Dancers Screen (after merge completion)

### 6. Tags Management Tab (`TagsManagementTab`)
**Purpose**: Manage all tags in the system for dancer categorization (within Settings Screen)
**Access**: Home Screen → Settings Screen → Tags Tab (4th tab)
**Actions**:
- View list of all tags (predefined and custom)
- Add new custom tags via dialog
- Edit existing tag names via context menu
- Delete tags with confirmation dialog
- Simple tag management interface
**UI Design**:
- **Clean List Layout**: Card-based ListTile showing just tag names without icons
- **Minimalist Interface**: Focus on tag names without visual clutter
- **Tap for Context Actions**: Single tap opens modal bottom sheet with Edit and Delete options
- **Add Tag FAB**: Floating action button to create new tags
- **Consistent Pattern**: Follows same interaction pattern as other management tabs
**Context Menu Actions**:
- **Edit**: Update tag name with validation against duplicates
- **Delete**: Remove tag with confirmation dialog warning about impact on dancers
**Add Tag Dialog**:
- **Simple Text Input**: Enter tag name with validation
- **Immediate Feedback**: Success/error messages via SnackBar
- **Duplicate Prevention**: TagService handles duplicate tag creation
- **Auto-focus**: Text field automatically focused for quick entry
**Edit Tag Dialog**:
- **Pre-filled Text**: Current tag name loaded for editing
- **Validation**: Prevents duplicate names and empty values
- **Immediate Feedback**: Success/error messages via SnackBar
**Delete Confirmation**:
- **Impact Warning**: Explains tag will be removed from all dancers
- **Permanent Action**: Clear warning that deletion cannot be undone
**Navigation**:
- Access via Settings Screen → Tags Tab
- → Add Tag Dialog (FAB)
- → Edit Tag Dialog (context menu)
- → Delete Confirmation Dialog (context menu)

### 7. Settings Screen (`SettingsScreen`)

Centralized configuration management with tabbed interface for different settings categories.

### 7.1 Screen Structure
- **AppBar**: Title "Settings" with tab bar for navigation
- **TabController**: Manages four tabs (General, Ranks, Scores, Tags)
- **TabBarView**: Contains tab content widgets
- **Initial Tab Selection**: Optional `initialTabIndex` parameter allows direct navigation to specific tabs

### 7.2 Tab Configuration
```dart
Tab(icon: Icon(Icons.settings), text: 'General')
Tab(icon: Icon(Icons.military_tech), text: 'Ranks')
Tab(icon: Icon(Icons.star_rate), text: 'Scores')
Tab(icon: Icon(Icons.label), text: 'Tags')
```

### 7.3 General Settings Tab
- **App Information Card**: 
  - App name: "Dancer Ranking App"
  - Built for: "Private use"
- **Database Reset Option**: 
  - Red-colored warning action to completely clear all data
  - Confirmation dialog with comprehensive warning about data loss and optional test data choice
  - Checkbox option to include sample test data (events, dancers, rankings, attendances)
  - Loading state during reset operation
  - Success/error feedback via toast notifications with context-aware messages
  - Clears all tables (events, dancers, rankings, attendances, tags, scores)
  - Restores essential defaults (ranks, tags, scores) and optionally test data

### 7.4 Scores Management Tab (`_ScoresManagementTab`)
- **Drag-to-Reorder List**: ReorderableListView of all scores with usage statistics
- **Context Menu**: Rename, delete (if unused), merge operations
- **Add Score Dialog**: Create new score with automatic ordinal assignment
- **Floating Action Button**: Positioned within tab for adding new scores

### 7.5 Ranks Management Tab (`_RanksManagementTab`)
- **Drag-to-Reorder List**: ReorderableListView of all ranks with priority order and usage statistics
- **Usage Statistics**: Each rank displays usage count (e.g., "Beginner • 5 attendances")
- **Context Menu**: Edit, archive/unarchive, delete operations
- **Add Rank Dialog**: Create new rank with automatic ordinal assignment
- **Edit Rank Dialog**: Modify existing rank name
- **Archive/Unarchive**: Toggle rank availability for new events
- **Delete with Replacement**: Choose replacement rank when deleting (prevents orphaned rankings)
- **Floating Action Button**: Positioned within tab for adding new ranks

### 7.6 Tags Management Tab (`TagsManagementTab`)
- **Usage Statistics Display**: Clean card-based layout showing tag names with usage counts (e.g., "regular • 5 dancers")
- **Context Menu**: Edit and delete operations via tap-to-open modal bottom sheet
- **Add Tag Dialog**: Create new tags with validation and duplicate prevention
- **Edit Tag Dialog**: Modify existing tag names with validation
- **Delete Confirmation**: Warning dialog explaining impact on dancers
- **Floating Action Button**: Positioned within tab for adding new tags
- **Provider Integration**: Uses TagService from context for data operations with usage statistics
- **Manual Refresh**: Automatic reload after create, update, and delete operations to keep statistics current
- **Consistent UI Pattern**: Follows same interaction model as other management tabs with usage display like scores and ranks

### 7.7 Actions Available

#### General Tab Actions:
- View app information
- **Reset Database**: Complete data wipe with confirmation dialog and optional test data

#### Scores Tab Actions:
- **Drag to reorder**: Update score priority
- **Tap score**: Open context menu
- **Rename**: Update score name
- **Delete**: Remove unused scores
- **Merge**: Combine scores and reassign dances
- **Add New**: Create additional score

#### Ranks Tab Actions:
- **Drag to reorder**: Update rank priority
- **Tap rank**: Open context menu  
- **Edit**: Update rank name
- **Archive/Unarchive**: Toggle availability for new events
- **Delete**: Remove rank with replacement selection
- **Add New**: Create additional rank

#### Tags Tab Actions:
- **Tap tag**: Open context menu
- **Edit**: Update tag name with duplicate validation
- **Delete**: Remove tag with confirmation and impact warning
- **Add New**: Create additional tag with validation

### 7.8 Navigation Flow
```
Home Screen → Settings (app bar action)
Settings Screen → [General | Ranks | Scores | Tags] tabs
Ranks Tab → [Add | Edit | Archive | Delete] → Back to tab
Scores Tab → [Add | Edit | Delete | Merge] → Back to tab
Tags Tab → [Add | Edit | Delete] → Back to tab
```

### 7.9 Data Management
- **Scores**: Full CRUD operations with usage tracking and ordinal management
- **Ranks**: Full CRUD operations with usage tracking, archival system and ordinal management
- **Tags**: Full CRUD operations with validation and duplicate prevention
- **Usage Statistics**: Scores and ranks display usage counts for informed management
- **Real-time Updates**: StreamBuilder and setState() trigger UI refresh after operations
- **Error Handling**: Toast messages for operation success/failure

### 8. Dialogs and Modals

**Ranking Dialog (`RankingDialog`)**:
- Interactive rank selection from predefined options
- Display rank names in ordinal order
- Optional reason text field for current situation context
- Shows when ranking was last updated
- Save/cancel actions (updates `last_updated` timestamp)
- **Presented as a bottom sheet (showModalBottomSheet), matching the context actions menu style and wireframes**

**Score Dialog (`ScoreDialog`)**:
- Simple score assignment from predefined score options for any present attendant
- Display score names with ordinal ratings (1=Amazing, 5=Meh) as radio buttons
- Auto-selects current score if already assigned, otherwise defaults to "Good"
- Save/cancel actions only - simplified interface without removal options
- **Presented as a bottom sheet (showModalBottomSheet), matching the context actions menu style and wireframes**
- **Context**: Accessible for any present attendant regardless of dance completion status
- **Integration**: Launched from Dancer Actions Dialog for any attendant with flexible rating criteria

**Dancer Actions Dialog (`DancerActionsDialog`)**:
- Context-aware actions based on dancer state, tab mode, and event timing
- **Auto-Closing Behavior**: All actions close the dialog after completion for focused workflows
- **Visual Feedback**: Snackbar notifications provide immediate feedback after dialog closes
- **Tab-Specific Actions**: Different action sets available based on Planning vs Present mode
- **Event Timing Awareness**: Ranking actions and presence management hidden for past events to prevent confusion
- **Efficient Navigation**: Quick action → feedback → return to main view for next task
- **Action Types**: Set/Edit Ranking (current/future events only, not on summary tab), Mark/Remove Present (current events only), Record Dance, Edit Notes, Remove from Event, Mark as Left (current events only), Combo Actions
- **Event Management**: "Remove from event" action only appears for ranked dancers in Planning mode, allowing cleanup of event rankings
- **Left Tracking**: "Mark as left" action only appears for present dancers who haven't been danced with yet and only for current events, tracking early departures
- **Past Event Restrictions**: "Mark absent" and "Mark as left" actions are hidden for past events where they don't make sense

**Add/Edit Dancer Dialog**:
- Name input (required)
- Notes input (optional)
- **Tag Selection**: Interactive pill-based interface for selecting predefined tags
  - Shows all available tags as toggleable filter chips
  - Selected tags highlighted with primary container color
  - Supports multiple tag selection per dancer
  - Tags load automatically for existing dancers
- **Tag Filtering (New)**: Filter existing dancers by tag to avoid duplicates
  - Tag filter chips above form fields (only when creating new dancers)
  - Shows existing dancers with selected tag
  - Select existing dancer to pre-fill form with their data
  - Helps when users remember venue/context but not dancer name
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

### 9. Event Import Dialog (`ImportEventsDialog`)
**Purpose**: Full-screen dialog for importing events from a JSON file with comprehensive attendance and score data.
**Enhanced Features**:
- **Score Import Support**: Automatic creation of missing scores referenced in import data
- **Automatic Score Assignment**: Assigns scores to attendance records during import
- **Score Conflict Resolution**: Creates new scores when referenced score names don't exist
**Workflow**:
1.  **File Selection**: User selects or drops JSON files.
2.  **Automatic Processing**: Files are immediately parsed and validated.
    - It checks for duplicate events and identifies new dancers that will be created.
    - Validates score names and identifies missing scores that will be auto-created.
3.  **Data Preview**: The user is automatically shown a comprehensive preview of the events to be imported with enhanced statistics and detailed attendance data.
    - **Enhanced Statistics**: Shows events, attendances, dancers, and new dancers count
    - Each event in the list displays its name, date, and number of attendees. The new dancer count is appended to the attendance info (e.g., "15 attendances (3 new)").
    - **Duplicate Indication**: Events that already exist in the database are clearly marked and shown as "Skipped".
    - Users can expand each event to see the detailed list of attendees with all imported data.
    - **Comprehensive Attendance Display**: 
      - **Compact Multi-line Format**: Main line shows dancer name (with "new" indicator), status with colored text
      - **Rich Data Details**: Secondary line shows impression text in italics and score assignments with "Score:" prefix
      - **Clean Text Layout**: Simplified design focusing on text content without visual icons for better readability
      - **Combined Display**: Efficiently shows both impression and score data when both present
    - **Data Preservation Notice**: Automatic behavior section mentions preservation of impressions and score assignments
4.  **Confirmation**: User confirms the import.
5.  **Import**: The app imports the valid events and attendees with score assignments.
    - Duplicate events are automatically skipped.
    - New dancers are automatically created.
    - Missing scores are automatically created with appropriate ordinal values.
    - Score assignments are applied to attendance records for "served" status dancers.
6.  **Results Summary**: Shows comprehensive import results with statistics and any errors.
    - **Import More Files**: Button to reset dialog and import additional files without closing
    - **Seamless Workflow**: Users can import multiple event files in sequence
    - **Action Logging**: Tracks when users choose to import additional files
**Enhanced JSON Format**:
```json
{
  "events": [
    {
      "name": "Event Name",
      "date": "2024-12-20",
      "attendances": [
        {
          "dancer_name": "Dancer Name",
          "status": "served",
          "impression": "Optional impression text",
          "score": "Great"
        }
      ]
    }
  ]
}
```
**Import Rules**:
- **Score Assignment**: Only applies to dancers with "served" status
- **Missing Scores**: Automatically created with default ordinal values
- **Score Names**: Case-sensitive matching, trimmed whitespace
- **Error Handling**: Invalid score assignments logged but don't block import
- **Full Integration**: Imported scores are immediately available in UI with proper display and editing capabilities
**Navigation**:
- Opened from Home Screen's overflow menu.
- Closes upon completion or cancellation.

## Common Components

### Filtering Components

**CombinedDancerFilter (`lib/widgets/combined_dancer_filter.dart`)**:
- Unified filtering component with self-managed state
- Debounced search (300ms) for smooth user experience
- Multi-tag selection with visual feedback and clear functionality
- Activity level filtering with radio button selection
- Dropdown UI for both tag and activity level selection
- Loading states and error handling for data fetching
- Visual feedback with counts and descriptions for each filter type
- Used for comprehensive dancer filtering across the app

**CommonSearchField (`lib/widgets/common_search_field.dart`)**:
- Reusable search field with consistent Material 3 styling
- Built-in clear button that appears when text is entered
- Configurable hint text, label text, and initial value
- Proper state management with TextEditingController
- Support for different text input actions and autofocus
- Used across multiple screens for consistent search experience

**CommonFilterSection (`lib/widgets/common_filter_section.dart`)**:
- Combined search and tag filtering component
- Integrates CommonSearchField with TagFilterChips
- Optional tag filtering with configurable visibility
- Consistent padding and layout across all screens
- Flexible configuration for different use cases
- Reduces code duplication and ensures consistent UX

**TagFilterChips (`lib/widgets/tag_filter_chips.dart`)**:
- Horizontal scrollable row of tag filter chips
- Single tag selection with toggle behavior
- Clear button that appears when tag is selected
- Loading state and empty state handling
- Material 3 FilterChip styling with proper theming
- Used for venue/context-based dancer filtering

### Usage Patterns
- **DancersScreen**: Uses CombinedDancerFilter for unified search, tag, and activity level filtering
- **SelectDancersScreen**: Uses CommonFilterSection for event dancer selection
- **AddDancerDialog**: Uses TagFilterChips for existing dancer filtering
- **AddExistingDancerScreen**: Uses SimplifiedTagFilter for advanced filtering

### Benefits
- **Consistent UX**: All filtering screens have identical behavior and appearance
- **Code Reusability**: Reduced duplication across multiple screens
- **Maintainability**: Centralized filtering logic for easier updates
- **Accessibility**: Proper semantic labels and keyboard navigation
- **Performance**: Optimized state management and efficient rebuilds

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