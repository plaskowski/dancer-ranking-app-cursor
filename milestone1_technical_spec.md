# Milestone 1 - Technical Implementation Specification

## Overview
This document outlines the technical changes required to complete Milestone 1 scope, focusing on the missing features:
- Scores system for present persons
- First met date tracking
  - Note: the explicit value should only be used for a case of a dancer I met before the events I have tracked, use the attendance data for the rest
- Summary tab in Event Screen
- Enhanced event import with scores support

## 1. Database Schema Changes

### 1.1 New Scores Table
```sql
CREATE TABLE scores (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,           -- e.g., "Amazing", "Great", "Good", "Okay", "Meh"
  ordinal INTEGER NOT NULL,            -- 1 = best, 5 = worst (like Ranks)
  is_archived BOOLEAN DEFAULT FALSE,   -- Hide from new events but keep in history
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### 1.2 Enhanced Attendances Table
```sql
-- Add new columns to existing Attendances table
ALTER TABLE attendances ADD COLUMN score_id INTEGER REFERENCES scores(id);
ALTER TABLE attendances ADD COLUMN first_met BOOLEAN DEFAULT FALSE;
```

### 1.3 Enhanced Dancers Table
```sql
-- Add new column to existing Dancers table
ALTER TABLE dancers ADD COLUMN first_met_date DATE NULL;
-- This column will be used for dancers I met before I tracked the events, don't auto-populate it from events
```

### 1.4 Enhanced ImportableAttendance Model
Add support for score and firstMet flag in import data:
```json
{
  "dancer_name": "Alice",
  "status": "served",
  "impression": "Great dance!",
  "score": "Amazing",           // NEW: Score name
  "first_met": true             // NEW: Optional boolean - true if first met at this event
}
```

### 1.5 Default Data Population
Pre-populate Scores table with standard scoring scale:
1. "Amazing" (ordinal 1)
2. "Great" (ordinal 2) 
3. "Good" (ordinal 3)
4. "Okay" (ordinal 4)
5. "Meh" (ordinal 5)

## 2. New Services

### 2.1 ScoreService (`lib/services/score_service.dart`)
**Purpose**: CRUD operations for score management
**Key Methods**:
- `getAllScores()` - Get all scores ordered by ordinal
- `getActiveScores()` - Get non-archived scores for UI dropdowns
- `getScore(int id)` - Get specific score by ID
- `getScoreByName(String name)` - Get score by name (for imports)
- `createScore({required String name, required int ordinal})` - Create new score
- `updateScore({required int id, String? name, int? ordinal, bool? isArchived})` - Update score
- `deleteScore({required int id, required int replacementScoreId})` - Delete with reassignment
- `getDefaultScore()` - Get middle score (ordinal 3, "Good")

### 2.2 Enhanced AttendanceService (`lib/services/attendance_service.dart`)
**New Methods for Score Management**:
- `assignScore({required int attendanceId, required int scoreId})` - Assign score to attendance
- `getAttendanceScore(int attendanceId)` - Get current score for attendance
- `removeScore(int attendanceId)` - Remove score assignment
- `getAttendancesByScore(int eventId)` - Get attendances grouped by score for Summary tab
- `updateScore({required int attendanceId, required int newScoreId})` - Change score

### 2.3 Enhanced DancerService
**New Methods**:
- `getFirstMetDate(int dancerId)` - Return stored first met date (explicit dates only)
- `setFirstMetDate({required int dancerId, required DateTime date})` - Explicitly set first met date

## 3. UI Component Changes

### 3.1 Enhanced Event Screen (`lib/screens/event_screen.dart`)
**Changes**:
- Add third tab: "Summary" 
- Update PageView to support 3 tabs: Planning, Present, Summary
- Update tab indicator in AppBar to show all three tabs
- Add conditional FAB behavior for Summary tab

### 3.2 New Summary Tab (`lib/screens/tabs/summary_tab.dart`)
**Purpose**: Display event attendances grouped by scores
**Features**:
- Group attendances by assigned scores (Amazing, Great, Good, etc.)
- Show unscored attendances in separate section
- Tap dancer to edit score and impression
- Display ⭐ indicators for first met people
- Empty state for events with no attendances

**UI Structure**:
```
Summary Tab
├── Score Group: "Amazing" (2 people)
│   ├── Alice ⭐
│   └── Bob
├── Score Group: "Great" (3 people)
│   ├── Carol
│   ├── Dave ⭐
│   └── Eve
├── Unscored (1 person)
│   └── Frank
└── Empty state if no attendances
```

### 3.3 Enhanced Present Tab (`lib/screens/tabs/present_tab.dart`)
**Changes**:
- Add score assignment to dancer action dialogs
- Show current score (if any) in dancer cards
  - Add "⭐" indicator for new people
- Update dancer actions to include score management

### 3.4 Enhanced Dancer Actions Dialog
**New Actions**:
- "Assign Score" (if no score assigned) → Opens Ranking Dialog modified to show scores instead of ranks
- "Edit Score" (if score already assigned) → Opens same score selection dialog

## 4. Enhanced Import System

### 4.1 Enhanced EventImportParser (`lib/services/event_import_parser.dart`)
**Changes**:
- Parse optional `score` field in attendance records
- Parse optional `first_met` boolean flag in attendance records

### 4.2 Enhanced EventImportValidator (`lib/services/event_import_validator.dart`)
**Changes**:
- Validate `first_met` field is boolean when present
- Basic validation of score field format (missing scores will be auto-created)

### 4.3 Enhanced EventImportService (`lib/services/event_import_service.dart`)
**Changes**:
- Always create missing scores automatically
- Assign scores to attendances during import (directly in attendances table)
- Set firstMet flag on attendance records when `first_met: true` flag is encountered
- Handle missing score creation

### 4.4 Import Models Updates (`lib/models/import_models.dart`)
**Changes**:
- Add `score` and `firstMet` fields to `ImportableAttendance`
- Add score-related fields to import result summaries

## 5. First Met Date Implementation

### 5.1 Calculation Strategy
**Priority Order**:
1. **Explicit date** - If `first_met_date` set on dancer record (only used for dancers met before tracked events)
2. **Calculated date** - Earliest attendance with `status = 'served'`
3. **No date** - Return null if never danced

**Note**: The explicit `first_met_date` value should only be used for dancers met before the events you have tracked. For all other cases, use the attendance data with `first_met = true` flags.

### 5.2 UI Integration
**Display Rules**:
- Show "⭐" indicator when attendance record has `first_met = true`
- Show on both Present tab and Summary tab
- Only show for attendances with `status = 'served'` and `first_met = true`

### 5.3 Import Integration
**For New Imports**:
- When `first_met: true` flag is encountered in attendance record:
  - Set `first_met = true` on the attendance record
  - Set the dancer's `first_met_date` to the event's date (if not already set or if this event is earlier)

### 5.4 Migration Strategy
**For Existing Data**:
- Set `first_met = true` on the earliest served attendance for each dancer
- Leave `first_met_date` column NULL for existing dancers (only used for pre-tracking meetings)
- Future imports with `first_met: true` can add additional first met flags

## 6. Integration Points

### 6.1 Service Dependencies
```
ScoreService ← AttendanceService (for score assignment)
AttendanceService ← SummaryTab, PresentTab, DancerActionsDialog
DancerService ← PresentTab, SummaryTab (for first met dates)
EventImportService ← ScoreService (for missing score creation)
```

### 6.2 Database Migration
**Migration Steps**:
1. Create `scores` table with default data
2. Add `score_id` and `first_met` columns to `attendances` table
3. Add `first_met_date` column to `dancers` table (defaults to NULL)
4. Set `first_met = true` on earliest served attendance for each dancer

### 6.3 Provider Integration
**New Providers Needed**:
- `ScoreService` provider in main.dart
- Update existing screens to access enhanced AttendanceService for score operations

## 7. Testing Considerations

### 7.1 Data Migration Testing
- Test upgrade from current schema to new schema
- Verify default scores are created correctly
- Verify `first_met` flags are set correctly on earliest served attendances

### 7.2 Import Testing
- Test import format with scores and firstMet boolean flags
- Test automatic missing score creation during import
- Test firstMet flag setting on attendance records

### 7.3 UI Testing
- Test Summary tab with various score distributions
- Test "⭐" indicators appear correctly for first met attendances
- Test score assignment and editing workflows
- Test empty states and edge cases

## 8. Implementation Order

### Phase 1: Foundation
1. Database schema changes and migration
2. ScoreService implementation
3. Enhanced AttendanceService with score management methods
4. Enhanced DancerService with first met date logic

### Phase 2: UI Components
1. Enhanced Dancer Actions Dialog with score management
2. Enhanced Present Tab with score display and ⭐ indicators
3. New Summary Tab implementation

### Phase 3: Event Screen Integration
1. Add Summary tab to Event Screen
2. Update tab navigation and FAB behavior
3. Test complete workflow

### Phase 4: Import Enhancement
1. Enhanced import models with score support
2. Updated import services with automatic score creation
3. Integration testing with real import data

This specification provides the roadmap for completing all missing Milestone 1 features while maintaining compatibility with existing functionality. 