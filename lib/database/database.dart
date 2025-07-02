import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Events, Dancers, Ranks, Rankings, Attendances, Tags, DancerTags, Scores])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Testing constructor
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();

          // Insert default ranks
          await _insertDefaultRanks();

          // Insert default tags
          await _insertDefaultTags();

          // Insert default scores
          await _insertDefaultScores();

          // Insert sample events for easier testing
          await _insertSampleEvents();

          // Insert sample dancers for easier testing
          await _insertSampleDancers();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            // Migration from v1 to v2: Replace hasDanced boolean with status text field
            await _migrateToStatusField(m);
          }
          if (from < 3) {
            // Migration from v2 to v3: Add new fields to Ranks table
            await _migrateRanksTable(m);
          }
          if (from < 4) {
            // Migration from v3 to v4: Add Tags and DancerTags tables
            await _addTagsTables(m);
          }
          if (from < 5) {
            // Migration from v4 to v5: Add Scores table and enhance Attendances/Dancers tables
            await _addScoresAndEnhanceTables(m);
          }
        },
      );

  // Migration helper to convert hasDanced boolean to status field
  Future<void> _migrateToStatusField(Migrator m) async {
    // For this migration, we'll recreate the attendances table with the new schema
    // First, create a temporary table with old data
    await customStatement('''
      CREATE TABLE attendances_temp AS 
      SELECT id, event_id, dancer_id, marked_at, 
             CASE WHEN has_danced = 1 THEN 'served' ELSE 'present' END as status,
             danced_at, impression
      FROM attendances
    ''');

    // Drop the old table
    await customStatement('DROP TABLE attendances');

    // Create the new table with the updated schema
    await m.createTable(attendances);

    // Copy data back from temp table
    await customStatement('''
      INSERT INTO attendances (id, event_id, dancer_id, marked_at, status, danced_at, impression)
      SELECT id, event_id, dancer_id, marked_at, status, danced_at, impression
      FROM attendances_temp
    ''');

    // Drop the temporary table
    await customStatement('DROP TABLE attendances_temp');
  }

  // Migration helper to add new fields to Ranks table
  Future<void> _migrateRanksTable(Migrator m) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    // Add new columns to existing ranks table
    await customStatement('ALTER TABLE ranks ADD COLUMN is_archived INTEGER NOT NULL DEFAULT 0');
    await customStatement('ALTER TABLE ranks ADD COLUMN created_at INTEGER NOT NULL DEFAULT $now');
    await customStatement('ALTER TABLE ranks ADD COLUMN updated_at INTEGER NOT NULL DEFAULT $now');

    // Update existing ranks to have proper timestamps
    await customStatement('UPDATE ranks SET created_at = $now, updated_at = $now WHERE created_at = $now');
  }

  // Migration helper to add Tags and DancerTags tables
  Future<void> _addTagsTables(Migrator m) async {
    await m.createTable(tags);
    await m.createTable(dancerTags);

    // Insert default tags
    await _insertDefaultTags();
  }

  // Migration helper to add Scores table and enhance Attendances/Dancers tables
  Future<void> _addScoresAndEnhanceTables(Migrator m) async {
    // Create the new scores table
    await m.createTable(scores);

    // Add new columns to attendances table
    await customStatement('ALTER TABLE attendances ADD COLUMN score_id INTEGER REFERENCES scores(id)');

    // Add new column to dancers table
    await customStatement('ALTER TABLE dancers ADD COLUMN first_met_date INTEGER');

    // Insert default scores
    await _insertDefaultScores();
  }

  // Insert contextual tags related to specific places/events where you know dancers from
  Future<void> _insertDefaultTags() async {
    await batch((batch) {
      batch.insertAll(tags, [
        TagsCompanion.insert(name: 'Monday Class'),
        TagsCompanion.insert(name: 'Cuban DC Festival'),
        TagsCompanion.insert(name: 'Friday Social'),
      ]);
    });
  }

  // Insert minimal essential scores
  Future<void> _insertDefaultScores() async {
    await batch((batch) {
      batch.insertAll(scores, [
        ScoresCompanion.insert(
          name: 'Good',
          ordinal: 1,
        ),
        ScoresCompanion.insert(
          name: 'Okay',
          ordinal: 2,
        ),
        ScoresCompanion.insert(
          name: 'Poor',
          ordinal: 3,
        ),
      ]);
    });
  }

  // Insert sample events with different dates for testing
  Future<void> _insertSampleEvents() async {
    final now = DateTime.now();

    await batch((batch) {
      batch.insertAll(events, [
        // Past event (1 week ago)
        EventsCompanion.insert(
          name: 'Salsa Night at Cuban Bar',
          date: now.subtract(const Duration(days: 7)),
        ),
        // Recent past event (yesterday)
        EventsCompanion.insert(
          name: 'Weekend Social Dance',
          date: now.subtract(const Duration(days: 1)),
        ),
        // Future event (next week)
        EventsCompanion.insert(
          name: 'Monthly Bachata Workshop',
          date: now.add(const Duration(days: 7)),
        ),
        // Future event (next month)
        EventsCompanion.insert(
          name: 'Summer Salsa Festival',
          date: now.add(const Duration(days: 21)),
        ),
      ]);
    });
  }

  // Insert practical ranking options
  Future<void> _insertDefaultRanks() async {
    await batch((batch) {
      batch.insertAll(ranks, [
        RanksCompanion.insert(
          name: 'Really want to dance!',
          ordinal: 1,
        ),
        RanksCompanion.insert(
          name: 'Would like to dance',
          ordinal: 2,
        ),
        RanksCompanion.insert(
          name: 'Maybe later',
          ordinal: 3,
        ),
        RanksCompanion.insert(
          name: 'Not interested',
          ordinal: 4,
        ),
      ]);
    });
  }

  // Insert sample dancers with different tag combinations for testing
  Future<void> _insertSampleDancers() async {
    // Insert sample dancers individually to get their IDs
    final aliceId = await into(dancers).insert(DancersCompanion.insert(
      name: 'Alice Rodriguez',
      notes: const Value('Great leader, loves salsa'),
    ));

    final bobId = await into(dancers).insert(DancersCompanion.insert(
      name: 'Bob Martinez',
      notes: const Value('Excellent follower, bachata specialist'),
    ));

    final carlosId = await into(dancers).insert(DancersCompanion.insert(
      name: 'Carlos Thompson',
      notes: const Value('New to partner dancing'),
    ));

    final dianaId = await into(dancers).insert(DancersCompanion.insert(
      name: 'Diana Chang',
      notes: const Value('Festival regular, loves complex patterns'),
    ));

    final elenaId = await into(dancers).insert(DancersCompanion.insert(
      name: 'Elena Volkov',
      notes: const Value('Social dancer, great energy'),
    ));

    final frankId = await into(dancers).insert(DancersCompanion.insert(
      name: 'Frank Kim',
      notes: const Value('Monday class student'),
    ));

    final graceId = await into(dancers).insert(DancersCompanion.insert(
      name: 'Grace Wilson',
      notes: const Value('Attends multiple venues'),
    ));

    // Get the tag IDs for tag assignments
    final mondayClassTag = await (select(tags)..where((t) => t.name.equals('Monday Class'))).getSingle();
    final festivalTag = await (select(tags)..where((t) => t.name.equals('Cuban DC Festival'))).getSingle();
    final socialTag = await (select(tags)..where((t) => t.name.equals('Friday Social'))).getSingle();

    // Assign tags to dancers for variety in testing
    await batch((batch) {
      batch.insertAll(dancerTags, [
        // Alice: Monday Class + Friday Social (multi-venue)
        DancerTagsCompanion.insert(dancerId: aliceId, tagId: mondayClassTag.id),
        DancerTagsCompanion.insert(dancerId: aliceId, tagId: socialTag.id),

        // Bob: Cuban DC Festival only (festival dancer)
        DancerTagsCompanion.insert(dancerId: bobId, tagId: festivalTag.id),

        // Carlos: Monday Class only (class student)
        DancerTagsCompanion.insert(dancerId: carlosId, tagId: mondayClassTag.id),

        // Diana: Cuban DC Festival + Friday Social (festival + social)
        DancerTagsCompanion.insert(dancerId: dianaId, tagId: festivalTag.id),
        DancerTagsCompanion.insert(dancerId: dianaId, tagId: socialTag.id),

        // Elena: Friday Social only (social dancer)
        DancerTagsCompanion.insert(dancerId: elenaId, tagId: socialTag.id),

        // Frank: Monday Class only (class student)
        DancerTagsCompanion.insert(dancerId: frankId, tagId: mondayClassTag.id),

        // Grace: All three tags (attends everywhere)
        DancerTagsCompanion.insert(dancerId: graceId, tagId: mondayClassTag.id),
        DancerTagsCompanion.insert(dancerId: graceId, tagId: festivalTag.id),
        DancerTagsCompanion.insert(dancerId: graceId, tagId: socialTag.id),
      ]);
    });
  }

  /// Resets the database by clearing all user data and restoring essential defaults
  Future<void> resetDatabase() async {
    await transaction(() async {
      // Clear all user data tables (in order to respect foreign key constraints)
      await delete(attendances).go();
      await delete(rankings).go();
      await delete(dancerTags).go();
      await delete(dancers).go();
      await delete(events).go();

      // Clear dictionary tables but restore defaults (app requires these to function)
      await delete(ranks).go();
      await delete(tags).go();
      await delete(scores).go();

      // Restore essential default data that the app expects to exist
      await _insertDefaultRanks();
      await _insertDefaultTags();
      await _insertDefaultScores();

      // Restore sample data for easier testing
      await _insertSampleEvents();
      await _insertSampleDancers();
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'dancer_ranking.db'));
    return NativeDatabase(file);
  });
}
