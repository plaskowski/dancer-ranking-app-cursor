import '../database/database.dart';
import '../models/import_models.dart';
import '../utils/action_logger.dart';
import 'attendance_service.dart';
import 'dancer_service.dart';
import 'event_import_parser.dart';
import 'event_import_validator.dart';
import 'event_service.dart';
import 'score_service.dart';

class EventImportService {
  final AppDatabase _database;
  final EventImportParser _parser;
  final EventImportValidator _validator;
  final EventService _eventService;
  final DancerService _dancerService;
  final AttendanceService _attendanceService;
  final ScoreService _scoreService;

  EventImportService(this._database)
      : _parser = EventImportParser(),
        _validator = EventImportValidator(_database),
        _eventService = EventService(_database),
        _dancerService = DancerService(_database),
        _attendanceService = AttendanceService(_database),
        _scoreService = ScoreService(_database);

  // Main import method
  Future<EventImportSummary> importEventsFromJson(
    String jsonContent,
    EventImportOptions options,
  ) async {
    ActionLogger.logServiceCall('EventImportService', 'importEventsFromJson', {
      'jsonLength': jsonContent.length,
      'options': {},
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

      // Step 3: Perform import
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
  Future<EventImportResult> parseAndValidateFile(String jsonContent) async {
    ActionLogger.logServiceCall('EventImportService', 'parseAndValidateFile');
    final result = await _parser.parseJsonContent(jsonContent);

    if (result.isValid) {
      // Perform a dry run to get the summary
      final conflicts = await _validator.validateImport(
          result.events, const EventImportOptions());
      final summary = await _getImportSummary(result.events, conflicts);

      ActionLogger.logAction('EventImportService', 'dry_run_complete', {
        'events': summary.eventsProcessed,
        'dancers': summary.dancersCreated,
      });

      return result.copyWith(summary: summary);
    }

    return result;
  }

  Future<EventImportSummary> _getImportSummary(
      List<ImportableEvent> events, List<EventImportConflict> conflicts) async {
    int eventsToCreate = 0;
    int eventsToSkip = 0;
    int attendancesToCreate = 0;
    int scoreAssignments = 0;
    final List<EventImportAnalysis> eventAnalyses = [];

    final duplicateEventNames = conflicts
        .where((c) => c.type == EventImportConflictType.duplicateEvent)
        .map((c) => c.eventName)
        .where((name) => name != null)
        .cast<String>()
        .toSet();

    final allDancerNamesInImport =
        events.expand((e) => e.attendances.map((a) => a.dancerName)).toSet();
    final existingDancers =
        await _validator.getExistingDancersByNames(allDancerNamesInImport);
    final allNewDancersInImport = allDancerNamesInImport
        .where((name) => !existingDancers.containsKey(name))
        .toSet();

    // Analyze scores
    final allScoreNames = _validator.getScoreNamesFromEvents(events);
    final existingScores =
        await _validator.getExistingScoresByNames(allScoreNames);
    final missingScoreNames = await _validator.getMissingScoreNames(events);

    // Count score assignments (only for served status dancers)
    for (final event in events) {
      if (!duplicateEventNames.contains(event.name)) {
        for (final attendance in event.attendances) {
          if (attendance.scoreName != null &&
              attendance.status == 'served' &&
              attendance.scoreName!.trim().isNotEmpty) {
            scoreAssignments++;
          }
        }
      }
    }

    for (final event in events) {
      final isDuplicate = duplicateEventNames.contains(event.name);
      final newDancerNamesInEvent = event.attendances
          .map((a) => a.dancerName)
          .where((name) => allNewDancersInImport.contains(name))
          .toSet()
          .toList();

      eventAnalyses.add(EventImportAnalysis(
        event: event,
        isDuplicate: isDuplicate,
        newDancersCount: newDancerNamesInEvent.length,
        newDancerNames: newDancerNamesInEvent,
      ));

      if (isDuplicate) {
        eventsToSkip++;
        continue;
      }
      eventsToCreate++;
      attendancesToCreate += event.attendances.length;
    }

    return EventImportSummary(
      eventsProcessed: events.length,
      eventsCreated: eventsToCreate,
      eventsSkipped: eventsToSkip,
      attendancesCreated: attendancesToCreate,
      dancersCreated: allNewDancersInImport.length,
      scoresCreated: missingScoreNames.length,
      scoreAssignments: scoreAssignments,
      errors: 0,
      errorMessages: [],
      skippedEvents: duplicateEventNames.toList(),
      createdScoreNames: missingScoreNames.toList(),
      eventAnalyses: eventAnalyses,
    );
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
    int scoresCreated = 0;
    int scoreAssignments = 0;
    final errorMessages = <String>[];
    final skippedEvents = <String>[];
    final createdScoreNames = <String>[];

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

    // Pre-fetch existing scores and identify missing ones
    final allScoreNames = _validator.getScoreNamesFromEvents(events);
    final existingScores =
        await _validator.getExistingScoresByNames(allScoreNames);
    final missingScoreNames = await _validator.getMissingScoreNames(events);

    try {
      await _database.transaction(() async {
        // Create missing scores first
        for (final scoreName in missingScoreNames) {
          try {
            // Auto-assign ordinal based on existing scores count + position in missing list
            final existingCount = (await _scoreService.getAllScores()).length;
            final ordinal = existingCount +
                missingScoreNames.toList().indexOf(scoreName) +
                1;

            final scoreId = await _scoreService.createScore(
              name: scoreName,
              ordinal: ordinal,
            );

            // Update our local cache
            final newScore = await _scoreService.getScore(scoreId);
            if (newScore != null) {
              existingScores[scoreName] = newScore;
              createdScoreNames.add(scoreName);
              scoresCreated++;

              ActionLogger.logAction(
                  'EventImportService._performImport', 'score_created', {
                'scoreId': scoreId,
                'scoreName': scoreName,
                'ordinal': ordinal,
              });
            }
          } catch (e) {
            final errorMsg =
                'Failed to create score "$scoreName": ${e.toString()}';
            errorMessages.add(errorMsg);
            ActionLogger.logError(
                'EventImportService._performImport', errorMsg);
          }
        }

        // Process each event
        for (final event in events) {
          try {
            // Skip duplicate events (always done automatically)
            if (duplicateEventNames.contains(event.name)) {
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
                // Get or create dancer (always create missing dancers)
                Dancer? dancer = existingDancers[attendance.dancerName];
                if (dancer == null) {
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

                // Assign score if provided and status is 'served'
                if (attendance.scoreName != null &&
                    attendance.status == 'served' &&
                    attendance.scoreName!.trim().isNotEmpty) {
                  final scoreName = attendance.scoreName!.trim();
                  final score = existingScores[scoreName];

                  if (score != null) {
                    try {
                      await _attendanceService.assignScore(
                          eventId, dancer.id, score.id);
                      scoreAssignments++;

                      ActionLogger.logAction(
                          'EventImportService._performImport',
                          'score_assigned', {
                        'eventId': eventId,
                        'dancerId': dancer.id,
                        'scoreId': score.id,
                        'scoreName': scoreName,
                      });
                    } catch (e) {
                      final errorMsg =
                          'Failed to assign score "$scoreName" to dancer "${attendance.dancerName}": ${e.toString()}';
                      errorMessages.add(errorMsg);
                      ActionLogger.logError(
                          'EventImportService._performImport', errorMsg);
                    }
                  } else {
                    // Score not found even after creation attempt
                    final errorMsg =
                        'Score "$scoreName" not found for dancer "${attendance.dancerName}" at event "${event.name}"';
                    errorMessages.add(errorMsg);
                    ActionLogger.logError(
                        'EventImportService._performImport', errorMsg);
                  }
                }

                ActionLogger.logAction(
                    'EventImportService._performImport', 'attendance_created', {
                  'eventId': eventId,
                  'dancerId': dancer.id,
                  'dancerName': attendance.dancerName,
                  'status': attendance.status,
                  'hasScore': attendance.scoreName != null,
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
        scoresCreated: scoresCreated,
        scoreAssignments: scoreAssignments,
        errors: errorMessages.length,
        errorMessages: errorMessages,
        skippedEvents: skippedEvents,
        createdScoreNames: createdScoreNames,
      );

      ActionLogger.logAction(
          'EventImportService._performImport', 'import_completed', {
        'eventsProcessed': summary.eventsProcessed,
        'eventsCreated': summary.eventsCreated,
        'eventsSkipped': summary.eventsSkipped,
        'attendancesCreated': summary.attendancesCreated,
        'dancersCreated': summary.dancersCreated,
        'scoresCreated': summary.scoresCreated,
        'scoreAssignments': summary.scoreAssignments,
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
        scoresCreated: scoresCreated,
        scoreAssignments: scoreAssignments,
        errors: errorMessages.length + 1,
        errorMessages: [
          ...errorMessages,
          'Transaction failed: ${e.toString()}'
        ],
        skippedEvents: skippedEvents,
        createdScoreNames: createdScoreNames,
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
