import 'dart:convert';

import '../models/import_models.dart';
import '../utils/action_logger.dart';

/// Parser for dancer import JSON files
/// Handles JSON parsing and data extraction with validation
class DancerImportParser {
  /// Parse JSON content and return import result
  Future<DancerImportResult> parseJsonContent(String jsonContent) async {
    ActionLogger.logServiceCall('DancerImportParser', 'parseJsonContent', {
      'contentLength': jsonContent.length,
    });

    try {
      final Map<String, dynamic> jsonData = json.decode(jsonContent);
      return await _parseJsonData(jsonData);
    } catch (e) {
      ActionLogger.logError(
          'DancerImportParser.parseJsonContent', e.toString());
      return DancerImportResult.failure(
        errors: ['Invalid JSON format: ${e.toString()}'],
      );
    }
  }

  /// Parse JSON data and extract dancers and metadata
  Future<DancerImportResult> _parseJsonData(
      Map<String, dynamic> jsonData) async {
    final errors = <String>[];
    final dancers = <ImportableDancer>[];
    ImportMetadata? metadata;

    // Validate file structure
    if (!jsonData.containsKey('dancers')) {
      errors.add('Missing required "dancers" array in JSON file');
      return DancerImportResult.failure(errors: errors);
    }

    // Parse metadata if present
    if (jsonData.containsKey('metadata')) {
      try {
        metadata = ImportMetadata.fromJson(
            jsonData['metadata'] as Map<String, dynamic>);
        ActionLogger.logAction('DancerImportParser', 'metadata_parsed', {
          'version': metadata.version,
          'totalCount': metadata.totalCount,
          'source': metadata.source,
        });
      } catch (e) {
        errors.add('Error parsing metadata: ${e.toString()}');
      }
    }

    // Parse dancers array
    final dancersData = jsonData['dancers'];
    if (dancersData is! List) {
      errors.add('"dancers" must be an array');
      return DancerImportResult.failure(errors: errors, metadata: metadata);
    }

    // Validate file size limit
    if (dancersData.length > 1000) {
      errors.add(
          'Import file too large. Maximum 1000 dancers allowed, found ${dancersData.length}');
      return DancerImportResult.failure(errors: errors, metadata: metadata);
    }

    // Parse individual dancers
    for (int i = 0; i < dancersData.length; i++) {
      try {
        final dancerData = dancersData[i];
        if (dancerData is! Map<String, dynamic>) {
          errors.add('Dancer at index $i is not a valid object');
          continue;
        }

        final dancer = _parseSingleDancer(dancerData, i);
        if (dancer != null) {
          dancers.add(dancer);
        } else {
          errors.add('Failed to parse dancer at index $i');
        }
      } catch (e) {
        errors.add('Error parsing dancer at index $i: ${e.toString()}');
      }
    }

    // Validate metadata total count matches actual count
    if (metadata?.totalCount != null &&
        metadata!.totalCount != dancers.length) {
      errors.add(
          'Metadata total_count (${metadata.totalCount}) does not match actual dancer count (${dancers.length})');
    }

    // Check for duplicate names within the import file
    final duplicateErrors = _checkDuplicateNames(dancers);
    errors.addAll(duplicateErrors);

    ActionLogger.logAction('DancerImportParser', 'parsing_completed', {
      'totalDancers': dancers.length,
      'errorCount': errors.length,
      'isValid': errors.isEmpty && dancers.isNotEmpty,
    });

    return DancerImportResult(
      dancers: dancers,
      errors: errors,
      metadata: metadata,
      isValid: errors.isEmpty && dancers.isNotEmpty,
    );
  }

  /// Parse a single dancer from JSON data
  ImportableDancer? _parseSingleDancer(
      Map<String, dynamic> dancerData, int index) {
    try {
      // Validate required fields
      if (!dancerData.containsKey('name')) {
        throw Exception('Missing required field "name"');
      }

      final name = dancerData['name'];
      if (name is! String) {
        throw Exception('Field "name" must be a string');
      }

      final trimmedName = name.trim();
      if (trimmedName.isEmpty) {
        throw Exception('Field "name" cannot be empty');
      }

      if (trimmedName.length > 100) {
        throw Exception('Field "name" too long (max 100 characters)');
      }

      // Parse tags
      List<String> tags = [];
      if (dancerData.containsKey('tags') && dancerData['tags'] != null) {
        final tagsData = dancerData['tags'];
        if (tagsData is List) {
          tags = tagsData
              .map((tag) => tag.toString().trim())
              .where((tag) => tag.isNotEmpty)
              .toSet() // Remove duplicates
              .toList();

          // Validate tag lengths
          for (final tag in tags) {
            if (tag.length > 50) {
              throw Exception('Tag "$tag" too long (max 50 characters)');
            }
          }
        } else {
          throw Exception('Field "tags" must be an array');
        }
      }

      // Parse notes
      String? notes;
      if (dancerData.containsKey('notes') && dancerData['notes'] != null) {
        final notesData = dancerData['notes'];
        if (notesData is String) {
          notes = notesData.trim();
          if (notes.isEmpty) {
            notes = null;
          } else if (notes.length > 500) {
            throw Exception('Field "notes" too long (max 500 characters)');
          }
        } else {
          throw Exception('Field "notes" must be a string');
        }
      }

      return ImportableDancer(
        name: trimmedName,
        tags: tags,
        notes: notes,
      );
    } catch (e) {
      ActionLogger.logError(
          'DancerImportParser._parseSingleDancer', e.toString(), {
        'index': index,
        'dancerData': dancerData.toString(),
      });
      return null;
    }
  }

  /// Check for duplicate dancer names within the import file
  List<String> _checkDuplicateNames(List<ImportableDancer> dancers) {
    final errors = <String>[];
    final namesSeen = <String>{};
    final duplicateNames = <String>{};

    for (final dancer in dancers) {
      final normalizedName = dancer.name.toLowerCase();
      if (namesSeen.contains(normalizedName)) {
        duplicateNames.add(dancer.name);
      } else {
        namesSeen.add(normalizedName);
      }
    }

    if (duplicateNames.isNotEmpty) {
      for (final name in duplicateNames) {
        errors.add('Duplicate dancer name in import file: "$name"');
      }
    }

    return errors;
  }

  /// Validate JSON file structure without full parsing
  Future<bool> validateJsonStructure(String jsonContent) async {
    ActionLogger.logServiceCall('DancerImportParser', 'validateJsonStructure');

    try {
      final jsonData = json.decode(jsonContent);

      // Check basic structure
      if (jsonData is! Map<String, dynamic>) {
        return false;
      }

      if (!jsonData.containsKey('dancers')) {
        return false;
      }

      if (jsonData['dancers'] is! List) {
        return false;
      }

      ActionLogger.logAction('DancerImportParser', 'structure_validation', {
        'isValid': true,
        'dancersCount': (jsonData['dancers'] as List).length,
      });

      return true;
    } catch (e) {
      ActionLogger.logError(
          'DancerImportParser.validateJsonStructure', e.toString());
      return false;
    }
  }

  /// Get preview information from JSON content without full parsing
  Future<Map<String, dynamic>> getImportPreview(String jsonContent) async {
    ActionLogger.logServiceCall('DancerImportParser', 'getImportPreview');

    try {
      final jsonData = json.decode(jsonContent);
      final dancers = jsonData['dancers'] as List;
      final metadata = jsonData['metadata'] as Map<String, dynamic>?;

      final preview = {
        'dancerCount': dancers.length,
        'hasMetadata': metadata != null,
        'estimatedSizeKB': (jsonContent.length / 1024).round(),
      };

      if (metadata != null) {
        preview.addAll({
          'version': metadata['version'],
          'source': metadata['source'],
          'totalCount': metadata['total_count'],
        });
      }

      ActionLogger.logAction(
          'DancerImportParser', 'preview_generated', preview);
      return preview;
    } catch (e) {
      ActionLogger.logError(
          'DancerImportParser.getImportPreview', e.toString());
      return {
        'error': e.toString(),
        'dancerCount': 0,
        'hasMetadata': false,
        'estimatedSizeKB': 0,
      };
    }
  }
}
