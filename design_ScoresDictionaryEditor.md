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
- **Use Case**: Merge "Great" into "Excellent" 
- **Behavior**:
  - Select source score and target score (two at a time)
  - Show preview of affected dances
  - Update all attendances using source score to use target score
  - Delete the source score

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
│   └── Long press for contextual actions (Rename, Delete, Merge into...)
└── Actions Bar
    ├── Add New Score button
    └── Reset to Defaults button
```

### Contextual Actions
```
Long Press Score → Context Menu
├── Rename Score
│   └── Simple dialog with text input and confirm/cancel
├── Delete Score
│   └── Confirmation dialog showing usage count
└── Merge into...
    └── Shows list of other scores to merge this one into
```

### Merge Scores Dialog
**Navigation**: Context menu "Merge into..." → Select target score → Confirmation dialog
```
Merge Score
├── Source: "[source score name]" (X dances)
├── Target: "[target score name]" (Y dances)
├── Result: "All dances scored '[source]' will become '[target]'"
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
4. **Merge**: Update Attendances.scoreId from source to target, delete source score
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
1. User identifies duplicate score in list
2. User long presses on source score
3. User taps "Merge into..." from context menu
4. User selects target score from list
5. System shows confirmation dialog with impact preview
6. User confirms merge
7. System updates attendances and deletes source score
8. User sees updated list with merged score

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