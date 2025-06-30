import '../database/database.dart';
import '../models/import_models.dart';
import '../utils/action_logger.dart';
import 'attendance_service.dart';
import 'dancer_service.dart';
import 'event_import_parser.dart';
import 'event_import_validator.dart';
import 'event_service.dart';

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
  ) async {
    ActionLogger.logServiceCall('EventImportService', 'importEventsFromJson', {
      'jsonLength': jsonContent.length,
      'options': {
        'createMissingDancers': options.createMissingDancers,
        'skipDuplicateEvents': options.skipDuplicateEvents,
        'validateOnly': options.validateOnly,
      },
    });

    try {
      // Step 1: Parse JSON content
      final parseResult = await _parser.parseJsonContent(jsonContent);
      if (!parseResult.isValid) {
        return EventImportSummary(
          eventsProcessed: 0,
          eventsCreated: 0,
          eventsSkipped: 0,
          attendancesCreated: 0,
          dancersCreated: 0,
          errors: parseResult.errors.length,
          errorMessages: parseResult.errors,
          skippedEvents: [],
        );
      }

      // Step 2: Validate data
      final conflicts =
          await _validator.validateImport(parseResult.events, options);
      if (!_validator.canProceedWithImport(conflicts, options)) {
        final errorMessages = conflicts.map((c) => c.message).toList();
        return EventImportSummary(
          eventsProcessed: parseResult.events.length,
          eventsCreated: 0,
          eventsSkipped: 0,
          attendancesCreated: 0,
          dancersCreated: 0,
          errors: errorMessages.length,
          errorMessages: errorMessages,
          skippedEvents: [],
        );
      }

      // Step 3: If validate only, return summary without importing
      if (options.validateOnly) {
        final skippedDuplicates = conflicts
            .where((c) => c.type == EventImportConflictType.duplicateEvent)
            .map((c) => c.eventName ?? 'Unknown event')
            .toList();

        return EventImportSummary(
          eventsProcessed: parseResult.events.length,
          eventsCreated: parseResult.events.length - skippedDuplicates.length,
          eventsSkipped: skippedDuplicates.length,
          attendancesCreated: _countTotalAttendances(parseResult.events),
          dancersCreated: await _countMissingDancers(parseResult.events),
          errors: 0,
          errorMessages: [],
          skippedEvents: skippedDuplicates,
        );
      }

      // Step 4: Perform actual import
      return await _performImport(parseResult.events, options, conflicts);
    } catch (e) {
      ActionLogger.logError(
          'EventImportService.importEventsFromJson', e.toString());
      return EventImportSummary(
        eventsProcessed: 0,
        eventsCreated: 0,
        eventsSkipped: 0,
        attendancesCreated: 0,
        dancersCreated: 0,
        errors: 1,
        errorMessages: ['Import failed: ${e.toString()}'],
        skippedEvents: [],
      );
    }
  }

  // Validate import file without importing
  Future<EventImportResult> validateImportFile(String jsonContent) async {
    ActionLogger.logServiceCall('EventImportService', 'validateImportFile');
    return await _parser.parseJsonContent(jsonContent);
  }

  // Get import preview information
  Future<Map<String, dynamic>> getImportPreview(String jsonContent) async {
    ActionLogger.logServiceCall('EventImportService', 'getImportPreview');
    return await _parser.getImportPreview(jsonContent);
  }

  // Perform the actual import process
  Future<EventImportSummary> _performImport(
    List<ImportableEvent> events,
    EventImportOptions options,
    List<EventImportConflict> conflicts,
  ) async {
    ActionLogger.logServiceCall('EventImportService', '_performImport', {
      'eventsCount': events.length,
    });

    int eventsCreated = 0;
    int eventsSkipped = 0;
    int attendancesCreated = 0;
    int dancersCreated = 0;
    final errorMessages = <String>[];
    final skippedEvents = <String>[];

    // Get duplicate events to skip
    final duplicateEventNames = conflicts
        .where((c) => c.type == EventImportConflictType.duplicateEvent)
        .map((c) => c.eventName)
        .where((name) => name != null)
        .cast<String>()
        .toSet();

    // Pre-fetch existing dancers for efficiency
    final allDancerNames =
        events.expand((e) => e.attendances.map((a) => a.dancerName)).toSet();
    final existingDancers =
        await _validator.getExistingDancersByNames(allDancerNames);

    try {
      await _database.transaction(() async {
        // Process each event
        for (final event in events) {
          try {
            // Skip duplicate events if configured
            if (duplicateEventNames.contains(event.name) &&
                options.skipDuplicateEvents) {
              skippedEvents.add(event.name);
              eventsSkipped++;
              ActionLogger.logAction(
                  'EventImportService._performImport', 'event_skipped', {
                'eventName': event.name,
                'reason': 'duplicate',
              });
              continue;
            }

            // Create event
            final eventId = await _eventService.createEvent(
              name: event.name,
              date: event.date,
            );
            eventsCreated++;

            ActionLogger.logAction(
                'EventImportService._performImport', 'event_created', {
              'eventId': eventId,
              'eventName': event.name,
              'eventDate': event.date.toIso8601String(),
            });

            // Process attendances
            for (final attendance in event.attendances) {
              try {
                // Get or create dancer
                Dancer? dancer = existingDancers[attendance.dancerName];
                if (dancer == null && options.createMissingDancers) {
                  final dancerId = await _dancerService.createDancer(
                      name: attendance.dancerName);
                  dancer = await _dancerService.getDancer(dancerId);
                  if (dancer != null) {
                    existingDancers[attendance.dancerName] = dancer;
                    dancersCreated++;
                  }
                }

                if (dancer == null) {
                  errorMessages.add(
                      'Dancer "${attendance.dancerName}" not found for event "${event.name}"');
                  continue;
                }

                // Create attendance record based on status
                if (attendance.status == 'present') {
                  await _attendanceService.markPresent(eventId, dancer.id);
                } else if (attendance.status == 'left') {
                  await _attendanceService.markPresent(eventId, dancer.id);
                  await _attendanceService.markAsLeft(eventId, dancer.id);
                } else if (attendance.status == 'served') {
                  await _attendanceService.recordDance(
                    eventId: eventId,
                    dancerId: dancer.id,
                    impression: attendance.impression,
                  );
                }

                attendancesCreated++;

                ActionLogger.logAction(
                    'EventImportService._performImport', 'attendance_created', {
                  'eventId': eventId,
                  'dancerId': dancer.id,
                  'dancerName': attendance.dancerName,
                  'status': attendance.status,
                });
              } catch (e) {
                final errorMsg =
                    'Failed to create attendance for "${attendance.dancerName}" at "${event.name}": ${e.toString()}';
                errorMessages.add(errorMsg);
                ActionLogger.logError(
                    'EventImportService._performImport', errorMsg);
              }
            }
          } catch (e) {
            final errorMsg =
                'Failed to import event "${event.name}": ${e.toString()}';
            errorMessages.add(errorMsg);
            ActionLogger.logError(
                'EventImportService._performImport', errorMsg);
          }
        }
      });

      final summary = EventImportSummary(
        eventsProcessed: events.length,
        eventsCreated: eventsCreated,
        eventsSkipped: eventsSkipped,
        attendancesCreated: attendancesCreated,
        dancersCreated: dancersCreated,
        errors: errorMessages.length,
        errorMessages: errorMessages,
        skippedEvents: skippedEvents,
      );

      ActionLogger.logAction(
          'EventImportService._performImport', 'import_completed', {
        'eventsProcessed': summary.eventsProcessed,
        'eventsCreated': summary.eventsCreated,
        'eventsSkipped': summary.eventsSkipped,
        'attendancesCreated': summary.attendancesCreated,
        'dancersCreated': summary.dancersCreated,
        'errors': summary.errors,
      });

      return summary;
    } catch (e) {
      ActionLogger.logError('EventImportService._performImport', e.toString());
      return EventImportSummary(
        eventsProcessed: events.length,
        eventsCreated: eventsCreated,
        eventsSkipped: eventsSkipped,
        attendancesCreated: attendancesCreated,
        dancersCreated: dancersCreated,
        errors: errorMessages.length + 1,
        errorMessages: [
          ...errorMessages,
          'Transaction failed: ${e.toString()}'
        ],
        skippedEvents: skippedEvents,
      );
    }
  }

  // Count total attendances across all events
  int _countTotalAttendances(List<ImportableEvent> events) {
    return events.fold(0, (sum, event) => sum + event.attendances.length);
  }

  // Count missing dancers that would need to be created
  Future<int> _countMissingDancers(List<ImportableEvent> events) async {
    final allDancerNames =
        events.expand((e) => e.attendances.map((a) => a.dancerName)).toSet();

    final existingDancers =
        await _validator.getExistingDancersByNames(allDancerNames);
    return allDancerNames.length - existingDancers.length;
  }

  // Check if JSON file structure is valid
  Future<bool> validateJsonStructure(String jsonContent) async {
    ActionLogger.logServiceCall('EventImportService', 'validateJsonStructure');
    return await _parser.validateJsonStructure(jsonContent);
  }

  // Get detailed validation results with conflicts
  Future<Map<String, dynamic>> getDetailedValidation(
    String jsonContent,
    EventImportOptions options,
  ) async {
    ActionLogger.logServiceCall('EventImportService', 'getDetailedValidation');

    try {
      // Parse first
      final parseResult = await _parser.parseJsonContent(jsonContent);
      if (!parseResult.isValid) {
        return {
          'isValid': false,
          'parseErrors': parseResult.errors,
          'conflicts': <Map<String, dynamic>>[],
          'canProceed': false,
        };
      }

      // Validate
      final conflicts =
          await _validator.validateImport(parseResult.events, options);
      final canProceed = _validator.canProceedWithImport(conflicts, options);

      return {
        'isValid': parseResult.isValid,
        'parseErrors': parseResult.errors,
        'conflicts': conflicts
            .map((c) => {
                  'type': c.type.toString(),
                  'eventName': c.eventName,
                  'dancerName': c.dancerName,
                  'message': c.message,
                })
            .toList(),
        'canProceed': canProceed,
        'eventsCount': parseResult.events.length,
        'totalAttendances': _countTotalAttendances(parseResult.events),
        'missingDancersCount': await _countMissingDancers(parseResult.events),
      };
    } catch (e) {
      ActionLogger.logError(
          'EventImportService.getDetailedValidation', e.toString());
      return {
        'isValid': false,
        'parseErrors': ['Validation failed: ${e.toString()}'],
        'conflicts': <Map<String, dynamic>>[],
        'canProceed': false,
      };
    }
  }
}
