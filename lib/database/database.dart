import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'sample_data.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Events,
  Dancers,
  Ranks,
  Rankings,
  Attendances,
  Tags,
  DancerTags,
  Scores
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Testing constructor
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 6;

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

          // Insert sample data for easier testing
          final sampleData = SampleDataInitializer(this);
          await sampleData.insertAllSampleData();
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
          if (from < 6) {
            // Migration from v5 to v6: Add archival fields to Dancers table
            await _addArchivalFieldsToDancers(m);
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

    // Check if columns already exist before adding them
    final columns = await customSelect('PRAGMA table_info(ranks)').get();
    final columnNames =
        columns.map((row) => row.data['name'] as String).toList();

    // Add new columns to existing ranks table only if they don't exist
    if (!columnNames.contains('is_archived')) {
      await customStatement(
          'ALTER TABLE ranks ADD COLUMN is_archived INTEGER NOT NULL DEFAULT 0');
    }
    if (!columnNames.contains('created_at')) {
      await customStatement(
          'ALTER TABLE ranks ADD COLUMN created_at INTEGER NOT NULL DEFAULT $now');
    }
    if (!columnNames.contains('updated_at')) {
      await customStatement(
          'ALTER TABLE ranks ADD COLUMN updated_at INTEGER NOT NULL DEFAULT $now');
    }

    // Update existing ranks to have proper timestamps
    await customStatement(
        'UPDATE ranks SET created_at = $now, updated_at = $now WHERE created_at = $now');
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

    // Check if columns already exist before adding them
    final attendanceColumns =
        await customSelect('PRAGMA table_info(attendances)').get();
    final attendanceColumnNames =
        attendanceColumns.map((row) => row.data['name'] as String).toList();

    final dancerColumns =
        await customSelect('PRAGMA table_info(dancers)').get();
    final dancerColumnNames =
        dancerColumns.map((row) => row.data['name'] as String).toList();

    // Add new columns to attendances table only if they don't exist
    if (!attendanceColumnNames.contains('score_id')) {
      await customStatement(
          'ALTER TABLE attendances ADD COLUMN score_id INTEGER REFERENCES scores(id)');
    }

    // Add new column to dancers table only if it doesn't exist
    if (!dancerColumnNames.contains('first_met_date')) {
      await customStatement(
          'ALTER TABLE dancers ADD COLUMN first_met_date INTEGER');
    }

    // Insert default scores
    await _insertDefaultScores();
  }

  // Migration helper to add archival fields to Dancers table
  Future<void> _addArchivalFieldsToDancers(Migrator m) async {
    // Check if columns already exist before adding them
    final columns = await customSelect('PRAGMA table_info(dancers)').get();
    final columnNames =
        columns.map((row) => row.data['name'] as String).toList();

    // Add new columns to dancers table only if they don't exist
    if (!columnNames.contains('is_archived')) {
      await customStatement(
          'ALTER TABLE dancers ADD COLUMN is_archived INTEGER NOT NULL DEFAULT 0');
    }
    if (!columnNames.contains('archived_at')) {
      await customStatement(
          'ALTER TABLE dancers ADD COLUMN archived_at INTEGER');
    }
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

  /// Resets the database by clearing all user data and restoring essential defaults
  /// [includeTestData] - whether to include sample test data after reset
  Future<void> resetDatabase({bool includeTestData = false}) async {
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

      // Optionally restore sample data for easier testing
      if (includeTestData) {
        final sampleData = SampleDataInitializer(this);
        await sampleData.insertAllSampleData();
      }
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
