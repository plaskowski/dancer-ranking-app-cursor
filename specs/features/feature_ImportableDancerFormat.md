# Feature: Importable Dancer Format

## Overview
Enable bulk import of dancers from JSON files with support for names, tags, and notes. This feature allows users to import dancer data from external sources or backup files, with smart conflict resolution and validation.

## User Stories

### Primary User Stories
- **As a user**, I want to import dancers from a JSON file so I can quickly populate my dancer database from external sources
- **As a user**, I want to see a preview of import data before applying it so I can verify the information is correct
- **As a user**, I want to handle duplicate dancers gracefully so I don't create unwanted duplicates
- **As a user**, I want missing tags to be created automatically so I don't have to pre-create every tag
- **As a user**, I want to see import progress and results so I know what was imported successfully

### Secondary User Stories
- **As a user**, I want to export my current dancers to JSON format so I can backup or share my data
- **As a user**, I want to update existing dancers during import so I can refresh information from external sources
- **As a user**, I want to validate import data so I can catch errors before they're saved to the database

## JSON Format Specification

### File Structure
```json
{
  "dancers": [
    {
      "name": "Dancer Name",
      "tags": ["tag1", "tag2", "tag3"],
      "notes": "Optional descriptive notes"
    }
  ],
  "metadata": {
    "version": "1.0",
    "created_at": "2024-01-01T12:00:00Z",
    "total_count": 105,
    "source": "Manual export",
    "description": "Dancer data from dance school"
  }
}
```

### Field Specifications
- **name** (required): String, 1-100 characters, dancer's display name
- **tags** (optional): Array of strings, each 1-50 characters, categories/labels for the dancer
- **notes** (optional): String, up to 500 characters, descriptive information about the dancer
- **metadata** (optional): Object containing file information and import context

### Validation Rules
1. **Names**: Must be unique within import file, trimmed, non-empty
2. **Tags**: Fully case-sensitive, duplicates removed per dancer, trimmed
3. **Notes**: Optional, trimmed if provided
4. **File Size**: Reasonable limits (max 1000 dancers per import)

### Example Import File
```json
{
  "dancers": [
    {
      "name": "Agnieszka Borysewicz",
      "tags": ["on2", "Salsa Libre", "promienna"],
      "notes": null
    },
    {
      "name": "Ewelina Jasinska",
      "tags": ["Salsa Libre", "czw. P4"],
      "notes": "mloda blond niebieskooka"
    },
    {
      "name": "Anna Kaliska",
      "tags": ["on2", "MamboTeam"],
      "notes": null
    }
  ],
  "metadata": {
    "version": "1.0",
    "created_at": "2024-12-19T10:30:00Z",
    "total_count": 3,
    "source": "Dance diary conversion"
  }
}
```

## UI/UX Design

### Import Dialog Components
1. **File Selection Area**
   - Drag & drop zone for JSON files
   - File picker button as alternative
   - File validation feedback

2. **Preview Section**
   - Table showing dancers to be imported
   - Conflict indicators (duplicate names, invalid data)
   - Expandable rows for detailed view

3. **Import Options**
   - Conflict resolution strategy:
     - Skip duplicates (default)
     - Update existing dancers
     - Import as new with suffix
   - Tag handling options:
     - Create missing tags automatically (default)
     - Skip dancers with unknown tags

4. **Progress and Results**
   - Progress bar during import
   - Summary of results (imported, skipped, errors)
   - Detailed log of actions taken

### Import Button Location
- **Dancers Screen**: Add "Import" button to app bar next to "Add Dancer"
- **Icon**: `Icons.file_upload` or `Icons.upload_file`
- **Tooltip**: "Import dancers from JSON file"

## Technical Implementation

### Core Components

#### 1. ImportService Class
```dart
class ImportService {
  // Core import functionality
  Future<ImportResult> parseImportFile(String jsonContent);
  Future<ImportSummary> importDancers(List<ImportableDancer> dancers, ImportOptions options);
  
  // Validation and conflict detection
  List<ImportConflict> detectConflicts(List<ImportableDancer> dancers);
  bool validateDancerData(ImportableDancer dancer);
  
  // Tag management
  Future<void> ensureTagsExist(List<String> tagNames);
  Future<List<Tag>> getOrCreateTags(List<String> tagNames);
}
```

#### 2. Data Models
```dart
class ImportableDancer {
  final String name;
  final List<String> tags;
  final String? notes;
}

class ImportResult {
  final List<ImportableDancer> dancers;
  final List<String> errors;
  final ImportMetadata? metadata;
  final bool isValid;
}

class ImportSummary {
  final int imported;
  final int skipped;
  final int updated;
  final int errors;
  final List<String> errorMessages;
}

class ImportOptions {
  final ConflictResolution conflictResolution;
  final bool createMissingTags;
  final bool validateOnly;
}

enum ConflictResolution {
  skipDuplicates,
  updateExisting,
  importWithSuffix
}
```

#### 3. ImportDancersDialog Widget
```dart
class ImportDancersDialog extends StatefulWidget {
  // File selection and validation
  // Preview table with conflict resolution
  // Import progress tracking
  // Results summary
}
```

### Database Operations
- **Atomic Transactions**: All imports wrapped in database transactions
- **Batch Operations**: Efficient bulk inserts for large datasets
- **Conflict Detection**: Query existing dancers by name before import
- **Tag Creation**: Batch create missing tags before dancer import

### Error Handling
- **File Validation**: JSON parsing errors, schema validation
- **Data Validation**: Individual dancer field validation
- **Database Errors**: Constraint violations, connection issues
- **User Feedback**: Clear error messages with resolution suggestions

## User Flow

### Import Process
1. **Initiate Import**
   - User clicks "Import" button on Dancers screen
   - Import dialog opens

2. **File Selection**
   - User selects JSON file via file picker or drag-and-drop
   - File is validated for format and size

3. **Data Preview**
   - Parse JSON and display dancers in table
   - Highlight conflicts (duplicates, validation errors)
   - Show import statistics

4. **Configure Options**
   - User selects conflict resolution strategy
   - Choose tag handling preferences

5. **Execute Import**
   - Show progress bar
   - Process dancers in batches
   - Handle conflicts according to selected strategy

6. **View Results**
   - Display import summary
   - Show any errors or warnings
   - Option to view imported dancers

### Error Scenarios
- **Invalid JSON**: Show parsing error with file line numbers
- **Missing Required Fields**: Highlight problematic entries
- **Duplicate Names**: Show conflict resolution options
- **Database Errors**: Rollback transaction and show error message

## Integration Points

### Existing Services
- **DancerService**: Extend with bulk import methods
- **TagService**: Add batch tag creation functionality
- **Database**: Use existing transaction support

### UI Integration
- **Dancers Screen**: Add import button and refresh after import
- **Add Dancer Dialog**: Could reference import functionality
- **Action Logger**: Track all import operations

### File System Integration
- **File Picker**: Platform-specific file selection
- **File Validation**: MIME type and extension checking
- **Error Handling**: File read/write permissions

## Future Enhancements

### Export Functionality
- Export current dancers to JSON format
- Selective export by tags or date ranges
- Batch export from multiple events

### Advanced Import Features
- Import from CSV files
- Import from other dance apps
- Scheduled imports from external sources
- Import validation rules customization

### Data Management
- Import history tracking
- Rollback capability for imports
- Duplicate detection improvements
- Merge similar dancers functionality

## Success Metrics

### Functional Requirements
- Successfully import valid JSON files
- Handle duplicate dancers appropriately
- Create missing tags automatically
- Provide clear error messages for invalid data
- Maintain database consistency during import

### Performance Requirements
- Import 100+ dancers in under 5 seconds
- Validate files up to 1MB in size
- Responsive UI during import process
- Minimal memory usage for large files

### User Experience Requirements
- Intuitive import process
- Clear preview of import actions
- Helpful error messages
- Progress feedback for long operations
- Confirmation of successful imports 