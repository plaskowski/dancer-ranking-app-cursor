# Dancer History Screen Design

## Problem Statement

**Ranking Context**: When ranking dancers at events, users need to recall past performance and interactions to make informed ranking decisions.

**Solution**: Simple "Dancer History" screen showing recent event interactions to aid ranking decisions during event planning.

## Feature Requirements

### Core Functionality
1. **Recent Events**: Show last 5-6 events where dancer attended
2. **Quick Context**: Simple one-line format with essential info only
3. **Minimal UI**: No stats, headers, or extra visual elements

### Data Presentation
- **Compact List**: One line per event with all essential info
- **Essential Only**: Date, event, dance status, score (if danced), notes

## UI Design

### Screen Access

**Primary Navigation**: Event Screen (Planning Tab) → Tap dancer → "View History"

### Minimal Single Screen Layout

```
┌─────────────────────────────────────┐
│ ← Magda K.                          │
├─────────────────────────────────────┤
│                                     │
│ Dec 15 - Christmas Party           │
│ ☑ Amazing • "Excellent lead & flow"│
│                                     │
│ Nov 28 - Weekly Social             │
│ ☐ Good • "Too crowded, left early" │
│                                     │
│ Nov 14 - Practice Session          │
│ ☑ Great • "Good improvement turns" │
│                                     │
│ Oct 30 - Halloween Dance           │
│ ☑ Great • "Consistent performance" │
│                                     │
│ Oct 16 - Workshop Night            │
│ ☐ Okay • "Very busy night"         │
│                                     │
└─────────────────────────────────────┘
```

### Key Information

Each line shows: **Date - Event • ☑/☐ Score • "Impression"**
- **☑ (Danced)**: Shows score from actual dance + impression
- **☐ (Present only)**: Shows assessment score + impression (explains why no dance)

## Database Design

### Simple Query Requirements

**Data Sources**:
- `events` table - Event details and dates  
- `attendances` table - Dance status, impressions, scores
- `scores` table - Score names

**Note**: Currently scores are only assigned to danced attendances (`status = 'served'`). To support assessment scores for present-only attendances, the system would need to allow score assignment for `status = 'present'` as well.

**Main Query** (get last 5-6 events with dancer involvement):

```sql
-- Get recent dancer history for dance context (only events where dancer attended)
SELECT 
  e.id as event_id,
  e.name as event_name,
  e.date as event_date,
  a.status,
  a.impression,
  s.name as score_name
FROM events e
INNER JOIN attendances a ON e.id = a.event_id AND a.dancer_id = ?
LEFT JOIN scores s ON a.score_id = s.id
ORDER BY e.date DESC
LIMIT 6;
```

## Technical Implementation

### Simple Service Method

Add method to existing `DancerEventService`:

```dart
// In lib/services/dancer/dancer_event_service.dart
Future<List<DancerRecentHistory>> getRecentHistory(int dancerId) async {
  // Simple query to get last 6 events with dancer involvement
  final query = _database.select(_database.events).join([
    leftOuterJoin(
      _database.attendances,
      _database.events.id.equalsExp(_database.attendances.eventId) &
          _database.attendances.dancerId.equals(dancerId),
    ),
    leftOuterJoin(_database.scores, _database.attendances.scoreId.equalsExp(_database.scores.id)),
  ])
    ..orderBy([OrderingTerm.desc(_database.events.date)])
    ..limit(6);
  
  // Return simplified history list
}
```

**Simple Data Model**:

```dart
class DancerRecentHistory {
  final String eventName;
  final DateTime eventDate;
  final String status; // 'present', 'served', 'left'
  final String? impression;
  final String? scoreName;
  
  // Simple computed properties
  bool get danced => status == 'served';
  // Note: For UI, we only care if they danced or not
}
```

### Simple Screen

**Single File**: `lib/screens/dancer_history_screen.dart`

**Navigation Integration**:

```dart
// In event planning tab - add to dancer action menu
ListTile(
  leading: Icon(Icons.history),
  title: Text('View History'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DancerHistoryScreen(dancerId: dancer.id, dancerName: dancer.name),
      ),
    );
  },
),
```

## User Workflow

### Primary Use Case: Ranking Context

**Scenario**: User is planning an event and needs to rank dancers

1. **Access**: User is in Event Planning tab, sees list of dancers
2. **Question**: "What level should I rank this dancer?"
3. **Action**: Taps dancer → "View History" 
4. **Review**: Quickly scans recent attended events to see:
   - How they performed when they danced (scores)
   - What the dance experiences were like (impressions)
   - Whether they've been attending regularly lately
5. **Decision**: Returns to planning tab with context to set appropriate ranking

### Simple Information Needs

**Essential**: Recent dance scores and impressions to recall quality of experiences
**Helpful**: How often they actually danced vs just being present
**Context**: Notes about what happened during dances or when they attended

### Integration

**Primary Access**: Event Planning Tab → Dancer → "View History"
- Simple addition to existing dancer context menu
- Quick reference, then back to ranking workflow
- Focused on helping with the immediate ranking decision

This simplified design supports the specific need of recalling actual dance experiences and impressions during event ranking, focusing on dance quality rather than past planning preferences. 