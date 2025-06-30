import 'package:drift/drift.dart';

import '../database/database.dart';
import '../utils/action_logger.dart';

class EventService {
  final AppDatabase _database;

  EventService(this._database);

  // Get all events ordered by date (newest first)
  Stream<List<Event>> watchAllEvents() {
    ActionLogger.logServiceCall('EventService', 'watchAllEvents');

    return (_database.select(_database.events)
          ..orderBy([(e) => OrderingTerm.desc(e.date)]))
        .watch();
  }

  // Get a specific event by ID
  Future<Event?> getEvent(int id) {
    ActionLogger.logServiceCall('EventService', 'getEvent', {'eventId': id});

    return (_database.select(_database.events)..where((e) => e.id.equals(id)))
        .getSingleOrNull();
  }

  // Create a new event
  Future<int> createEvent(
      {required String name, required DateTime date}) async {
    ActionLogger.logServiceCall('EventService', 'createEvent', {
      'name': name,
      'date': date.toIso8601String(),
    });

    try {
      final id = await _database.into(_database.events).insert(
            EventsCompanion.insert(
              name: name,
              date: date,
            ),
          );

      ActionLogger.logDbOperation('INSERT', 'events', {
        'id': id,
        'name': name,
        'date': date.toIso8601String(),
      });

      return id;
    } catch (e) {
      ActionLogger.logError('EventService.createEvent', e.toString(), {
        'name': name,
        'date': date.toIso8601String(),
      });
      rethrow;
    }
  }

  // Update an existing event
  Future<bool> updateEvent(int id, {String? name, DateTime? date}) async {
    ActionLogger.logServiceCall('EventService', 'updateEvent', {
      'eventId': id,
      'hasName': name != null,
      'hasDate': date != null,
    });

    try {
      // Get current event to preserve unchanged fields
      final currentEvent = await getEvent(id);
      if (currentEvent == null) {
        ActionLogger.logAction('EventService.updateEvent', 'event_not_found', {
          'eventId': id,
        });
        return false;
      }

      final result = await _database.update(_database.events).replace(
            Event(
              id: id,
              name: name ?? currentEvent.name,
              date: date ?? currentEvent.date,
              createdAt: currentEvent.createdAt,
            ),
          );

      ActionLogger.logDbOperation('UPDATE', 'events', {
        'id': id,
        'oldName': currentEvent.name,
        'newName': name ?? currentEvent.name,
        'oldDate': currentEvent.date.toIso8601String(),
        'newDate': (date ?? currentEvent.date).toIso8601String(),
        'success': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError('EventService.updateEvent', e.toString(), {
        'eventId': id,
        'name': name,
        'date': date?.toIso8601String(),
      });
      rethrow;
    }
  }

  // Delete an event (this will cascade delete rankings and attendances)
  Future<int> deleteEvent(int id) async {
    ActionLogger.logServiceCall('EventService', 'deleteEvent', {'eventId': id});

    try {
      final result = await (_database.delete(_database.events)
            ..where((e) => e.id.equals(id)))
          .go();

      ActionLogger.logDbOperation('DELETE', 'events', {
        'id': id,
        'affected_rows': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError('EventService.deleteEvent', e.toString(), {
        'eventId': id,
      });
      rethrow;
    }
  }

  // Get upcoming events (date >= today)
  Stream<List<Event>> watchUpcomingEvents() {
    ActionLogger.logServiceCall('EventService', 'watchUpcomingEvents');

    final today = DateTime.now();
    return (_database.select(_database.events)
          ..where((e) => e.date.isBiggerOrEqualValue(today))
          ..orderBy([(e) => OrderingTerm.asc(e.date)]))
        .watch();
  }

  // Get past events (date < today)
  Stream<List<Event>> watchPastEvents() {
    ActionLogger.logServiceCall('EventService', 'watchPastEvents');

    final today = DateTime.now();
    return (_database.select(_database.events)
          ..where((e) => e.date.isSmallerThanValue(today))
          ..orderBy([(e) => OrderingTerm.desc(e.date)]))
        .watch();
  }

  // Get events count
  Future<int> getEventsCount() async {
    ActionLogger.logServiceCall('EventService', 'getEventsCount');

    try {
      final query = _database.selectOnly(_database.events)
        ..addColumns([_database.events.id.count()]);

      final result = await query.getSingle();
      final count = result.read(_database.events.id.count()) ?? 0;

      ActionLogger.logAction('EventService.getEventsCount', 'count_retrieved', {
        'count': count,
      });

      return count;
    } catch (e) {
      ActionLogger.logError('EventService.getEventsCount', e.toString());
      rethrow;
    }
  }
}
