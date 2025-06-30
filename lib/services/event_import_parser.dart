import 'dart:convert';

import '../models/import_models.dart';
import '../utils/action_logger.dart';

class EventImportParser {
  // Parse JSON content and return import result
  Future<EventImportResult> parseJsonContent(String jsonContent) async {
    ActionLogger.logServiceCall('EventImportParser', 'parseJsonContent');

    try {
      final json = jsonDecode(jsonContent) as Map<String, dynamic>;

      // Parse metadata if present
      ImportMetadata? metadata;
      if (json.containsKey('metadata')) {
        try {
          metadata = ImportMetadata.fromJson(json['metadata'] as Map<String, dynamic>);
        } catch (e) {
          ActionLogger.logAction('EventImportParser.parseJsonContent', 'metadata_parse_warning', {
            'error': e.toString(),
          });
          // Continue without metadata if parsing fails
        }
      }

      // Parse events
      final eventsJson = json['events'] as List?;
      if (eventsJson == null) {
        return EventImportResult.failure(
          errors: ['Missing required "events" array in JSON'],
          metadata: metadata,
        );
      }

      final events = <ImportableEvent>[];
      final errors = <String>[];

      for (int i = 0; i < eventsJson.length; i++) {
        try {
          final eventJson = eventsJson[i] as Map<String, dynamic>;
          final event = ImportableEvent.fromJson(eventJson);
          events.add(event);
        } catch (e) {
          errors.add('Event ${i + 1}: ${e.toString()}');
          ActionLogger.logAction('EventImportParser.parseJsonContent', 'event_parse_error', {
            'eventIndex': i,
            'error': e.toString(),
          });
        }
      }

      final isValid = errors.isEmpty;

      ActionLogger.logAction('EventImportParser.parseJsonContent', 'parsing_completed', {
        'eventsCount': events.length,
        'errorsCount': errors.length,
        'isValid': isValid,
      });

      return isValid
          ? EventImportResult.success(events: events, metadata: metadata)
          : EventImportResult.failure(
              errors: errors,
              events: events,
              metadata: metadata,
            );
    } catch (e) {
      ActionLogger.logError('EventImportParser.parseJsonContent', e.toString());
      return EventImportResult.failure(
        errors: ['Failed to parse JSON: ${e.toString()}'],
      );
    }
  }

  // Validate JSON file structure without full parsing
  Future<bool> validateJsonStructure(String jsonContent) async {
    ActionLogger.logServiceCall('EventImportParser', 'validateJsonStructure');

    try {
      final json = jsonDecode(jsonContent) as Map<String, dynamic>;

      // Check required top-level structure
      if (!json.containsKey('events')) {
        ActionLogger.logAction('EventImportParser.validateJsonStructure', 'missing_events_array');
        return false;
      }

      final eventsJson = json['events'];
      if (eventsJson is! List) {
        ActionLogger.logAction('EventImportParser.validateJsonStructure', 'events_not_array');
        return false;
      }

      // Check each event has minimal required structure
      for (int i = 0; i < eventsJson.length; i++) {
        final eventJson = eventsJson[i];
        if (eventJson is! Map<String, dynamic>) {
          ActionLogger.logAction('EventImportParser.validateJsonStructure', 'event_not_object', {
            'eventIndex': i,
          });
          return false;
        }

        // Check required event fields
        if (!eventJson.containsKey('name') || !eventJson.containsKey('date')) {
          ActionLogger.logAction('EventImportParser.validateJsonStructure', 'missing_required_fields', {
            'eventIndex': i,
            'hasName': eventJson.containsKey('name'),
            'hasDate': eventJson.containsKey('date'),
          });
          return false;
        }

        // Validate attendances structure if present
        if (eventJson.containsKey('attendances')) {
          final attendancesJson = eventJson['attendances'];
          if (attendancesJson is! List) {
            ActionLogger.logAction('EventImportParser.validateJsonStructure', 'attendances_not_array', {
              'eventIndex': i,
            });
            return false;
          }

          for (int j = 0; j < attendancesJson.length; j++) {
            final attendanceJson = attendancesJson[j];
            if (attendanceJson is! Map<String, dynamic>) {
              ActionLogger.logAction('EventImportParser.validateJsonStructure', 'attendance_not_object', {
                'eventIndex': i,
                'attendanceIndex': j,
              });
              return false;
            }

            // Check required attendance fields
            if (!attendanceJson.containsKey('dancer_name') || !attendanceJson.containsKey('status')) {
              ActionLogger.logAction('EventImportParser.validateJsonStructure', 'attendance_missing_fields', {
                'eventIndex': i,
                'attendanceIndex': j,
                'hasDancerName': attendanceJson.containsKey('dancer_name'),
                'hasStatus': attendanceJson.containsKey('status'),
              });
              return false;
            }
          }
        }
      }

      ActionLogger.logAction('EventImportParser.validateJsonStructure', 'validation_passed', {
        'eventsCount': eventsJson.length,
      });

      return true;
    } catch (e) {
      ActionLogger.logError('EventImportParser.validateJsonStructure', e.toString());
      return false;
    }
  }

  // Get preview information from JSON content
  Future<Map<String, dynamic>> getImportPreview(String jsonContent) async {
    ActionLogger.logServiceCall('EventImportParser', 'getImportPreview');

    try {
      final json = jsonDecode(jsonContent) as Map<String, dynamic>;

      final eventsJson = json['events'] as List? ?? [];
      int totalAttendances = 0;
      final uniqueDancers = <String>{};
      final eventNames = <String>[];

      for (final eventJson in eventsJson) {
        if (eventJson is Map<String, dynamic>) {
          // Collect event name
          final name = eventJson['name'] as String?;
          if (name != null) {
            eventNames.add(name);
          }

          // Count attendances and unique dancers
          final attendancesJson = eventJson['attendances'] as List? ?? [];
          totalAttendances += attendancesJson.length;

          for (final attendanceJson in attendancesJson) {
            if (attendanceJson is Map<String, dynamic>) {
              final dancerName = attendanceJson['dancer_name'] as String?;
              if (dancerName != null) {
                uniqueDancers.add(dancerName.trim());
              }
            }
          }
        }
      }

      final preview = {
        'total_events': eventsJson.length,
        'total_attendances': totalAttendances,
        'unique_dancers': uniqueDancers.length,
        'dancer_names': uniqueDancers.toList()..sort(),
        'event_names': eventNames,
      };

      // Include metadata if present
      if (json.containsKey('metadata')) {
        preview['metadata'] = json['metadata'];
      }

      ActionLogger.logAction('EventImportParser.getImportPreview', 'preview_generated', preview);

      return preview;
    } catch (e) {
      ActionLogger.logError('EventImportParser.getImportPreview', e.toString());
      return {
        'error': 'Failed to generate preview: ${e.toString()}',
        'total_events': 0,
        'total_attendances': 0,
        'unique_dancers': 0,
        'dancer_names': <String>[],
        'event_names': <String>[],
      };
    }
  }
}
