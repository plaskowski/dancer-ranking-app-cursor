import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Events, Dancers, Ranks, Rankings, Attendances])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  // Testing constructor
  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      
      // Insert default ranks
      await _insertDefaultRanks();
    },
  );

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