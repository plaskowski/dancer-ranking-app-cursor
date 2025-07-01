/// Data models for dancer import functionality
class ImportableDancer {
  final String name;
  final List<String> tags;
  final String? notes;

  const ImportableDancer({
    required this.name,
    this.tags = const [],
    this.notes,
  });

  factory ImportableDancer.fromJson(Map<String, dynamic> json) {
    return ImportableDancer(
      name: (json['name'] as String).trim(),
      tags: json['tags'] != null
          ? (json['tags'] as List)
              .cast<String>()
              .map((tag) => tag.trim())
              .where((tag) => tag.isNotEmpty)
              .toList()
          : [],
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tags': tags,
      'notes': notes,
    };
  }

  @override
  String toString() =>
      'ImportableDancer(name: $name, tags: $tags, notes: $notes)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImportableDancer &&
        other.name == name &&
        other.tags.length == tags.length &&
        other.tags.every((tag) => tags.contains(tag)) &&
        other.notes == notes;
  }

  @override
  int get hashCode => Object.hash(name, tags, notes);
}

class ImportMetadata {
  final String version;
  final DateTime? createdAt;
  final int? totalCount;
  final String? source;
  final String? description;

  const ImportMetadata({
    required this.version,
    this.createdAt,
    this.totalCount,
    this.source,
    this.description,
  });

  factory ImportMetadata.fromJson(Map<String, dynamic> json) {
    return ImportMetadata(
      version: json['version'] as String? ?? '1.0',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      totalCount: json['total_count'] as int?,
      source: json['source'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (totalCount != null) 'total_count': totalCount,
      if (source != null) 'source': source,
      if (description != null) 'description': description,
    };
  }
}

class DancerImportResult {
  final List<ImportableDancer> dancers;
  final List<String> errors;
  final ImportMetadata? metadata;
  final bool isValid;

  const DancerImportResult({
    required this.dancers,
    required this.errors,
    this.metadata,
    required this.isValid,
  });

  factory DancerImportResult.success({
    required List<ImportableDancer> dancers,
    ImportMetadata? metadata,
  }) {
    return DancerImportResult(
      dancers: dancers,
      errors: [],
      metadata: metadata,
      isValid: true,
    );
  }

  factory DancerImportResult.failure({
    required List<String> errors,
    List<ImportableDancer> dancers = const [],
    ImportMetadata? metadata,
  }) {
    return DancerImportResult(
      dancers: dancers,
      errors: errors,
      metadata: metadata,
      isValid: false,
    );
  }

  bool get hasErrors => errors.isNotEmpty;
  bool get hasWarnings => isValid && errors.isNotEmpty;
}

class DancerImportSummary {
  final int imported;
  final int skipped;
  final int updated;
  final int errors;
  final List<String> errorMessages;
  final List<String> skippedDancers;
  final List<String> updatedDancers;
  final List<String> createdTags;

  const DancerImportSummary({
    required this.imported,
    required this.skipped,
    required this.updated,
    required this.errors,
    required this.errorMessages,
    required this.skippedDancers,
    required this.updatedDancers,
    required this.createdTags,
  });

  int get totalProcessed => imported + skipped + updated + errors;
  bool get hasErrors => errors > 0;
  bool get hasSkipped => skipped > 0;
  bool get hasUpdated => updated > 0;
  bool get isSuccessful => errors == 0;

  @override
  String toString() {
    return 'DancerImportSummary(imported: $imported, skipped: $skipped, updated: $updated, errors: $errors)';
  }
}

enum ConflictResolution {
  skipDuplicates,
  updateExisting,
  importWithSuffix,
}

class DancerImportOptions {
  final ConflictResolution conflictResolution;
  final bool createMissingTags;
  final bool validateOnly;
  final int maxImportSize;

  const DancerImportOptions({
    this.conflictResolution = ConflictResolution.skipDuplicates,
    this.createMissingTags = true,
    this.validateOnly = false,
    this.maxImportSize = 1000,
  });

  DancerImportOptions copyWith({
    ConflictResolution? conflictResolution,
    bool? createMissingTags,
    bool? validateOnly,
    int? maxImportSize,
  }) {
    return DancerImportOptions(
      conflictResolution: conflictResolution ?? this.conflictResolution,
      createMissingTags: createMissingTags ?? this.createMissingTags,
      validateOnly: validateOnly ?? this.validateOnly,
      maxImportSize: maxImportSize ?? this.maxImportSize,
    );
  }
}

enum ImportConflictType {
  duplicateName,
  invalidName,
  invalidTags,
  invalidNotes,
  missingData,
}

class DancerImportConflict {
  final ImportConflictType type;
  final String dancerName;
  final String message;
  final String? suggestion;
  final int? existingDancerId;

  const DancerImportConflict({
    required this.type,
    required this.dancerName,
    required this.message,
    this.suggestion,
    this.existingDancerId,
  });

  bool get isDuplicateName => type == ImportConflictType.duplicateName;
  bool get isValidationError => type != ImportConflictType.duplicateName;

  @override
  String toString() {
    return 'DancerImportConflict(type: $type, dancer: $dancerName, message: $message)';
  }
}

// Event Import Models

class ImportableEvent {
  final String name;
  final DateTime date;
  final List<ImportableAttendance> attendances;

  const ImportableEvent({
    required this.name,
    required this.date,
    this.attendances = const [],
  });

  factory ImportableEvent.fromJson(Map<String, dynamic> json) {
    final dateStr = json['date'] as String;
    final date = DateTime.tryParse(dateStr);
    if (date == null) {
      throw FormatException('Invalid date format: $dateStr');
    }

    final attendancesJson = json['attendances'] as List? ?? [];
    final attendances = attendancesJson
        .map((a) => ImportableAttendance.fromJson(a as Map<String, dynamic>))
        .toList();

    return ImportableEvent(
      name: (json['name'] as String).trim(),
      date: DateTime(date.year, date.month,
          date.day), // Date only, time set to start of day
      attendances: attendances,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date':
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'attendances': attendances.map((a) => a.toJson()).toList(),
    };
  }

  @override
  String toString() =>
      'ImportableEvent(name: $name, date: $date, attendances: ${attendances.length})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImportableEvent &&
        other.name == name &&
        other.date == date &&
        other.attendances.length == attendances.length &&
        other.attendances.every((a) => attendances.contains(a));
  }

  @override
  int get hashCode => Object.hash(name, date, attendances);
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

  factory ImportableAttendance.fromJson(Map<String, dynamic> json) {
    final status = json['status'] as String;
    const validStatuses = ['present', 'served', 'left'];
    if (!validStatuses.contains(status)) {
      throw FormatException(
          'Invalid status: $status. Must be one of: ${validStatuses.join(', ')}');
    }

    return ImportableAttendance(
      dancerName: (json['dancer_name'] as String).trim(),
      status: status,
      impression: json['impression'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dancer_name': dancerName,
      'status': status,
      if (impression != null) 'impression': impression,
    };
  }

  @override
  String toString() =>
      'ImportableAttendance(dancerName: $dancerName, status: $status)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImportableAttendance &&
        other.dancerName == dancerName &&
        other.status == status &&
        other.impression == impression;
  }

  @override
  int get hashCode => Object.hash(dancerName, status, impression);
}

class EventImportResult {
  final List<ImportableEvent> events;
  final List<String> errors;
  final ImportMetadata? metadata;
  final bool isValid;
  final EventImportSummary? summary; // Analysis from a dry run

  const EventImportResult({
    required this.events,
    required this.errors,
    this.metadata,
    required this.isValid,
    this.summary,
  });

  factory EventImportResult.success({
    required List<ImportableEvent> events,
    ImportMetadata? metadata,
    EventImportSummary? summary,
  }) {
    return EventImportResult(
      events: events,
      errors: [],
      metadata: metadata,
      isValid: true,
      summary: summary,
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

  EventImportResult copyWith({
    List<ImportableEvent>? events,
    List<String>? errors,
    ImportMetadata? metadata,
    bool? isValid,
    EventImportSummary? summary,
  }) {
    return EventImportResult(
      events: events ?? this.events,
      errors: errors ?? this.errors,
      metadata: metadata ?? this.metadata,
      isValid: isValid ?? this.isValid,
      summary: summary ?? this.summary,
    );
  }

  bool get hasErrors => errors.isNotEmpty;
  bool get hasWarnings => isValid && errors.isNotEmpty;
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
  final List<EventImportAnalysis> eventAnalyses;

  const EventImportSummary({
    required this.eventsProcessed,
    required this.eventsCreated,
    required this.eventsSkipped,
    required this.attendancesCreated,
    required this.dancersCreated,
    required this.errors,
    required this.errorMessages,
    required this.skippedEvents,
    this.eventAnalyses = const [],
  });

  int get totalSuccessful =>
      eventsCreated + attendancesCreated + dancersCreated;
  bool get hasErrors => errors > 0;
  bool get hasSkipped => eventsSkipped > 0;
  bool get isSuccessful => errors == 0;

  @override
  String toString() {
    return 'EventImportSummary(processed: $eventsProcessed, created: $eventsCreated, skipped: $eventsSkipped, errors: $errors)';
  }
}

class EventImportOptions {
  const EventImportOptions();

  // Note: Duplicate events are always automatically skipped
  // Note: Missing dancers are always automatically created
  // Note: All imports are performed immediately - no validation-only mode
}

enum EventImportConflictType {
  duplicateEvent,
  invalidData,
  missingDancer,
}

class EventImportConflict {
  final EventImportConflictType type;
  final String? eventName;
  final String? dancerName;
  final String message;

  const EventImportConflict({
    required this.type,
    this.eventName,
    this.dancerName,
    required this.message,
  });

  @override
  String toString() => 'EventImportConflict($type: $message)';
}

class EventImportAnalysis {
  final ImportableEvent event;
  final bool isDuplicate;
  final int newDancersCount;
  final List<String> newDancerNames;

  const EventImportAnalysis({
    required this.event,
    this.isDuplicate = false,
    this.newDancersCount = 0,
    this.newDancerNames = const [],
  });

  bool get willBeImported => !isDuplicate;
  bool get hasNewDancers => newDancersCount > 0;
}
