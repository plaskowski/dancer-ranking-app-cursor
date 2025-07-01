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

### 11. Event Import Dialog (`ImportEventsDialog`)
**Purpose**: Full-screen dialog for importing events from a JSON file with comprehensive attendance and score data.
**Enhanced Features**:
- **Score Import Support**: Automatic creation of missing scores referenced in import data
- **Automatic Score Assignment**: Assigns scores to attendance records during import
- **Score Conflict Resolution**: Creates new scores when referenced score names don't exist
**Workflow**:
1.  **File Selection**: User selects a JSON file.
2.  **Parsing & Validation**: The app parses the file and performs a "dry run" to validate the data.
    - It checks for duplicate events and identifies new dancers that will be created.
    - Validates score names and identifies missing scores that will be auto-created.
3.  **Data Preview**: The user is shown a comprehensive preview of the events to be imported with enhanced statistics and detailed attendance data.
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
          "score_name": "Great"
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