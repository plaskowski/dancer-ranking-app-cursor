import 'package:drift/drift.dart';
import '../database/database.dart';

class EventService {
  final AppDatabase _database;

  EventService(this._database);

  // Get all events ordered by date (newest first)
  Stream<List<Event>> watchAllEvents() {
    return (_database.select(_database.events)
      ..orderBy([(e) => OrderingTerm.desc(e.date)]))
      .watch();
  }

  // Get a specific event by ID
  Future<Event?> getEvent(int id) {
    return (_database.select(_database.events)
          ..where((e) => e.id.equals(id)))
        .getSingleOrNull();
  }

  // Create a new event
  Future<int> createEvent({required String name, required DateTime date}) {
    return _database.into(_database.events).insert(
      EventsCompanion.insert(
        name: name,
        date: date,
      ),
    );
  }

  // Update an existing event
  Future<bool> updateEvent(int id, {String? name, DateTime? date}) {
    return _database.update(_database.events).replace(
      Event(
        id: id,
        name: name ?? '', // This will be properly handled in the UI
        date: date ?? DateTime.now(), // This will be properly handled in the UI
        createdAt: DateTime.now(), // This will be ignored by update
      ),
    );
  }

  // Delete an event (this will cascade delete rankings and attendances)
  Future<int> deleteEvent(int id) {
    return (_database.delete(_database.events)
          ..where((e) => e.id.equals(id)))
        .go();
  }

  // Get upcoming events (date >= today)
  Stream<List<Event>> watchUpcomingEvents() {
    final today = DateTime.now();
    return (_database.select(_database.events)
      ..where((e) => e.date.isBiggerOrEqualValue(today))
      ..orderBy([(e) => OrderingTerm.asc(e.date)]))
      .watch();
  }

  // Get past events (date < today)
  Stream<List<Event>> watchPastEvents() {
    final today = DateTime.now();
    return (_database.select(_database.events)
      ..where((e) => e.date.isSmallerThanValue(today))
      ..orderBy([(e) => OrderingTerm.desc(e.date)]))
      .watch();
  }

  // Get events count
  Future<int> getEventsCount() async {
    final result = await _database.customSelect(
      'SELECT COUNT(*) as count FROM events',
      readsFrom: {_database.events},
    ).getSingle();
    return result.data['count'] as int;
  }
} 