import 'package:drift/drift.dart';

import '../database/database.dart';
import '../models/import_models.dart';
import '../utils/action_logger.dart';

/// Validator for dancer import data
/// Handles validation, conflict detection, and database checks
class DancerImportValidator {
  final AppDatabase _database;

  DancerImportValidator(this._database);

  /// Validate import data and detect conflicts with existing dancers
  Future<List<DancerImportConflict>> validateImport(
    List<ImportableDancer> dancers,
    DancerImportOptions options,
  ) async {
    ActionLogger.logServiceCall('DancerImportValidator', 'validateImport', {
      'dancerCount': dancers.length,
      'conflictResolution': options.conflictResolution.name,
    });

    final conflicts = <DancerImportConflict>[];

    // Validate individual dancers
    for (final dancer in dancers) {
      final dancerConflicts = await _validateSingleDancer(dancer);
      conflicts.addAll(dancerConflicts);
    }

    // Check for conflicts with existing dancers
    final existingConflicts = await _checkExistingDancerConflicts(dancers);
    conflicts.addAll(existingConflicts);

    // Check for missing tags if not creating them
    if (!options.createMissingTags) {
      final tagConflicts = await _checkMissingTags(dancers);
      conflicts.addAll(tagConflicts);
    }

    ActionLogger.logAction('DancerImportValidator', 'validation_completed', {
      'totalConflicts': conflicts.length,
      'duplicateNames': conflicts.where((c) => c.isDuplicateName).length,
      'validationErrors': conflicts.where((c) => c.isValidationError).length,
    });

    return conflicts;
  }

  /// Validate a single dancer's data
  Future<List<DancerImportConflict>> _validateSingleDancer(
      ImportableDancer dancer) async {
    final conflicts = <DancerImportConflict>[];

    // Validate name
    if (dancer.name.trim().isEmpty) {
      conflicts.add(DancerImportConflict(
        type: ImportConflictType.invalidName,
        dancerName: dancer.name,
        message: 'Dancer name cannot be empty',
        suggestion: 'Provide a valid name for the dancer',
      ));
    } else if (dancer.name.length > 100) {
      conflicts.add(DancerImportConflict(
        type: ImportConflictType.invalidName,
        dancerName: dancer.name,
        message: 'Dancer name too long (max 100 characters)',
        suggestion: 'Shorten the dancer name to 100 characters or less',
      ));
    }

    // Validate tags
    for (final tag in dancer.tags) {
      if (tag.length > 50) {
        conflicts.add(DancerImportConflict(
          type: ImportConflictType.invalidTags,
          dancerName: dancer.name,
          message: 'Tag "$tag" too long (max 50 characters)',
          suggestion: 'Shorten the tag to 50 characters or less',
        ));
      }
      if (tag.trim().isEmpty) {
        conflicts.add(DancerImportConflict(
          type: ImportConflictType.invalidTags,
          dancerName: dancer.name,
          message: 'Empty tag found',
          suggestion: 'Remove empty tags or provide valid tag names',
        ));
      }
    }

    // Validate notes
    if (dancer.notes != null && dancer.notes!.length > 500) {
      conflicts.add(DancerImportConflict(
        type: ImportConflictType.invalidNotes,
        dancerName: dancer.name,
        message: 'Notes too long (max 500 characters)',
        suggestion: 'Shorten the notes to 500 characters or less',
      ));
    }

    return conflicts;
  }

  /// Check for conflicts with existing dancers in the database
  Future<List<DancerImportConflict>> _checkExistingDancerConflicts(
    List<ImportableDancer> dancers,
  ) async {
    final conflicts = <DancerImportConflict>[];

    // Get all existing dancer names from database
    final existingDancers = await (_database.select(_database.dancers)
          ..orderBy([(d) => OrderingTerm.asc(d.name)]))
        .get();

    final existingNames = <String, int>{};
    for (final dancer in existingDancers) {
      existingNames[dancer.name.toLowerCase()] = dancer.id;
    }

    // Check each import dancer against existing ones
    for (final dancer in dancers) {
      final normalizedName = dancer.name.toLowerCase();
      final existingId = existingNames[normalizedName];

      if (existingId != null) {
        conflicts.add(DancerImportConflict(
          type: ImportConflictType.duplicateName,
          dancerName: dancer.name,
          message: 'Dancer with name "${dancer.name}" already exists',
          suggestion: _getDuplicateResolutionSuggestion(),
          existingDancerId: existingId,
        ));
      }
    }

    return conflicts;
  }

  /// Check for missing tags that would be required
  Future<List<DancerImportConflict>> _checkMissingTags(
    List<ImportableDancer> dancers,
  ) async {
    final allTags = <String>{};
    for (final dancer in dancers) {
      allTags.addAll(dancer.tags);
    }

    if (allTags.isEmpty) {
      return [];
    }

    // Get existing tags from database
    final existingTags = await (_database.select(_database.tags)
          ..where((t) => t.name.isIn(allTags.toList())))
        .get();

    final existingTagNames = existingTags.map((t) => t.name).toSet();
    final missingTags = allTags.difference(existingTagNames);

    final conflicts = <DancerImportConflict>[];
    for (final missingTag in missingTags) {
      // Find dancers that use this missing tag
      final dancersWithMissingTag = dancers
          .where((d) => d.tags.any((tag) => tag == missingTag))
          .map((d) => d.name)
          .toList();

      for (final dancerName in dancersWithMissingTag) {
        conflicts.add(DancerImportConflict(
          type: ImportConflictType.invalidTags,
          dancerName: dancerName,
          message: 'Tag "$missingTag" does not exist',
          suggestion: 'Enable "Create missing tags" option or remove the tag',
        ));
      }
    }

    return conflicts;
  }

  /// Get suggestion text for duplicate name resolution
  String _getDuplicateResolutionSuggestion() {
    return 'Choose a conflict resolution strategy: skip duplicates, update existing, or import with suffix';
  }

  /// Validate import options
  List<String> validateImportOptions(DancerImportOptions options) {
    ActionLogger.logServiceCall(
        'DancerImportValidator', 'validateImportOptions');

    final errors = <String>[];

    if (options.maxImportSize <= 0) {
      errors.add('Maximum import size must be greater than 0');
    }

    if (options.maxImportSize > 10000) {
      errors.add('Maximum import size too large (max 10000 dancers)');
    }

    return errors;
  }

  /// Check if a dancer name already exists in the database
  Future<bool> isDancerNameTaken(String name) async {
    ActionLogger.logServiceCall('DancerImportValidator', 'isDancerNameTaken', {
      'name': name,
    });

    final existing = await (_database.select(_database.dancers)
          ..where((d) => d.name.equals(name))
          ..limit(1))
        .getSingleOrNull();

    return existing != null;
  }

  /// Get existing dancer by name
  Future<Dancer?> getExistingDancerByName(String name) async {
    ActionLogger.logServiceCall(
        'DancerImportValidator', 'getExistingDancerByName', {
      'name': name,
    });

    return await (_database.select(_database.dancers)
          ..where((d) => d.name.equals(name))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Generate unique name for dancer with suffix
  Future<String> generateUniqueName(String baseName,
      {int maxAttempts = 100}) async {
    ActionLogger.logServiceCall('DancerImportValidator', 'generateUniqueName', {
      'baseName': baseName,
      'maxAttempts': maxAttempts,
    });

    String candidateName = baseName;
    int suffix = 1;
    int attempts = 0;

    while (attempts < maxAttempts) {
      if (!(await isDancerNameTaken(candidateName))) {
        ActionLogger.logAction(
            'DancerImportValidator', 'unique_name_generated', {
          'baseName': baseName,
          'uniqueName': candidateName,
          'suffix': suffix - 1,
          'attempts': attempts,
        });
        return candidateName;
      }

      candidateName = '$baseName ($suffix)';
      suffix++;
      attempts++;
    }

    // Fallback with timestamp if all attempts failed
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    candidateName = '$baseName ($timestamp)';

    ActionLogger.logAction('DancerImportValidator', 'unique_name_fallback', {
      'baseName': baseName,
      'fallbackName': candidateName,
      'attempts': attempts,
    });

    return candidateName;
  }

  /// Get summary of conflicts by type
  Map<ImportConflictType, int> getConflictSummary(
      List<DancerImportConflict> conflicts) {
    final summary = <ImportConflictType, int>{};

    for (final conflict in conflicts) {
      summary[conflict.type] = (summary[conflict.type] ?? 0) + 1;
    }

    return summary;
  }

  /// Check if import can proceed based on conflicts
  bool canProceedWithImport(
    List<DancerImportConflict> conflicts,
    DancerImportOptions options,
  ) {
    // If there are validation errors, cannot proceed
    final validationErrors =
        conflicts.where((c) => c.isValidationError).toList();
    if (validationErrors.isNotEmpty) {
      return false;
    }

    // If there are duplicate names but no conflict resolution, cannot proceed
    final duplicates = conflicts.where((c) => c.isDuplicateName).toList();
    if (duplicates.isNotEmpty &&
        options.conflictResolution == ConflictResolution.skipDuplicates) {
      return true; // Can proceed by skipping duplicates
    }

    return true;
  }
}
