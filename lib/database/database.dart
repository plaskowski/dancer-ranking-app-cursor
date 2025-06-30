import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Events, Dancers, Ranks, Rankings, Attendances])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Testing constructor
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();

          // Insert default ranks
          await _insertDefaultRanks();
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
    await customStatement(
        'ALTER TABLE ranks ADD COLUMN is_archived INTEGER NOT NULL DEFAULT 0');
    await customStatement(
        'ALTER TABLE ranks ADD COLUMN created_at INTEGER NOT NULL DEFAULT $now');
    await customStatement(
        'ALTER TABLE ranks ADD COLUMN updated_at INTEGER NOT NULL DEFAULT $now');

    // Update existing ranks to have proper timestamps
    await customStatement(
        'UPDATE ranks SET created_at = $now, updated_at = $now WHERE created_at = $now');
  }

  // Insert the predefined rank options
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
          name: 'Neutral / Default',
          ordinal: 3,
        ),
        RanksCompanion.insert(
          name: 'Maybe later',
          ordinal: 4,
        ),
        RanksCompanion.insert(
          name: 'Not really interested',
          ordinal: 5,
        ),
      ]);
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
