import 'package:drift/drift.dart';

import '../database/database.dart';
import '../models/import_models.dart';
import '../utils/action_logger.dart';

class EventImportValidator {
  final AppDatabase _database;

  EventImportValidator(this._database);

  // Validate import data and return conflicts/issues
  Future<List<EventImportConflict>> validateImport(
    List<ImportableEvent> events,
    EventImportOptions options,
  ) async {
    ActionLogger.logServiceCall('EventImportValidator', 'validateImport', {
      'eventsCount': events.length,
      'options': {},
    });

    final conflicts = <EventImportConflict>[];

    try {
      // Check for duplicate events in database
      final duplicateConflicts = await _checkDuplicateEvents(events, options);
      conflicts.addAll(duplicateConflicts);

      // Note: Missing dancers are always auto-created, no conflicts needed

      // Validate business rules
      final businessRuleConflicts = _validateBusinessRules(events);
      conflicts.addAll(businessRuleConflicts);

      ActionLogger.logAction(
          'EventImportValidator.validateImport', 'validation_completed', {
        'conflictsCount': conflicts.length,
        'duplicateEvents': conflicts
            .where((c) => c.type == EventImportConflictType.duplicateEvent)
            .length,
        'missingDancers': conflicts
            .where((c) => c.type == EventImportConflictType.missingDancer)
            .length,
        'invalidData': conflicts
            .where((c) => c.type == EventImportConflictType.invalidData)
            .length,
      });

      return conflicts;
    } catch (e) {
      ActionLogger.logError(
          'EventImportValidator.validateImport', e.toString());
      return [
        EventImportConflict(
          type: EventImportConflictType.invalidData,
          message: 'Validation failed: ${e.toString()}',
        ),
      ];
    }
  }

  // Check if import can proceed with given conflicts and options
  bool canProceedWithImport(
    List<EventImportConflict> conflicts,
    EventImportOptions options,
  ) {
    ActionLogger.logServiceCall(
        'EventImportValidator', 'canProceedWithImport', {
      'conflictsCount': conflicts.length,
    });

    // Cannot proceed if there are invalid data conflicts
    final invalidDataConflicts = conflicts
        .where((c) => c.type == EventImportConflictType.invalidData)
        .toList();
    if (invalidDataConflicts.isNotEmpty) {
      ActionLogger.logAction('EventImportValidator.canProceedWithImport',
          'cannot_proceed_invalid_data', {
        'invalidDataCount': invalidDataConflicts.length,
      });
      return false;
    }

    // Note: Duplicate events are always skipped automatically - no blocking needed

    // Note: Missing dancers are always created automatically - no blocking needed

    ActionLogger.logAction(
        'EventImportValidator.canProceedWithImport', 'can_proceed', {
      'conflictsCount': conflicts.length,
    });

    return true;
  }

  // Check for duplicate events in database
  Future<List<EventImportConflict>> _checkDuplicateEvents(
    List<ImportableEvent> events,
    EventImportOptions options,
  ) async {
    final conflicts = <EventImportConflict>[];

    for (final event in events) {
      try {
        // Check if event with same name and date already exists
        final existingEvent = await (_database.select(_database.events)
              ..where(
                  (e) => e.name.equals(event.name) & e.date.equals(event.date)))
            .getSingleOrNull();

        if (existingEvent != null) {
          conflicts.add(EventImportConflict(
            type: EventImportConflictType.duplicateEvent,
            eventName: event.name,
            message:
                'Event "${event.name}" on ${_formatDate(event.date)} already exists in database',
          ));
        }
      } catch (e) {
        ActionLogger.logError(
            'EventImportValidator._checkDuplicateEvents', e.toString(), {
          'eventName': event.name,
          'eventDate': event.date.toIso8601String(),
        });
        conflicts.add(EventImportConflict(
          type: EventImportConflictType.invalidData,
          eventName: event.name,
          message: 'Failed to check for duplicate event: ${e.toString()}',
        ));
      }
    }

    return conflicts;
  }

  // Validate business rules
  List<EventImportConflict> _validateBusinessRules(
      List<ImportableEvent> events) {
    final conflicts = <EventImportConflict>[];

    for (final event in events) {
      // Validate event data
      if (event.name.trim().isEmpty) {
        conflicts.add(EventImportConflict(
          type: EventImportConflictType.invalidData,
          eventName: event.name,
          message: 'Event name cannot be empty',
        ));
      }

      if (event.name.length > 100) {
        conflicts.add(EventImportConflict(
          type: EventImportConflictType.invalidData,
          eventName: event.name,
          message: 'Event name too long (max 100 characters)',
        ));
      }

      // Validate date is not in future (optional business rule)
      final now = DateTime.now();
      if (event.date.isAfter(now)) {
        // This is a warning, not a blocking error
        ActionLogger.logAction('EventImportValidator._validateBusinessRules',
            'future_event_warning', {
          'eventName': event.name,
          'eventDate': event.date.toIso8601String(),
        });
      }

      // Validate attendances
      final dancerNames = <String>{};
      for (final attendance in event.attendances) {
        // Check for duplicate dancers in same event
        if (dancerNames.contains(attendance.dancerName)) {
          conflicts.add(EventImportConflict(
            type: EventImportConflictType.invalidData,
            eventName: event.name,
            dancerName: attendance.dancerName,
            message:
                'Duplicate attendance for dancer "${attendance.dancerName}" in event "${event.name}"',
          ));
        } else {
          dancerNames.add(attendance.dancerName);
        }

        // Validate dancer name
        if (attendance.dancerName.trim().isEmpty) {
          conflicts.add(EventImportConflict(
            type: EventImportConflictType.invalidData,
            eventName: event.name,
            message: 'Dancer name cannot be empty in event "${event.name}"',
          ));
        }

        if (attendance.dancerName.length > 100) {
          conflicts.add(EventImportConflict(
            type: EventImportConflictType.invalidData,
            eventName: event.name,
            dancerName: attendance.dancerName,
            message:
                'Dancer name too long (max 100 characters): "${attendance.dancerName}"',
          ));
        }

        // Validate score name if provided
        if (attendance.scoreName != null) {
          final scoreName = attendance.scoreName!.trim();
          if (scoreName.isEmpty) {
            conflicts.add(EventImportConflict(
              type: EventImportConflictType.invalidData,
              eventName: event.name,
              dancerName: attendance.dancerName,
              message:
                  'Score name cannot be empty for dancer "${attendance.dancerName}"',
            ));
          } else if (scoreName.length > 50) {
            conflicts.add(EventImportConflict(
              type: EventImportConflictType.invalidData,
              eventName: event.name,
              dancerName: attendance.dancerName,
              message: 'Score name too long (max 50 characters): "$scoreName"',
            ));
          }
        }

        // Validate that scores are only assigned to 'served' status
        if (attendance.scoreName != null && attendance.status != 'served') {
          conflicts.add(EventImportConflict(
            type: EventImportConflictType.invalidData,
            eventName: event.name,
            dancerName: attendance.dancerName,
            message:
                'Score can only be assigned to dancers with "served" status, but dancer has "${attendance.status}" status',
          ));
        }

        // Validate status values
        const validStatuses = ['present', 'served', 'left'];
        if (!validStatuses.contains(attendance.status)) {
          conflicts.add(EventImportConflict(
            type: EventImportConflictType.invalidData,
            eventName: event.name,
            dancerName: attendance.dancerName,
            message:
                'Invalid status "${attendance.status}". Must be one of: ${validStatuses.join(', ')}',
          ));
        }

        // Validate impression length
        if (attendance.impression != null &&
            attendance.impression!.length > 500) {
          conflicts.add(EventImportConflict(
            type: EventImportConflictType.invalidData,
            eventName: event.name,
            dancerName: attendance.dancerName,
            message:
                'Impression too long (max 500 characters) for dancer "${attendance.dancerName}"',
          ));
        }

        // Business rule: impression only meaningful for "served" status
        if (attendance.impression != null &&
            attendance.impression!.isNotEmpty &&
            attendance.status != 'served') {
          // This is a warning, not a blocking error
          ActionLogger.logAction('EventImportValidator._validateBusinessRules',
              'impression_without_served_warning', {
            'eventName': event.name,
            'dancerName': attendance.dancerName,
            'status': attendance.status,
          });
        }
      }
    }

    return conflicts;
  }

  // Helper method to format date for display
  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Get existing dancers by names for validation
  Future<Map<String, Dancer>> getExistingDancersByNames(
      Set<String> dancerNames) async {
    ActionLogger.logServiceCall(
        'EventImportValidator', 'getExistingDancersByNames', {
      'dancerNamesCount': dancerNames.length,
    });

    if (dancerNames.isEmpty) return {};

    final dancers = await (_database.select(_database.dancers)
          ..where((d) => d.name.isIn(dancerNames)))
        .get();

    return {for (final dancer in dancers) dancer.name: dancer};
  }

  // Get existing scores by names for validation
  Future<Map<String, Score>> getExistingScoresByNames(
      Set<String> scoreNames) async {
    ActionLogger.logServiceCall(
        'EventImportValidator', 'getExistingScoresByNames', {
      'scoreNamesCount': scoreNames.length,
    });

    if (scoreNames.isEmpty) return {};

    final scores = await (_database.select(_database.scores)
          ..where((s) => s.name.isIn(scoreNames)))
        .get();

    return {for (final score in scores) score.name: score};
  }

  // Get all unique score names from events
  Set<String> getScoreNamesFromEvents(List<ImportableEvent> events) {
    final scoreNames = <String>{};
    for (final event in events) {
      for (final attendance in event.attendances) {
        if (attendance.scoreName != null &&
            attendance.scoreName!.trim().isNotEmpty) {
          scoreNames.add(attendance.scoreName!.trim());
        }
      }
    }
    return scoreNames;
  }

  // Check for missing scores that need to be created
  Future<Set<String>> getMissingScoreNames(List<ImportableEvent> events) async {
    final allScoreNames = getScoreNamesFromEvents(events);
    if (allScoreNames.isEmpty) return {};

    final existingScores = await getExistingScoresByNames(allScoreNames);
    return allScoreNames
        .where((name) => !existingScores.containsKey(name))
        .toSet();
  }

  // Check if event exists by name and date
  Future<Event?> getEventByNameAndDate(String name, DateTime date) async {
    ActionLogger.logServiceCall(
        'EventImportValidator', 'getEventByNameAndDate', {
      'name': name,
      'date': date.toIso8601String(),
    });

    try {
      return await (_database.select(_database.events)
            ..where((e) => e.name.equals(name) & e.date.equals(date)))
          .getSingleOrNull();
    } catch (e) {
      ActionLogger.logError(
          'EventImportValidator.getEventByNameAndDate', e.toString(), {
        'name': name,
        'date': date.toIso8601String(),
      });
      return null;
    }
  }
}
