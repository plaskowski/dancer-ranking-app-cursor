# General principles
- Android application using Flutter framework
- save the data into SQLite using Drift library

# Coding guidelines
- put each component class into separate file

# App structure

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
- View list of all events (past and upcoming)
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
- View all dancers in database
- Set/edit rank selection (using predefined ranks)
- Add reasons for rankings (pre-event planning)
- Add dancers to event when spotted (creates Attendance record)
- Adjust rankings in real-time based on current impressions
- Record dances for dancers at event
- **Add multiple dancers** (FAB → Select Dancers Screen)

**Present Tab**:
- View only dancers who have been added to the event (have Attendance records)
- Quick access to ranking adjustments and dance recording
- Shows when each person was first spotted
- Easy ranking modification based on current presentation/mood

**Ranked Tab**:
- View dancers at event sorted by rank ordinal (ordinal 1 first)
- Prioritized list for dance decision making based on current rankings
- Clear rank badges, reasons, and last update timestamps
- Quick ranking adjustments for immediate priority changes

**Actions (Present Tab only)**:
- Set/edit dancer ranking in real-time (tap ranking button → Ranking Dialog)
- Update ranking reasons based on current situation
- Add / Remove from event (tap attendance button)
- Record dance with impression (tap dance button → Dance Dialog)
- Add new dancer without leaving event screen (quick action → Add Dancer Dialog)
  - Option to mark as "already danced" with impression for post-dance additions

**Actions (Planning Tab)**:
- Set/edit dancer ranking (tap ranking button → Ranking Dialog)
- Update ranking reasons for pre-event planning
- Multi-select existing dancers to add to event (FAB → Select Dancers Screen)

**Navigation**:
- ← Back to Home Screen
- → Dancers Screen (app bar action)
- → Ranking Dialog (modal)
- → Dance Recording Dialog (modal)
- → Add Dancer Dialog (modal) - Create new dancers during events

### 4. Select Dancers Screen (`SelectDancersScreen`)
**Purpose**: Select multiple existing dancers to add to event ranking (for planning phase)
**Actions**:
- View list of all dancers in database
- Search dancers by name or notes
- Filter to show only unranked dancers
- Multi-select dancers using checkboxes
- Add selected dancers to event with default rank (Neutral)
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
│   │   └── Select Dancers Screen (FAB) - Multi-select existing dancers for planning
│   ├── Present Tab  
│   ├── Ranked Tab
│   ├── Ranking Dialog (modal) - Real-time ranking adjustments
│   ├── Dance Recording Dialog (modal)
│   └── Add Dancer Dialog (modal) - Quick dancer creation during events (Present Tab)
└── Dancers Screen
    └── Add/Edit Dancer Dialog (modal) - Full dancer management
```

### Event Workflow with Dynamic Rankings
1. **Pre-event**: Set initial rankings based on general preferences
   - Use Planning Tab → Add Button (FAB) → Select Dancers Screen
   - Multi-select dancers from database to add to event ranking
   - All selected dancers get default "Neutral" rank initially
   - Adjust individual rankings using Ranking Dialog
2. **Arrive at event**: Open Event Screen, switch to Present/Ranked tabs
3. **Spot someone**: Tap "Add" to add them to event (creates Attendance record)
4. **New person**: If unknown, quickly add new dancer without leaving screen
   - **Already danced**: Check "Already danced" and add impression if you just finished dancing
5. **Assess situation**: Notice they look great/different → tap rank button
6. **Adjust ranking**: Change rank and add reason ("Looking amazing tonight!")
7. **Check priorities**: Ranked tab now shows updated order
8. **Dance and record**: Choose from top-ranked present dancers
9. **Continuous adjustment**: Update rankings throughout the event as needed

### Key Features
- **Pre-event planning**: Add dancers, set initial rank preferences with reasons
- **Dynamic ranking adjustment**: Change rankings during events based on real-time impressions
- **Simple attendance tracking**: Add people to event when spotted (no pre-marking needed)
- **Dance prioritization**: Ranked tab shows best rank ordinal first based on current rankings
- **Integrated dance tracking**: Record completed dances and impressions in attendance records
- **Seamless dancer management**: Add new people during events without leaving screen
- **Post-dance integration**: Mark new dancers as already danced with immediate impression capture
- **Rich context**: Notes, reasons, and impressions for informed decisions
- **Ranking history**: Track when rankings were last updated for context
- **Streamlined data model**: Record existence indicates presence, no boolean flags needed
