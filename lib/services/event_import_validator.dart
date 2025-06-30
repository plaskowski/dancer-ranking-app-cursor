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
      'options': {
        'createMissingDancers': options.createMissingDancers,
        'validateOnly': options.validateOnly,
      },
    });

    final conflicts = <EventImportConflict>[];

    try {
      // Check for duplicate events in database
      final duplicateConflicts = await _checkDuplicateEvents(events, options);
      conflicts.addAll(duplicateConflicts);

      // Check for missing dancers if not auto-creating them
      if (!options.createMissingDancers) {
        final missingDancerConflicts = await _checkMissingDancers(events);
        conflicts.addAll(missingDancerConflicts);
      }

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

    // Cannot proceed with missing dancers if not configured to create them
    final missingDancerConflicts = conflicts
        .where((c) => c.type == EventImportConflictType.missingDancer)
        .toList();
    if (missingDancerConflicts.isNotEmpty && !options.createMissingDancers) {
      ActionLogger.logAction('EventImportValidator.canProceedWithImport',
          'cannot_proceed_missing_dancers', {
        'missingDancersCount': missingDancerConflicts.length,
        'createMissingDancers': options.createMissingDancers,
      });
      return false;
    }

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

  // Check for missing dancers in database
  Future<List<EventImportConflict>> _checkMissingDancers(
    List<ImportableEvent> events,
  ) async {
    final conflicts = <EventImportConflict>[];
    final allDancerNames = <String>{};

    // Collect all unique dancer names from all events
    for (final event in events) {
      for (final attendance in event.attendances) {
        allDancerNames.add(attendance.dancerName);
      }
    }

    // Check which dancers exist in database
    for (final dancerName in allDancerNames) {
      try {
        final existingDancer = await (_database.select(_database.dancers)
              ..where((d) => d.name.equals(dancerName)))
            .getSingleOrNull();

        if (existingDancer == null) {
          conflicts.add(EventImportConflict(
            type: EventImportConflictType.missingDancer,
            dancerName: dancerName,
            message: 'Dancer "$dancerName" does not exist in database',
          ));
        }
      } catch (e) {
        ActionLogger.logError(
            'EventImportValidator._checkMissingDancers', e.toString(), {
          'dancerName': dancerName,
        });
        conflicts.add(EventImportConflict(
          type: EventImportConflictType.invalidData,
          dancerName: dancerName,
          message: 'Failed to check dancer existence: ${e.toString()}',
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
                'Dancer name too long (max 100 characters) in event "${event.name}"',
          ));
        }

        // Validate status
        const validStatuses = ['present', 'served', 'left'];
        if (!validStatuses.contains(attendance.status)) {
          conflicts.add(EventImportConflict(
            type: EventImportConflictType.invalidData,
            eventName: event.name,
            dancerName: attendance.dancerName,
            message:
                'Invalid status "${attendance.status}" for dancer "${attendance.dancerName}". Must be one of: ${validStatuses.join(', ')}',
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

  // Get existing dancers by names (for efficiency)
  Future<Map<String, Dancer>> getExistingDancersByNames(
      Set<String> names) async {
    ActionLogger.logServiceCall(
        'EventImportValidator', 'getExistingDancersByNames', {
      'namesCount': names.length,
    });

    try {
      final dancers = await (_database.select(_database.dancers)
            ..where((d) => d.name.isIn(names.toList())))
          .get();

      final dancerMap = <String, Dancer>{};
      for (final dancer in dancers) {
        dancerMap[dancer.name] = dancer;
      }

      ActionLogger.logAction(
          'EventImportValidator.getExistingDancersByNames', 'dancers_found', {
        'requestedCount': names.length,
        'foundCount': dancerMap.length,
      });

      return dancerMap;
    } catch (e) {
      ActionLogger.logError(
          'EventImportValidator.getExistingDancersByNames', e.toString());
      return {};
    }
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
