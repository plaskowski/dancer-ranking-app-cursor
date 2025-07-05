# Feature: Extract Historical Dance Record as One-Time Person

## Overview
Allow users to extract a specific historical dance record from a dancer's history and create a new one-time person entry. This is useful when you realize that a dance record actually belongs to a different person than the current dancer profile.

## Use Case
- User views a dancer's history and notices a dance record that doesn't belong to this dancer
- User wants to move that specific dance record to a new one-time person entry
- This preserves the historical data while correcting the attribution

## User Flow

### 1. Access Point
- **Location**: Dancer History Screen
- **Trigger**: Regular tap on any dance record (attendance entry)
- **Action**: Context menu appears with "Extract as One-Time Person" option

### 2. Confirmation Dialog
- **Purpose**: Confirm the extraction action
- **Content**:
  - "Extract this dance record as a new one-time person?"
  - Show dance details (event name, date, impression, score)
  - Warning: "This will remove the record from [DancerName]'s history"
- **Actions**:
  - Cancel
  - Extract (primary action)

### 3. One-Time Person Creation
- **Process**: 
  - Create new dancer entry with name "[OriginalDancerName] - [EventName]"
  - Copy the specific attendance record to the new dancer
  - Remove the attendance record from the original dancer
  - Preserve all other data (impression, score, etc.)

### 4. Success Feedback
- **Toast Message**: "Dance record extracted as one-time person"
- **UI Update**: History screen refreshes to show updated records

## Technical Implementation

### Database Operations
1. **Create New Dancer**:
   ```sql
   INSERT INTO dancers (name, notes, firstMetDate, createdAt)
   VALUES ('[OriginalDancerName] - [EventName]', 'Extracted from [OriginalDancerName]', [EventDate], NOW())
   ```

2. **Copy Attendance Record**:
   ```sql
   INSERT INTO attendances (eventId, dancerId, markedAt, status, dancedAt, impression, scoreId)
   SELECT eventId, [newDancerId], markedAt, status, dancedAt, impression, scoreId
   FROM attendances WHERE id = [originalAttendanceId]
   ```

3. **Delete Original Record**:
   ```sql
   DELETE FROM attendances WHERE id = [originalAttendanceId]
   ```

### UI Components

#### 1. Context Menu Enhancement
- **File**: `lib/screens/dancer_history_screen.dart`
- **Modification**: Add "Separate record" option to tap menu
- **Condition**: Only show for attendance records (not for ranking records)

#### 2. Confirmation Dialog
- **Component**: New `ExtractDanceRecordDialog` widget
- **Features**:
  - Show dance details clearly
  - Warning about data removal
  - Loading state during extraction
  - Error handling

#### 3. Service Layer
- **File**: New `lib/services/dancer/dancer_extraction_service.dart`
- **Methods**:
  - `extractDanceRecordAsOneTimePerson(int attendanceId, String originalDancerName)`
  - Handle all database operations in transaction
  - Return success/failure with error details

### Data Flow
1. User taps dance record
2. Context menu shows "Extract as One-Time Person"
3. User selects option
4. Confirmation dialog appears
5. User confirms extraction
6. Service creates new dancer and moves attendance record
7. UI updates to reflect changes
8. Success toast shown

## Error Handling

### Potential Issues
1. **Database Transaction Failure**: Rollback all changes, show error
2. **Duplicate Dancer Names**: Handle gracefully with unique naming
3. **Missing Event Data**: Validate event exists before extraction
4. **Permission Issues**: Handle database access errors

### Error Messages
- "Failed to extract dance record. Please try again."
- "Event data not found. Cannot extract this record."
- "Database error occurred. Changes not saved."

## Success Criteria
- [ ] User can tap any dance record in dancer history
- [ ] Context menu shows "Extract as One-Time Person" option
- [ ] Confirmation dialog shows relevant dance details
- [ ] Extraction creates new dancer with appropriate name
- [ ] Original dance record is removed from source dancer
- [ ] UI updates immediately after successful extraction
- [ ] Error handling works for all failure scenarios
- [ ] Audit logging tracks all extraction operations

## Future Enhancements
- **Bulk Extraction**: Allow extracting multiple dance records at once
- **Custom Names**: Let user specify the one-time person's name
- **Undo Feature**: Allow reversing the extraction within a time window
- **Merge Suggestions**: Suggest merging the new one-time person with existing dancers

## Implementation Priority
1. **Phase 1**: Basic extraction functionality (current scope)
2. **Phase 2**: Enhanced error handling and validation
3. **Phase 3**: UI polish and user experience improvements
4. **Phase 4**: Advanced features (bulk extraction, custom names) 