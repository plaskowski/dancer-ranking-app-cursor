import 'package:drift/drift.dart';

import 'database.dart';

/// Sample data initialization for testing and demonstration purposes
class SampleDataInitializer {
  final AppDatabase _database;

  SampleDataInitializer(this._database);

  /// Insert sample events with different dates for testing
  Future<void> insertSampleEvents() async {
    final now = DateTime.now();

    await _database.batch((batch) {
      batch.insertAll(_database.events, [
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

  /// Insert sample dancers with different tag combinations for testing
  Future<void> insertSampleDancers() async {
    // Insert sample dancers individually to get their IDs
    final aliceId =
        await _database.into(_database.dancers).insert(DancersCompanion.insert(
              name: 'Alice Rodriguez',
              notes: const Value('Great leader, loves salsa'),
            ));

    final bobId =
        await _database.into(_database.dancers).insert(DancersCompanion.insert(
              name: 'Bob Martinez',
              notes: const Value('Excellent follower, bachata specialist'),
            ));

    final carlosId =
        await _database.into(_database.dancers).insert(DancersCompanion.insert(
              name: 'Carlos Thompson',
              notes: const Value('New to partner dancing'),
            ));

    final dianaId =
        await _database.into(_database.dancers).insert(DancersCompanion.insert(
              name: 'Diana Chang',
              notes: const Value('Festival regular, loves complex patterns'),
            ));

    final elenaId =
        await _database.into(_database.dancers).insert(DancersCompanion.insert(
              name: 'Elena Volkov',
              notes: const Value('Social dancer, great energy'),
            ));

    final frankId =
        await _database.into(_database.dancers).insert(DancersCompanion.insert(
              name: 'Frank Kim',
              notes: const Value('Monday class student'),
            ));

    final graceId =
        await _database.into(_database.dancers).insert(DancersCompanion.insert(
              name: 'Grace Wilson',
              notes: const Value('Attends multiple venues'),
            ));

    // Get the tag IDs for tag assignments
    final mondayClassTag = await (_database.select(_database.tags)
          ..where((t) => t.name.equals('Monday Class')))
        .getSingle();
    final festivalTag = await (_database.select(_database.tags)
          ..where((t) => t.name.equals('Cuban DC Festival')))
        .getSingle();
    final socialTag = await (_database.select(_database.tags)
          ..where((t) => t.name.equals('Friday Social')))
        .getSingle();

    // Assign tags to dancers for variety in testing
    await _database.batch((batch) {
      batch.insertAll(_database.dancerTags, [
        // Alice: Monday Class + Friday Social (multi-venue)
        DancerTagsCompanion.insert(dancerId: aliceId, tagId: mondayClassTag.id),
        DancerTagsCompanion.insert(dancerId: aliceId, tagId: socialTag.id),

        // Bob: Cuban DC Festival only (festival dancer)
        DancerTagsCompanion.insert(dancerId: bobId, tagId: festivalTag.id),

        // Carlos: Monday Class only (class student)
        DancerTagsCompanion.insert(
            dancerId: carlosId, tagId: mondayClassTag.id),

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

  /// Insert all sample data (events and dancers)
  Future<void> insertAllSampleData() async {
    await insertSampleEvents();
    await insertSampleDancers();
  }
}
