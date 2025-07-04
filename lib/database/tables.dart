import 'package:drift/drift.dart';

// Events table
class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Dancers table
class Dancers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get firstMetDate => dateTime().nullable()(); // For dancers met before tracked events
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))(); // Archive status flag
  DateTimeColumn get archivedAt => dateTime().nullable()(); // When dancer was archived
}

// Ranks table (dictionary/lookup table)
class Ranks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get ordinal => integer()(); // 1 = best, 5 = worst
  BoolColumn get isArchived =>
      boolean().withDefault(const Constant(false))(); // Archived ranks are hidden from new events
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// Scores table (post-dance rating system)
class Scores extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50).unique()();
  IntColumn get ordinal => integer()(); // 1 = best, 5 = worst (like Ranks)
  BoolColumn get isArchived =>
      boolean().withDefault(const Constant(false))(); // Hide from new events but keep in history
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// Rankings table (event-specific dancer rankings)
class Rankings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eventId => integer().references(Events, #id, onDelete: KeyAction.cascade)();
  IntColumn get dancerId => integer().references(Dancers, #id, onDelete: KeyAction.cascade)();
  IntColumn get rankId => integer().references(Ranks, #id)();
  TextColumn get reason => text().nullable()(); // Optional reason for ranking
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastUpdated => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {eventId, dancerId}, // One ranking per dancer per event
      ];
}

// Attendances table (tracks presence and dance completion)
class Attendances extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eventId => integer().references(Events, #id, onDelete: KeyAction.cascade)();
  IntColumn get dancerId => integer().references(Dancers, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get markedAt => dateTime().withDefault(currentDateAndTime)(); // When spotted at event
  TextColumn get status => text().withDefault(const Constant('present'))(); // present, served, left
  DateTimeColumn get dancedAt => dateTime().nullable()(); // When dance occurred
  TextColumn get impression => text().nullable()(); // Post-dance impression/notes
  IntColumn get scoreId => integer().references(Scores, #id).nullable()(); // Post-dance score assignment

  @override
  List<Set<Column>> get uniqueKeys => [
        {eventId, dancerId}, // One attendance record per dancer per event
      ];
}

// Tags table (for categorizing dancers)
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50).unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Dancer-Tag relationships table (many-to-many)
class DancerTags extends Table {
  IntColumn get dancerId => integer().references(Dancers, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId => integer().references(Tags, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {dancerId, tagId};
}
