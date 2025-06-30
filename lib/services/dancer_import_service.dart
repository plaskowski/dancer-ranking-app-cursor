import '../database/database.dart';
import '../models/import_models.dart';
import '../utils/action_logger.dart';
import 'dancer_import_parser.dart';
import 'dancer_import_validator.dart';
import 'dancer_service.dart';
import 'tag_service.dart';

/// Main service for dancer import operations
/// Orchestrates parsing, validation, and database operations
class DancerImportService {
  final AppDatabase _database;
  final DancerImportParser _parser;
  final DancerImportValidator _validator;
  final DancerService _dancerService;
  final TagService _tagService;

  DancerImportService(this._database)
      : _parser = DancerImportParser(),
        _validator = DancerImportValidator(_database),
        _dancerService = DancerService(_database),
        _tagService = TagService(_database);

  /// Import dancers from JSON content
  Future<DancerImportSummary> importDancersFromJson(
    String jsonContent,
    DancerImportOptions options,
  ) async {
    ActionLogger.logServiceCall(
        'DancerImportService', 'importDancersFromJson', {
      'contentLength': jsonContent.length,
      'conflictResolution': options.conflictResolution.name,
      'createMissingTags': options.createMissingTags,
      'validateOnly': options.validateOnly,
    });

    final stopwatch = Stopwatch()..start();

    try {
      // Step 1: Parse JSON content
      final parseResult = await _parser.parseJsonContent(jsonContent);
      if (!parseResult.isValid) {
        return DancerImportSummary(
          imported: 0,
          skipped: 0,
          updated: 0,
          errors: parseResult.errors.length,
          errorMessages: parseResult.errors,
          skippedDancers: [],
          updatedDancers: [],
          createdTags: [],
        );
      }

      // Step 2: Validate import data
      final conflicts =
          await _validator.validateImport(parseResult.dancers, options);

      // Step 3: Check if import can proceed
      if (!_validator.canProceedWithImport(conflicts, options)) {
        final validationErrors = conflicts
            .where((c) => c.isValidationError)
            .map((c) => '${c.dancerName}: ${c.message}')
            .toList();

        return DancerImportSummary(
          imported: 0,
          skipped: 0,
          updated: 0,
          errors: validationErrors.length,
          errorMessages: validationErrors,
          skippedDancers: [],
          updatedDancers: [],
          createdTags: [],
        );
      }

      // Step 4: If validate only, return without importing
      if (options.validateOnly) {
        return DancerImportSummary(
          imported: 0,
          skipped: conflicts.where((c) => c.isDuplicateName).length,
          updated: 0,
          errors: conflicts.where((c) => c.isValidationError).length,
          errorMessages:
              conflicts.map((c) => '${c.dancerName}: ${c.message}').toList(),
          skippedDancers: [],
          updatedDancers: [],
          createdTags: [],
        );
      }

      // Step 5: Perform the actual import
      final importSummary =
          await _performImport(parseResult.dancers, conflicts, options);

      stopwatch.stop();
      ActionLogger.logAction('DancerImportService', 'import_completed', {
        'duration_ms': stopwatch.elapsedMilliseconds,
        'imported': importSummary.imported,
        'skipped': importSummary.skipped,
        'updated': importSummary.updated,
        'errors': importSummary.errors,
        'createdTags': importSummary.createdTags.length,
      });

      return importSummary;
    } catch (e) {
      stopwatch.stop();
      ActionLogger.logError(
          'DancerImportService.importDancersFromJson', e.toString());

      return DancerImportSummary(
        imported: 0,
        skipped: 0,
        updated: 0,
        errors: 1,
        errorMessages: ['Import failed: ${e.toString()}'],
        skippedDancers: [],
        updatedDancers: [],
        createdTags: [],
      );
    }
  }

  /// Perform the actual database import operations
  Future<DancerImportSummary> _performImport(
    List<ImportableDancer> dancers,
    List<DancerImportConflict> conflicts,
    DancerImportOptions options,
  ) async {
    ActionLogger.logServiceCall('DancerImportService', '_performImport', {
      'dancerCount': dancers.length,
      'conflictCount': conflicts.length,
    });

    int imported = 0;
    int skipped = 0;
    int updated = 0;
    int errors = 0;
    final errorMessages = <String>[];
    final skippedDancers = <String>[];
    final updatedDancers = <String>[];
    final createdTags = <String>[];

    // Get conflict map for quick lookup
    final conflictMap = <String, DancerImportConflict>{};
    for (final conflict in conflicts) {
      if (conflict.isDuplicateName) {
        conflictMap[conflict.dancerName.toLowerCase()] = conflict;
      }
    }

    // Collect all unique tags from import data
    final allTags = <String>{};
    for (final dancer in dancers) {
      allTags.addAll(dancer.tags.map((tag) => tag.toLowerCase()));
    }

    try {
      await _database.transaction(() async {
        // Step 1: Create missing tags if enabled
        if (options.createMissingTags && allTags.isNotEmpty) {
          final newTags = await _createMissingTags(allTags.toList());
          createdTags.addAll(newTags);
        }

        // Step 2: Process each dancer
        for (final dancer in dancers) {
          try {
            final normalizedName = dancer.name.toLowerCase();
            final conflict = conflictMap[normalizedName];

            if (conflict != null) {
              // Handle conflicting dancer
              final result =
                  await _handleConflictingDancer(dancer, conflict, options);
              switch (result.action) {
                case ImportAction.imported:
                  imported++;
                  break;
                case ImportAction.updated:
                  updated++;
                  updatedDancers.add(result.name ?? dancer.name);
                  break;
                case ImportAction.skipped:
                  skipped++;
                  skippedDancers.add(dancer.name);
                  break;
                case ImportAction.error:
                  errors++;
                  errorMessages
                      .add(result.error ?? 'Unknown error for ${dancer.name}');
                  break;
              }
            } else {
              // Import new dancer
              await _importNewDancer(dancer);
              imported++;
            }
          } catch (e) {
            errors++;
            errorMessages
                .add('Error importing ${dancer.name}: ${e.toString()}');
            ActionLogger.logError(
                'DancerImportService._performImport', e.toString(), {
              'dancerName': dancer.name,
            });
          }
        }
      });
    } catch (e) {
      ActionLogger.logError('DancerImportService._performImport',
          'Transaction failed: ${e.toString()}');
      rethrow;
    }

    return DancerImportSummary(
      imported: imported,
      skipped: skipped,
      updated: updated,
      errors: errors,
      errorMessages: errorMessages,
      skippedDancers: skippedDancers,
      updatedDancers: updatedDancers,
      createdTags: createdTags,
    );
  }

  /// Create missing tags that don't exist in the database
  Future<List<String>> _createMissingTags(List<String> tagNames) async {
    final createdTags = <String>[];

    for (final tagName in tagNames) {
      try {
        final existingTag = await _tagService.getTagByName(tagName);
        if (existingTag == null) {
          await _tagService.createTag(tagName);
          createdTags.add(tagName);
          ActionLogger.logAction('DancerImportService', 'tag_created', {
            'tagName': tagName,
          });
        }
      } catch (e) {
        ActionLogger.logError(
            'DancerImportService._createMissingTags', e.toString(), {
          'tagName': tagName,
        });
        // Continue with other tags even if one fails
      }
    }

    return createdTags;
  }

  /// Handle a dancer that conflicts with existing data
  Future<ImportResult> _handleConflictingDancer(
    ImportableDancer dancer,
    DancerImportConflict conflict,
    DancerImportOptions options,
  ) async {
    switch (options.conflictResolution) {
      case ConflictResolution.skipDuplicates:
        return ImportResult(action: ImportAction.skipped);

      case ConflictResolution.updateExisting:
        if (conflict.existingDancerId != null) {
          await _updateExistingDancer(conflict.existingDancerId!, dancer);
          return ImportResult(action: ImportAction.updated, name: dancer.name);
        } else {
          return ImportResult(
            action: ImportAction.error,
            error: 'Cannot update: existing dancer ID not found',
          );
        }

      case ConflictResolution.importWithSuffix:
        final uniqueName = await _validator.generateUniqueName(dancer.name);
        final uniqueDancer = ImportableDancer(
          name: uniqueName,
          tags: dancer.tags,
          notes: dancer.notes,
        );
        await _importNewDancer(uniqueDancer);
        return ImportResult(action: ImportAction.imported, name: uniqueName);
    }
  }

  /// Import a new dancer to the database
  Future<void> _importNewDancer(ImportableDancer dancer) async {
    // Create the dancer
    final dancerId = await _dancerService.createDancer(
      name: dancer.name,
      notes: dancer.notes,
    );

    // Add tags if any
    if (dancer.tags.isNotEmpty) {
      await _addTagsToDancer(dancerId, dancer.tags);
    }

    ActionLogger.logAction('DancerImportService', 'dancer_imported', {
      'dancerId': dancerId,
      'name': dancer.name,
      'tagCount': dancer.tags.length,
    });
  }

  /// Update an existing dancer with import data
  Future<void> _updateExistingDancer(
      int dancerId, ImportableDancer importData) async {
    // Update dancer basic info
    await _dancerService.updateDancer(
      dancerId,
      name: importData.name,
      notes: importData.notes,
    );

    // Update tags - replace all existing tags with new ones
    if (importData.tags.isNotEmpty) {
      // Remove existing tags
      await _removeAllDancerTags(dancerId);
      // Add new tags
      await _addTagsToDancer(dancerId, importData.tags);
    }

    ActionLogger.logAction('DancerImportService', 'dancer_updated', {
      'dancerId': dancerId,
      'name': importData.name,
      'tagCount': importData.tags.length,
    });
  }

  /// Add tags to a dancer
  Future<void> _addTagsToDancer(int dancerId, List<String> tagNames) async {
    for (final tagName in tagNames) {
      try {
        final tag = await _tagService.getTagByName(tagName);
        if (tag != null) {
          await _tagService.addTagToDancer(dancerId, tag.id);
        }
      } catch (e) {
        ActionLogger.logError(
            'DancerImportService._addTagsToDancer', e.toString(), {
          'dancerId': dancerId,
          'tagName': tagName,
        });
        // Continue with other tags
      }
    }
  }

  /// Remove all tags from a dancer
  Future<void> _removeAllDancerTags(int dancerId) async {
    try {
      await (_database.delete(_database.dancerTags)
            ..where((dt) => dt.dancerId.equals(dancerId)))
          .go();
    } catch (e) {
      ActionLogger.logError(
          'DancerImportService._removeAllDancerTags', e.toString(), {
        'dancerId': dancerId,
      });
    }
  }

  /// Validate import file without importing
  Future<DancerImportResult> validateImportFile(String jsonContent) async {
    ActionLogger.logServiceCall('DancerImportService', 'validateImportFile');
    return await _parser.parseJsonContent(jsonContent);
  }

  /// Get import preview information
  Future<Map<String, dynamic>> getImportPreview(String jsonContent) async {
    ActionLogger.logServiceCall('DancerImportService', 'getImportPreview');
    return await _parser.getImportPreview(jsonContent);
  }
}

/// Internal result class for import operations
class ImportResult {
  final ImportAction action;
  final String? name;
  final String? error;

  ImportResult({
    required this.action,
    this.name,
    this.error,
  });
}

enum ImportAction {
  imported,
  updated,
  skipped,
  error,
}
