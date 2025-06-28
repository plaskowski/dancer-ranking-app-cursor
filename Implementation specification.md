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
- **Unique constraint**: (event_id, dancer_id)

**Dances Table**
- `id` (Primary Key, Auto Increment)
- `event_id` (Foreign Key → Events.id) - Which event
- `dancer_id` (Foreign Key → Dancers.id) - Which dancer
- `impression` (Text, Optional) - Post-dance impression/notes
- `danced_at` (DateTime, Auto) - When dance was recorded

### Key Relationships
- One Event has many Rankings, Attendances, and Dances
- One Dancer has many Rankings, Attendances, and Dances
- One Rank has many Rankings (many-to-one)
- Rankings track pre-event planning (rank selection + reasons)
- Attendances track who's actually present at the event
- Dances track completed dances with impressions

### Default Rank Data
The Ranks table should be pre-populated with:
1. Level 1: "Not really interested" (Red)
2. Level 2: "Maybe later" (Orange) 
3. Level 3: "Neutral / Default" (Yellow)
4. Level 4: "Would like to dance" (Light Green)
5. Level 5: "Really want to dance!" (Green)

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
- Mark dancers as present/absent
- Record dances for present dancers

**Present Tab**:
- View only dancers marked as present
- Quick access to ranking and dance recording
- Visual indication of attendance status

**Ranked Tab**:
- View present dancers sorted by rank level (level 5 first)
- Prioritized list for dance decision making
- Clear rank badges with colors and reasons

**Actions (all tabs)**:
- Set/edit dancer ranking (tap ranking button → Ranking Dialog)
- Toggle attendance (tap attendance button)
- Record dance (tap dance button → Dance Dialog)
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
- Display rank names, descriptions, and colors
- Optional reason text field
- Color-coded rank levels
- Save/cancel actions

**Add/Edit Dancer Dialog**:
- Name input (required)
- Notes input (optional)
- Save/cancel actions

**Dance Recording Dialog**:
- Confirmation of dance partner
- Optional impression text field
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
│   └── Ranking Dialog (modal)
│   └── Dance Dialog (modal)
└── Dancers Screen
    └── Add/Edit Dancer Dialog (modal)
```

### Key Features
- **Pre-event planning**: Add dancers, set rank preferences with reasons
- **Event attendance**: Mark who's present, filter views accordingly  
- **Dance prioritization**: Ranked tab shows highest rank level first
- **Dance tracking**: Record completed dances, prevent duplicates
- **Flexible dancer management**: Add new people during events
- **Rich context**: Notes, reasons, and impressions for informed decisions
- **Customizable ranking system**: Predefined ranks with names, colors, and descriptions
