# Feature: Event Import

## Overview
Enable bulk import of historical event data with attendance information from JSON files. This feature allows users to import event attendance data from external sources like dance diaries, focusing on who was present and who they danced with, without needing pre-event rankings.

## User Stories

### Primary User Stories
- **As a user**, I want to import event attendance data from a JSON file so I can populate my database with historical event information
- **As a user**, I want to see a preview of import data before applying it so I can verify the information is correct
- **As a user**, I want missing dancers to be created automatically so I don't have to pre-create every dancer
- **As a user**, I want to see import progress and results so I know what was imported successfully

## JSON Format Specification

### File Structure
```json
{
  "events": [
    {
      "name": "Salsa Night at Club XYZ",
      "date": "2024-01-15",
      "attendances": [
        {
          "dancer_name": "Agnieszka Borysewicz",
          "status": "served",
          "impression": "Great connection, smooth follower"
        },
        {
          "dancer_name": "Kasia Panterka",
          "status": "present"
        },
        {
          "dancer_name": "Lena 40tka", 
          "status": "left"
        }
      ]
    }
  ],
  "metadata": {
    "version": "1.0",
    "created_at": "2024-01-16T10:00:00Z",
    "total_events": 1,
    "source": "Diary export",
    "description": "Historical event attendance data"
  }
}
```

### Field Specifications

**Event Fields:**
- `name` (required): String, 1-100 characters, event name
- `date` (required): String, YYYY-MM-DD format, event date (time will be set to start of day)
- `attendances` (optional): Array of attendance records

**Attendance Fields:**
- `dancer_name` (required): String, name of the dancer (will be matched against existing dancers)
- `status` (required): String, one of:
  - `"present"`: Dancer was there but didn't dance
  - `"served"`: Danced with this dancer  
  - `"left"`: Dancer left before being asked to dance
- `impression` (optional): String, up to 500 characters, post-dance notes/impression

**Metadata Fields (Optional):**
- `version` (required): String, format version (e.g., "1.0")
- `created_at` (optional): ISO 8601 datetime, when export was created
- `total_events` (optional): Integer, number of events in file
- `source` (optional): String, source of the data (e.g., "Diary export")
- `description` (optional): String, file description

### Minimal Example
```json
{
  "events": [
    {
      "name": "Friday Salsa at LaPlaya",
      "date": "2024-01-12",
      "attendances": [
        {
          "dancer_name": "Agnieszka Borysewicz",
          "status": "served"
        },
        {
          "dancer_name": "Kasia Panterka", 
          "status": "served",
          "impression": "Great energy tonight"
        },
        {
          "dancer_name": "Alona",
          "status": "present"
        }
      ]
    }
  ]
}
```

## Implementation Design

### Database Integration
- **Events Table**: Create events with date-only timestamps (time set to start of day)
- **Attendances Table**: 
  - `marked_at` auto-populated by database default (currentDateAndTime)
  - `danced_at` auto-populated when status is "served" 
  - `status` field maps directly to import status values
  - `impression` field stores optional post-dance notes

### Import Workflow

1. **Parse JSON**: Validate structure and extract events/attendances
2. **Event Processing**:
   - Create new events (skip if event with same name + date already exists)
3. **Dancer Matching**:
   - Match dancers by name (case-insensitive)
   - Automatically create missing dancers
4. **Attendance Creation**:
   - Create attendance records with proper status
   - Handle timestamp auto-population through database defaults

### Validation Rules

1. **Required Fields**: event name, date, dancer_name, status
2. **Status Validation**: Must be one of: "present", "served", "left"
3. **Date Format**: Must be valid YYYY-MM-DD format
4. **Business Logic**: impression only meaningful for "served" status

### Import Behavior

- **Duplicate Events**: Automatically skip events that already exist (same name + date)
- **Missing Dancers**: Automatically create new dancers
- **Fully Automatic**: Zero user intervention needed - all conflicts handled automatically

## Service Architecture

### EventImportService
- **Main orchestrator** for import operations
- Handles file parsing, validation, and database operations
- Manages transactions and rollback on errors

### EventImportParser
- **JSON parsing and validation**
- Extracts events and attendances from JSON structure
- Validates field formats and constraints

### EventImportValidator
- **Basic format validation**
- Validates required fields and data types
- Simple business rule checks

### Integration Points
- **EventService**: Create and update events
- **DancerService**: Match and create dancers
- **AttendanceService**: Create attendance records
- **Database**: Transaction management

## UI Integration

### Import Dialog Flow
1. **File Selection**: Choose JSON file via file picker
2. **Data Preview**: Show events and attendances in table format
3. **Import Execution**: Show progress and process events
4. **Results Summary**: Display import statistics and any errors

### Integration Points
- **Home Screen**: Add import button for events
- **Event Screen**: Refresh data after import
- **Dancers Screen**: Handle new dancer creation during import

## Error Handling

### Parse Errors
- Invalid JSON structure
- Missing required fields
- Invalid date formats
- Unknown status values

### Validation Errors
- Invalid dancer names (empty or too long)
- Basic business rule violations

### Database Errors
- Transaction failures
- Foreign key constraint violations
- Rollback and error reporting

## Future Enhancements

### Export Functionality
- Export current events to JSON format
- Export attendance data for backup
- Selective export by date range

### Advanced Import Features
- Import from CSV files
- Import from other dance apps
- Custom field mapping
- Batch processing for large files

### Data Management
- Import history tracking
- Enhanced duplicate detection

## Testing Strategy

### Unit Tests
- JSON parsing and validation
- Service method functionality
- Database operations

### Integration Tests
- End-to-end import workflow
- Basic error handling paths

### UI Tests
- Import dialog interactions
- Data preview functionality
- Error message display 