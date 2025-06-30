# Event Import Services - Design Document

## Overview
This document outlines the architectural design for the event import service layer, focusing on component relationships, interfaces, data flow, and key architectural decisions.

## Service Architecture

### 1. EventImportService (Main Orchestrator)

**Purpose**: Main service that orchestrates the entire import process, manages transactions, and coordinates between parser, validator, and database services.

```dart
class EventImportService {
  final AppDatabase _database;
  final EventImportParser _parser;
  final EventImportValidator _validator;
  final EventService _eventService;
  final DancerService _dancerService;
  final AttendanceService _attendanceService;

  EventImportService(this._database)
      : _parser = EventImportParser(),
        _validator = EventImportValidator(_database),
        _eventService = EventService(_database),
        _dancerService = DancerService(_database),
        _attendanceService = AttendanceService(_database);

  // Main import method
  Future<EventImportSummary> importEventsFromJson(
    String jsonContent,
    EventImportOptions options,
  ) async;

  // Validate import file without importing
  Future<EventImportResult> validateImportFile(String jsonContent) async;

  // Get import preview information
  Future<Map<String, dynamic>> getImportPreview(String jsonContent) async;
}
```

**Key Methods:**

```dart
// Primary import workflow
Future<EventImportSummary> importEventsFromJson(
  String jsonContent,
  EventImportOptions options,
) async {
  // 1. Parse JSON content
  // 2. Validate data
  // 3. Process events in transaction
  // 4. Return summary
}

// Preview without importing
Future<EventImportResult> validateImportFile(String jsonContent) async {
  return await _parser.parseJsonContent(jsonContent);
}

// Quick preview stats
Future<Map<String, dynamic>> getImportPreview(String jsonContent) async {
  return await _parser.getImportPreview(jsonContent);
}
```

### 2. EventImportParser

**Purpose**: Handles JSON parsing, data extraction, and basic format validation.

```dart
class EventImportParser {
  // Parse JSON content and return import result
  Future<EventImportResult> parseJsonContent(String jsonContent) async;

  // Validate JSON file structure without full parsing
  Future<bool> validateJsonStructure(String jsonContent) async;

  // Get preview information from JSON content
  Future<Map<String, dynamic>> getImportPreview(String jsonContent) async;
}
```

**Responsibilities:**
- JSON structure validation (required fields, data types)
- Data extraction and transformation to domain models
- Basic format validation (date formats, field lengths)
- Error collection and reporting

### 3. EventImportValidator

**Purpose**: Validates parsed data against business rules and database constraints.

```dart
class EventImportValidator {
  final AppDatabase _database;

  EventImportValidator(this._database);

  // Validate import data and return conflicts/issues
  Future<List<ImportConflict>> validateImport(
    List<ImportableEvent> events,
    EventImportOptions options,
  ) async;

  // Check if import can proceed
  bool canProceedWithImport(
    List<ImportConflict> conflicts,
    EventImportOptions options,
  );
}
```

**Responsibilities:**
- Database constraint validation (duplicate events, field lengths) 
- Business rule enforcement (status values, data relationships)
- Conflict detection and classification
- Import feasibility assessment

## Data Models

### Import Models

```dart
class ImportableEvent {
  final String name;
  final DateTime date;
  final List<ImportableAttendance> attendances;

  const ImportableEvent({
    required this.name,
    required this.date,
    this.attendances = const [],
  });
}

class ImportableAttendance {
  final String dancerName;
  final String status; // 'present', 'served', 'left'
  final String? impression;

  const ImportableAttendance({
    required this.dancerName,
    required this.status,
    this.impression,
  });
}

class ImportMetadata {
  final String version;
  final DateTime? createdAt;
  final int? totalEvents;
  final String? source;
  final String? description;

  const ImportMetadata({
    required this.version,
    this.createdAt,
    this.totalEvents,
    this.source,
    this.description,
  });

  factory ImportMetadata.fromJson(Map<String, dynamic> json) {
    return ImportMetadata(
      version: json['version'] as String? ?? '1.0',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      totalEvents: json['total_events'] as int?,
      source: json['source'] as String?,
      description: json['description'] as String?,
    );
  }
}
```

### Result Models

```dart
class EventImportResult {
  final List<ImportableEvent> events;
  final List<String> errors;
  final ImportMetadata? metadata;
  final bool isValid;

  const EventImportResult({
    required this.events,
    required this.errors,
    this.metadata,
    required this.isValid,
  });

  factory EventImportResult.success({
    required List<ImportableEvent> events,
    ImportMetadata? metadata,
  }) {
    return EventImportResult(
      events: events,
      errors: [],
      metadata: metadata,
      isValid: true,
    );
  }

  factory EventImportResult.failure({
    required List<String> errors,
    List<ImportableEvent> events = const [],
    ImportMetadata? metadata,
  }) {
    return EventImportResult(
      events: events,
      errors: errors,
      metadata: metadata,
      isValid: false,
    );
  }
}

class EventImportSummary {
  final int eventsProcessed;
  final int eventsCreated;
  final int eventsSkipped;
  final int attendancesCreated;
  final int dancersCreated;
  final int errors;
  final List<String> errorMessages;
  final List<String> skippedEvents;

  EventImportSummary({
    required this.eventsProcessed,
    required this.eventsCreated,
    required this.eventsSkipped,
    required this.attendancesCreated,
    required this.dancersCreated,
    required this.errors,
    required this.errorMessages,
    required this.skippedEvents,
  });
}

class EventImportOptions {
  final bool createMissingDancers;
  final bool skipDuplicateEvents;
  final bool validateOnly;

  const EventImportOptions({
    this.createMissingDancers = true,
    this.skipDuplicateEvents = true,
    this.validateOnly = false,
  });
}
```

### Conflict Models

```dart
enum ConflictType {
  duplicateEvent,
  invalidData,
}

class ImportConflict {
  final ConflictType type;
  final String? eventName;
  final String? dancerName;
  final String message;

  ImportConflict({
    required this.type,
    this.eventName,
    this.dancerName,
    required this.message,
  });
}
```

## Integration with Existing Services

### Required Service Extensions
- **EventService**: Add `getEventByNameAndDate()` method for duplicate detection
- **DancerService**: Add `getDancerByName()` and `createDancerIfNotExists()` methods 
- **AttendanceService**: Use existing methods for creating attendance records

## Data Flow

```
JSON File → Parser → Domain Models → Validator → Import Service → Database
    ↓           ↓          ↓            ↓             ↓
   Parse    Transform   Validate    Orchestrate   Persist
   Errors   Errors      Conflicts   Transaction   Results
```

## Key Architectural Decisions

### Transaction Management
- All operations within single database transaction
- Automatic rollback on any critical error
- Continue processing other events if individual event fails

### Error Handling Strategy
- **Parse Errors**: Stop processing, return to user
- **Validation Errors**: Collect all issues, block invalid data only
- **Database Errors**: Rollback transaction, preserve data integrity
- **Individual Failures**: Log and continue with remaining events

### Performance Considerations
- **Batch Processing**: Process attendances in configurable batches
- **Bulk Operations**: Pre-fetch existing dancers to minimize queries
- **Memory Management**: Stream processing for large files

### Integration Patterns
- **Dependency Injection**: Services injected via constructor
- **Existing Patterns**: Follow DancerImportService architecture
- **Action Logging**: Integrate with existing ActionLogger system 