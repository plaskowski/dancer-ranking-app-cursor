# Dancer Merge Feature Design

## Problem Statement

**Issue**: Same person appears multiple times in the database under different names and nicknames
- **Import History**: Different events may reference the same person with variations like "Magda", "Magdalena", "Magda K."
- **Manual Entry**: Users may add the same person multiple times with slightly different spellings

**Solution**: Simple manual merge functionality to combine duplicate dancer records

## Feature Requirements

### Core Functionality
1. **Manual Merge**: User-initiated merge from dancer context menu
2. **Data Preservation**: All historical data transferred to target dancer
3. **Safe Operation**: Transaction-based with clear confirmation

## UI Design

### Manual Merge Workflow

**Access**: Dancers Screen → Tap dancer → Context menu → "Merge into..."

**Step 1: Context Menu**
```
┌─────────────────────────────────────┐
│        Magda K.                     │
├─────────────────────────────────────┤
│ ✏️  Edit                            │
│ 🔄  Merge into...                   │  
│ 🗑️  Delete                          │
└─────────────────────────────────────┘
```

**Step 2: Select Target Dancer**
```
┌─────────────────────────────────────┐
│ ← Merge "Magda K." into...          │
├─────────────────────────────────────┤
│ 🔍 Search dancers...                │
├─────────────────────────────────────┤
│ Select target dancer:               │
│                                     │
│ ○ Magda (15 dances, 8 events)      │
│ ○ Magdalena (3 dances, 2 events)   │
│ ○ Maria (12 dances, 6 events)      │
│                                     │
│              [Continue]             │
└─────────────────────────────────────┘
```

**Step 3: Confirm Merge**
```
┌─────────────────────────────────────┐
│        Confirm Merge                │
├─────────────────────────────────────┤
│ Merge: Magda K. (7 dances)         │
│ Into:  Magda (15 dances)            │
│                                     │
│ After merge:                        │
│ ✓ Magda will have 22 total dances  │
│ ✓ All event history preserved      │
│ ✓ Tags and notes combined           │
│ ✓ "Magda K." will be deleted       │
│                                     │
│ ⚠️ This action cannot be undone     │
│                                     │
│    [Cancel]  [Confirm Merge]       │
└─────────────────────────────────────┘
```

## Database Design

### Simple Merge Strategy

**Core Approach**: Move all data from source dancer to target dancer, then delete source

```sql
-- Transfer all foreign key references
UPDATE rankings SET dancer_id = target_id WHERE dancer_id = source_id;
UPDATE attendances SET dancer_id = target_id WHERE dancer_id = source_id;
UPDATE dancer_tags SET dancer_id = target_id WHERE dancer_id = source_id;

-- Combine notes if both exist
UPDATE dancers SET 
  notes = CASE 
    WHEN target_notes IS NULL THEN source_notes
    WHEN source_notes IS NULL THEN target_notes
    ELSE target_notes || ' | ' || source_notes
  END,
  first_met_date = MIN(target_first_met, source_first_met)
WHERE id = target_id;

-- Delete source dancer
DELETE FROM dancers WHERE id = source_id;
```

**Conflict Handling**:
- **Duplicate Tags**: Automatically handled by unique constraint
- **Duplicate Attendances**: If both attended same event, keep target dancer's record
- **Duplicate Rankings**: If both ranked for same event, keep target dancer's ranking

## Technical Implementation

### Service Method

```dart
class DancerService {
  Future<bool> mergeDancers(int sourceDancerId, int targetDancerId) async {
    return await database.transaction(() async {
      try {
        // 1. Get source dancer data for notes merge
        final sourceDancer = await getDancer(sourceDancerId);
        final targetDancer = await getDancer(targetDancerId);
        
        // 2. Update all foreign key references
        await _updateRankings(sourceDancerId, targetDancerId);
        await _updateAttendances(sourceDancerId, targetDancerId);
        await _updateDancerTags(sourceDancerId, targetDancerId);
        
        // 3. Merge notes and first met date
        await _mergePersonalData(sourceDancer, targetDancer);
        
        // 4. Delete source dancer
        await deleteDancer(sourceDancerId);
        
        return true;
      } catch (e) {
        // Transaction automatically rolled back
        return false;
      }
    });
  }
}
```

## User Workflow

### Simple Merge Process

1. **Identify Duplicates**: User manually identifies duplicate dancers
2. **Open Context Menu**: Tap on dancer to merge away
3. **Select Merge**: Choose "Merge into..." from context menu
4. **Choose Target**: Select which dancer to merge into (new screen)
5. **Confirm**: Review merge summary and confirm
6. **Complete**: Source dancer deleted, all data moved to target

### Integration

**Dancers Screen Enhancement**:
- Add "Merge into..." to existing dancer context bottom sheet (alongside Edit, Delete)
- Show success message after merge completion
- Auto-refresh dancer list to reflect changes

**Context Menu Update**:
```dart
// In dancers_screen.dart - add to existing bottom sheet
ListTile(
  leading: Icon(Icons.merge_type),
  title: Text('Merge into...'),
  onTap: () {
    Navigator.pop(context); // Close context menu
    _startMergeWorkflow(dancer);
  },
),
```

This simplified approach gives users the power to clean up duplicates manually without complexity. The user identifies the duplicates themselves and chooses how to merge them. 