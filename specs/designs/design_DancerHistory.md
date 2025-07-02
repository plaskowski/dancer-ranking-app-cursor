# Dancer History Screen Design

## Problem Statement

**Ranking Context**: When ranking dancers at events, users need to recall past performance and interactions to make informed ranking decisions.

**Solution**: Simple "Dancer History" screen showing recent event interactions to aid ranking decisions during event planning.

## Feature Requirements

### Core Functionality
1. **Recent Events**: Show last 5-6 events where dancer was involved
2. **Quick Context**: Display dance status, scores, and rankings for each event
3. **Ranking Reference**: Help users recall past ranking decisions and reasoning

### Data Presentation
- **Recent Event List**: Simple list of recent events with key details
- **Quick Summary**: Basic stats at the top (total dances, last event)
- **Ranking Context**: Previous rankings and reasons to maintain consistency

## UI Design

### Screen Access

**Primary Navigation**: Event Screen (Planning Tab) → Tap dancer → "View History"

### Simple Single Screen Layout

```
┌─────────────────────────────────────┐
│ ← Dancer History                    │
├─────────────────────────────────────┤
│        👤 Magda K.                  │
│   🏷️ Regular • Social • Follower    │
│                                     │
│ 💃 Last danced: Dec 15, 2024       │
│ 🎯 Total dances: 12                 │
│ ⭐ Recent scores: Amazing, Great, Great │
└─────────────────────────────────────┘
│                                     │
│ 📅 Recent Events                    │
├─────────────────────────────────────┤
│                                     │
│ Dec 15, 2024 - Christmas Party     │
│ ✅ Danced  ⭐ Amazing                │
│ 💭 "Excellent lead and flow"       │
│                                     │
│ Nov 28, 2024 - Weekly Social       │
│ ✅ Present  ❌ No dance             │
│ 💭 "Too crowded, left early"       │
│                                     │
│ Nov 14, 2024 - Practice Session    │
│ ✅ Danced  ⭐ Great                 │
│ 💭 "Good improvement on turns"     │
│                                     │
│ Oct 30, 2024 - Halloween Dance     │
│ ✅ Danced  ⭐ Great                 │
│ 💭 "Consistent performance"        │
│                                     │
│ Oct 16, 2024 - Workshop Night      │
│ ✅ Present  ❌ No dance             │
│ 💭 "Very busy night"               │
│                                     │
│                                     │
│                                     │
└─────────────────────────────────────┘
```

### Key Information

Each event shows:
- **Date & Event Name**: When and where
- **Status**: Danced (✅) or Present only (✅)
- **Score**: If they danced (⭐ Amazing/Great/Good/Okay/Meh)
- **Notes**: Brief impression from that event (💭)

## Database Design

### Simple Query Requirements

**Data Sources**:
- `events` table - Event details and dates  
- `attendances` table - Dance status, impressions, scores
- `scores` table - Score names

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