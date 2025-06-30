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
              .map((tag) => tag.toLowerCase().trim())
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
