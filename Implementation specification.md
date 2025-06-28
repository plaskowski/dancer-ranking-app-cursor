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
- **Unique constraint**: (event_id, dancer_id)

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
- Add reasons for rankings
- Add dancers to event when spotted (creates Attendance record)
- Record dances for dancers at event

**Present Tab**:
- View only dancers who have been added to the event (have Attendance records)
- Quick access to ranking and dance recording
- Shows when each person was first spotted

**Ranked Tab**:
- View dancers at event sorted by rank ordinal (ordinal 1 first)
- Prioritized list for dance decision making
- Clear rank badges and reasons

**Actions (all tabs)**:
- Set/edit dancer ranking (tap ranking button → Ranking Dialog)
- Add to event / Remove from event (tap attendance button)
- Record dance with impression (tap dance button → Dance Dialog)
- Add new dancer (app bar action)

**Navigation**:
- ← Back to Home Screen
- → Dancers Screen (app bar action)
- → Ranking Dialog (modal)
- → Dance Recording Dialog (modal)

### 4. Dancers Screen (`DancersScreen`)
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

### 5. Dialogs and Modals

**Ranking Dialog (`RankingDialog`)**:
- Interactive rank selection from predefined options
- Display rank names in ordinal order
- Optional reason text field
- Save/cancel actions

**Add/Edit Dancer Dialog**:
- Name input (required)
- Notes input (optional)
- Save/cancel actions

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
│   ├── Present Tab  
│   ├── Ranked Tab
│   ├── Ranking Dialog (modal)
│   └── Dance Recording Dialog (modal)
└── Dancers Screen
    └── Add/Edit Dancer Dialog (modal)
```

### Key Features
- **Pre-event planning**: Add dancers, set rank preferences with reasons
- **Simple attendance tracking**: Add people to event when spotted (no pre-marking needed)
- **Dance prioritization**: Ranked tab shows best rank ordinal first  
- **Integrated dance tracking**: Record completed dances and impressions in attendance records
- **Flexible dancer management**: Add new people during events
- **Rich context**: Notes, reasons, and impressions for informed decisions
- **Streamlined data model**: Record existence indicates presence, no boolean flags needed
