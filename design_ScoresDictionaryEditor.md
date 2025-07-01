# Scores Dictionary Editor - Design Document

## Overview
The Scores Dictionary Editor allows users to manage and standardize the scoring system used across events. This addresses the common issue where imported event history contains different names for similar scores (e.g., "Excellent", "Great", "5 stars" all meaning the same thing).

## Problem Statement
- Imported event history often contains inconsistent score naming
- Different events may use different score systems that should be unified
- Users need ability to standardize and organize their scoring vocabulary
- Score order affects ranking calculations and should be customizable

## Features

### 1. Edit Score Names
- **Purpose**: Rename existing scores for consistency
- **Use Case**: Change "5 stars" to "Excellent" 
- **Behavior**: 
  - Updates the score name in the Scores table
  - Foreign key relationships automatically maintain data integrity
  - Shows confirmation dialog with usage summary (e.g., "This score is used in 15 dances")

### 2. Edit Score Order
- **Purpose**: Define the ranking hierarchy of scores
- **Use Case**: Ensure "Excellent" ranks higher than "Good" in calculations
- **Behavior**:
  - Drag-and-drop interface for reordering
  - Higher position = better score for ranking calculations
  - Real-time preview of how reordering affects existing rankings
  - Auto-saves order changes

### 3. Merge Scores
- **Purpose**: Combine duplicate or similar scores into one
- **Use Case**: Merge "Great", "Awesome", and "5 stars" into single "Excellent" score
- **Behavior**:
  - Select multiple scores to merge
  - Choose target score name (can be new or existing)
  - Show preview of affected dance records
  - Bulk update all references to use the merged score

## UI Design

### Main Screen Layout
```
Scores Dictionary Editor
├── Header
│   ├── Title: "Manage Scores"
│   └── Back Button
├── Scores List
│   ├── Drag handles for reordering
│   ├── Score name (tap for contextual menu)
│   ├── Usage count (e.g., "Used in 23 dances")
│   └── Long press for contextual actions (Rename, Delete, Merge)
└── Actions Bar
    ├── Add New Score button
    ├── Multi-select mode toggle (for merging)
    └── Reset to Defaults button
```

### Contextual Actions
```
Long Press Score → Context Menu
├── Rename Score
│   └── Simple dialog with text input and confirm/cancel
├── Delete Score
│   └── Confirmation dialog showing usage count
└── Start Merge
    └── Enters multi-select mode for choosing merge targets
```

### Merge Scores Dialog
**Navigation**: Context menu "Start Merge" → Multi-select mode → "Merge Selected" button
```
Merge Scores
├── Selected Scores (read-only list of chosen scores)
├── Target Score (dropdown of existing scores excluding selected ones)
├── Preview Impact
│   ├── "X dances will now use '[target score name]'"
│   └── "Y events will be affected"
└── Actions
    ├── Confirm Merge
    └── Cancel
```

## Technical Implementation

### Database Schema Considerations
- Scores table already exists with proper foreign key relationships
- `attendances.scoreId` references `scores.id` for data integrity
- Score names stored in `scores.name` field
- Ordinal field handles ranking order (`scores.ordinal`)
- Archive functionality already available (`scores.isArchived`)

### Data Flow
1. **Load**: Query Scores table with JOIN to count usage in Attendances
2. **Display**: Show scores with usage statistics and ordinal order
3. **Edit**: Update Scores table (name, ordinal) - foreign keys handle consistency
4. **Merge**: Update Attendances to point to target score, delete source scores
5. **Validate**: Check constraints and prevent deletion of in-use scores

### Services Needed
- `ScoreService`: Core CRUD operations on Scores table (likely already exists)
- Extend existing service with: merge operation, usage statistics, reordering

## User Experience Flow

### Primary Journey: Edit Score Name
1. User opens Scores Dictionary from Settings
2. User taps edit icon next to score name
3. User modifies the name in inline editor
4. System shows preview of affected records
5. User confirms change
6. System updates all references with loading indicator
7. User sees success message with summary

### Secondary Journey: Merge Duplicate Scores
1. User identifies duplicate scores in list
2. User selects multiple scores (checkboxes appear)
3. User taps "Merge Selected" button
4. System opens merge dialog
5. User chooses target score name
6. User reviews impact preview
7. User confirms merge
8. System performs bulk update
9. User sees merged result in list

## Edge Cases & Validations

### Data Integrity
- Prevent deleting scores that are in use
- Validate score names are not empty
- Prevent duplicate score names
- Handle concurrent edits gracefully

### User Safety
- Show confirmation dialogs for destructive actions
- Provide undo capability for recent changes
- Backup data before major operations
- Show clear impact summaries

### Performance
- Lazy load usage statistics
- Batch database operations
- Show progress indicators for long operations
- Cache frequently accessed data

## Access & Navigation

### Entry Points
- Settings Screen → "Manage Scores" option
- Event Screen → Long press on score → "Edit Score Dictionary"
- Dance Recording Dialog → "Manage Scores" link

### Permissions
- Available to all users (no special permissions needed)
- Changes affect all events and dances

## Future Enhancements
- Import/export score dictionaries
- Score templates for common dance styles
- AI suggestions for score standardization
- Analytics on score usage patterns
- Bulk score assignment tools 