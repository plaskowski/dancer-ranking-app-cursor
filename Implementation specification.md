# General principles
- Android application using Flutter framework
- save the data into SQLite using Drift library

# Coding guidelines
- put each component class into separate file
- use Drift expressions instead of raw SQL queries

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
- `created_at` (DateTime, Auto) - Creation timestamp

**Ranks Table** (Dictionary/Lookup Table)
- `id` (Primary Key, Auto Increment)
- `name` (Text, Required) - Display name (e.g., "Really want to dance!")
- `oridinal` (Integer, Required) - Sets the order from great to meh (the lower the better) 

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
- `has_danced` (Boolean, Default: false) - Whether you danced with this person
- `danced_at` (DateTime, Optional) - When dance occurred
- `impression` (Text, Optional) - Post-dance impression/notes
- **Unique constraint**: (event_id, dancer_id)
- **Note**: Record existence indicates presence at event
- **Special case**: When adding new dancer with "already danced" option, creates record with has_danced=true

### Key Relationships
- One Event has many Rankings and Attendances
- One Dancer has many Rankings and Attendances  
- One Rank has many Rankings (many-to-one)
- Rankings track pre-event planning (rank selection + reasons)
- Attendances track actual presence (record creation), dance completion, and impressions

### Default Rank Data
The Ranks table should be pre-populated with:
1. Ordinal 1: "Really want to dance!" (best rank)
2. Ordinal 2: "Would like to dance"
3. Ordinal 3: "Neutral / Default" 
4. Ordinal 4: "Maybe later"
5. Ordinal 5: "Not really interested" (lowest rank)

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
- Navigate to dancers management
**Navigation**:
- → Create Event Screen (FAB)
- → Event Screen (tap event)
- → Dancers Screen (app bar action)

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
**Purpose**: Main event management with tabbed interface
**Tabs**:

**Planning Tab**:
- View only ranked dancers who are NOT present yet (focused on marking presence)
- Set/edit rank selection (using predefined ranks)
- Add reasons for rankings (pre-event planning)
- **Add multiple existing dancers** (FAB → Select Dancers Screen)
  - Select from unranked dancers in database
  - Bulk add with default "Neutral" ranking
  - Planning-only actions: rank editing, notes editing
- **Smart empty state**: Shows different messages based on whether all ranked dancers are present

**Present Tab**:
- View only dancers who are present at the event (have Attendance records)
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
  - Mark present / Remove from present (attendance management)
  - **Mark Present & Record Dance** (combo action for absent dancers) → marks present + opens Dance Recording Dialog
  - Record dance with impression (→ Dance Recording Dialog)  
  - Edit dancer notes

**Navigation**:
- ← Back to Home Screen
- → Dancers Screen (app bar action)
- **Planning Tab FAB** → Select Dancers Screen (multi-select existing dancers)
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
- Info banner explaining scope and guiding users about present dancers
- Shows dancer context: notes for identification
- **Smart filtering**: Automatically excludes dancers who are already present to prevent duplicates
**Navigation**:
- ← Back to Event Screen

### 5. Dancers Screen (`DancersScreen`)
**Purpose**: Manage all dancers in the database
**Actions**:
- View list of all dancers
- Search dancers by name or notes
- Add new dancer (FAB)
- Edit existing dancer (tap menu)
- Delete dancer (tap menu, with confirmation)
**Navigation**:
- ← Back to previous screen
- → Add/Edit Dancer Dialog (modal)

### 6. Dialogs and Modals

**Ranking Dialog (`RankingDialog`)**:
- Interactive rank selection from predefined options
- Display rank names in ordinal order
- Optional reason text field for current situation context
- Shows when ranking was last updated
- Save/cancel actions (updates `last_updated` timestamp)

**Add/Edit Dancer Dialog**:
- Name input (required)
- Notes input (optional)
- Save/cancel actions
- **Accessible from Event Screen**: Create new dancers during events without navigation
  - **Special Event Context Features**:
    - "Already danced with this person" checkbox
    - Optional impression field (if already danced checked)
    - Automatically adds to current event and marks dance completion
- **Accessible from Dancers Screen**: Full dancer management

**Dance Recording Dialog**:
- Confirmation of dance partner
- Optional impression text field
- Updates attendance record with dance completion
- Prevents duplicate dance records
- Save/cancel actions

### Navigation Flow
```
Home Screen
├── Create Event Screen
├── Event Screen
│   ├── Planning Tab
│   │   ├── FAB → Select Dancers Screen (tab-specific action)
│   │   ├── Tap dancer → Planning Actions Dialog (rank/notes editing only)
│   │   └── Blue location icon → Instant "Mark Present" (context action)
│   ├── Present Tab
│   │   ├── FAB → Modal Menu
│   │   │   ├── → Add Dancer Dialog (create new dancer)
│   │   │   └── → Add Existing Dancer Screen (mark existing as present)
│   │   └── Tap dancer → Full Actions Dialog (context-aware)
│   │       ├── → Ranking Dialog
│   │       ├── → Dance Recording Dialog
│   │       └── → Attendance management
└── Dancers Screen
    └── Add/Edit Dancer Dialog (modal) - Full dancer management
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
- **Seamless dancer management**: Add new people during events without leaving screen
- **Post-dance integration**: Mark new dancers as already danced with immediate impression capture
- **Rich context**: Notes, reasons, and impressions for informed decisions
- **Ranking history**: Track when rankings were last updated for context
- **Streamlined data model**: Record existence indicates presence, no boolean flags needed
- **Enhanced dancer cards**: Display comprehensive information with visual distinction between personal notes, event-specific context, and dance impressions
  - **Personal notes**: Gray icon with dancer's general notes
  - **Ranking reasons**: Blue psychology icon with italic event-specific reasoning
  - **Dance status with impressions**: Music note icon with "Danced!" text followed by italicized impression text when available

### Code Architecture
- **Reactive Data Layer**: Drift database streams with automatic UI updates via StreamBuilder
- **Modular Structure**: Components split into focused, single-responsibility modules
- **Tab Actions Interface**: Clean abstraction for tab-specific FAB behaviors
- **Reusable Components**: Shared widgets across tabs with different behavioral modes
- **Separation of Concerns**: UI components separated from business logic and data access
- **Automatic Refresh**: No manual callbacks - UI updates automatically when any data changes
