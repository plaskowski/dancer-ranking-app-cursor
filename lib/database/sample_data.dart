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
        // Current event (today)
        EventsCompanion.insert(
          name: 'Wednesday Evening Social',
          date: DateTime(now.year, now.month, now.day, 19, 30), // 7:30 PM today
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

  /// Insert all sample data (events, dancers, rankings, and attendances)
  Future<void> insertAllSampleData() async {
    await insertSampleEvents();
    await insertSampleDancers();
    await insertSampleRankings(); // Planning data for future events
    await insertSampleAttendances(); // Historical data for past events
  }

  /// Insert sample rankings for future events and current event (planning data)
  Future<void> insertSampleRankings() async {
    // Get the future events and today's event (for planning)
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));

    final planningEvents = await (_database.select(_database.events)
          ..where(
              (e) => e.date.isBiggerOrEqual(Variable.withDateTime(todayStart))))
        .get();

    if (planningEvents.isEmpty) return;

    // Get some dancers for ranking
    final dancers = await _database.select(_database.dancers).get();
    if (dancers.isEmpty) return;

    // Get rank IDs
    final wantToDanceRank = await (_database.select(_database.ranks)
          ..where((r) => r.name.equals('Really want to dance!')))
        .getSingle();
    final wouldLikeRank = await (_database.select(_database.ranks)
          ..where((r) => r.name.equals('Would like to dance')))
        .getSingle();
    final maybeLaterRank = await (_database.select(_database.ranks)
          ..where((r) => r.name.equals('Maybe later')))
        .getSingle();

    // Add sample rankings to planning events (future + today)
    await _database.batch((batch) {
      for (final event in planningEvents) {
        // Add different dancers with different priorities for each event
        if (event.name.contains('Wednesday Evening')) {
          // Today's event - mixed priorities, realistic planning
          batch.insertAll(_database.rankings, [
            // High priority dancers
            RankingsCompanion.insert(
              eventId: event.id,
              dancerId:
                  dancers.firstWhere((d) => d.name == 'Alice Rodriguez').id,
              rankId: wantToDanceRank.id,
              reason: const Value('Regular at social events, great leader'),
            ),
            RankingsCompanion.insert(
              eventId: event.id,
              dancerId: dancers.firstWhere((d) => d.name == 'Elena Volkov').id,
              rankId: wantToDanceRank.id,
              reason: const Value('Always brings great energy'),
            ),
            RankingsCompanion.insert(
              eventId: event.id,
              dancerId: dancers.firstWhere((d) => d.name == 'Grace Wilson').id,
              rankId: wantToDanceRank.id,
              reason: const Value('Social butterfly, helps with atmosphere'),
            ),
            // Medium priority
            RankingsCompanion.insert(
              eventId: event.id,
              dancerId: dancers.firstWhere((d) => d.name == 'Bob Martinez').id,
              rankId: wouldLikeRank.id,
            ),
            RankingsCompanion.insert(
              eventId: event.id,
              dancerId: dancers.firstWhere((d) => d.name == 'Diana Chang').id,
              rankId: wouldLikeRank.id,
              reason: const Value('Good dancer but might be busy'),
            ),
            // Lower priority
            RankingsCompanion.insert(
              eventId: event.id,
              dancerId: dancers.firstWhere((d) => d.name == 'Frank Kim').id,
              rankId: maybeLaterRank.id,
              reason: const Value('Sometimes shy at social events'),
            ),
          ]);
        } else if (event.name.contains('Bachata')) {
          // Monthly Bachata Workshop - focus on bachata dancers
          batch.insertAll(_database.rankings, [
            // High priority dancers
            RankingsCompanion.insert(
              eventId: event.id,
              dancerId: dancers
                  .firstWhere((d) => d.name == 'Bob Martinez')
                  .id, // bachata specialist
              rankId: wantToDanceRank.id,
              reason: const Value('Bachata specialist, perfect for workshop'),
            ),
            RankingsCompanion.insert(
              eventId: event.id,
              dancerId: dancers
                  .firstWhere((d) => d.name == 'Diana Chang')
                  .id, // festival regular
              rankId: wantToDanceRank.id,
              reason:
                  const Value('Loves complex patterns, great for workshops'),
            ),
            // Medium priority
            RankingsCompanion.insert(
              eventId: event.id,
              dancerId:
                  dancers.firstWhere((d) => d.name == 'Alice Rodriguez').id,
              rankId: wouldLikeRank.id,
              reason: const Value('Good dancer, not sure if available'),
            ),
            RankingsCompanion.insert(
              eventId: event.id,
              dancerId: dancers.firstWhere((d) => d.name == 'Grace Wilson').id,
              rankId: wouldLikeRank.id,
            ),
            // Lower priority
            RankingsCompanion.insert(
              eventId: event.id,
              dancerId: dancers
                  .firstWhere((d) => d.name == 'Carlos Thompson')
                  .id, // new dancer
              rankId: maybeLaterRank.id,
              reason: const Value('Still learning, might be overwhelming'),
            ),
          ]);
        } else if (event.name.contains('Salsa Festival')) {
          // Summer Salsa Festival - broader appeal
          batch.insertAll(_database.rankings, [
            // High priority dancers
            RankingsCompanion.insert(
              eventId: event.id,
              dancerId: dancers
                  .firstWhere((d) => d.name == 'Alice Rodriguez')
                  .id, // salsa lover
              rankId: wantToDanceRank.id,
              reason: const Value('Loves salsa, great leader'),
            ),
            RankingsCompanion.insert(
              eventId: event.id,
              dancerId: dancers
                  .firstWhere((d) => d.name == 'Grace Wilson')
                  .id, // attends everywhere
              rankId: wantToDanceRank.id,
              reason: const Value('Festival regular, always fun'),
            ),
            RankingsCompanion.insert(
              eventId: event.id,
              dancerId: dancers
                  .firstWhere((d) => d.name == 'Elena Volkov')
                  .id, // great energy
              rankId: wantToDanceRank.id,
              reason: const Value('Amazing energy on the dance floor'),
            ),
            // Medium priority
            RankingsCompanion.insert(
              eventId: event.id,
              dancerId: dancers.firstWhere((d) => d.name == 'Bob Martinez').id,
              rankId: wouldLikeRank.id,
            ),
            RankingsCompanion.insert(
              eventId: event.id,
              dancerId: dancers.firstWhere((d) => d.name == 'Frank Kim').id,
              rankId: wouldLikeRank.id,
            ),
          ]);
        }
      }
    });
  }

  /// Insert sample attendances for past events and current event (historical data)
  Future<void> insertSampleAttendances() async {
    // Get the past events and today's event
    final today = DateTime.now();
    final tomorrowStart = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: 1));

    final attendanceEvents = await (_database.select(_database.events)
          ..where((e) =>
              e.date.isSmallerThan(Variable.withDateTime(tomorrowStart))))
        .get();

    if (attendanceEvents.isEmpty) return;

    // Get dancers and scores
    final dancers = await _database.select(_database.dancers).get();
    if (dancers.isEmpty) return;

    final goodScore = await (_database.select(_database.scores)
          ..where((s) => s.name.equals('Good')))
        .getSingle();
    final okayScore = await (_database.select(_database.scores)
          ..where((s) => s.name.equals('Okay')))
        .getSingle();
    final poorScore = await (_database.select(_database.scores)
          ..where((s) => s.name.equals('Poor')))
        .getSingle();

    // Add realistic attendance data to past and current events
    await _database.batch((batch) {
      for (final event in attendanceEvents) {
        if (event.name.contains('Wednesday Evening')) {
          // Today's event - event in progress, some people arrived, some danced
          final eventTime = event.date;
          final now = DateTime.now();

          batch.insertAll(_database.attendances, [
            // Early arrivals who have already danced
            AttendancesCompanion.insert(
              eventId: event.id,
              dancerId:
                  dancers.firstWhere((d) => d.name == 'Alice Rodriguez').id,
              markedAt: Value(eventTime.add(const Duration(minutes: 10))),
              status: const Value('served'),
              dancedAt: Value(eventTime.add(const Duration(minutes: 25))),
              impression: const Value('Great start to the evening!'),
              scoreId: Value(goodScore.id),
            ),
            AttendancesCompanion.insert(
              eventId: event.id,
              dancerId: dancers.firstWhere((d) => d.name == 'Grace Wilson').id,
              markedAt: Value(eventTime.add(const Duration(minutes: 5))),
              status: const Value('served'),
              dancedAt: Value(eventTime.add(const Duration(minutes: 35))),
              impression: const Value('Always a pleasure, great energy'),
              scoreId: Value(goodScore.id),
            ),
            // Recently arrived, not danced yet
            AttendancesCompanion.insert(
              eventId: event.id,
              dancerId: dancers.firstWhere((d) => d.name == 'Elena Volkov').id,
              markedAt: Value(eventTime.add(const Duration(minutes: 20))),
              status: const Value('present'),
              impression: const Value('Just arrived, chatting with friends'),
            ),
            AttendancesCompanion.insert(
              eventId: event.id,
              dancerId: dancers.firstWhere((d) => d.name == 'Bob Martinez').id,
              markedAt: Value(eventTime.add(const Duration(minutes: 15))),
              status: const Value('present'),
              impression: const Value('Warming up, looking for dance partners'),
            ),
          ]);
        } else if (event.name.contains('Cuban Bar')) {
          // Salsa Night - smaller venue, some dancers
          final eventTime = event.date;
          batch.insertAll(_database.attendances, [
            // Dancers who attended and danced
            AttendancesCompanion.insert(
              eventId: event.id,
              dancerId:
                  dancers.firstWhere((d) => d.name == 'Alice Rodriguez').id,
              markedAt: Value(eventTime.add(const Duration(minutes: 15))),
              status: const Value('served'),
              dancedAt: Value(eventTime.add(const Duration(minutes: 45))),
              impression: const Value('Great connection, smooth leading'),
              scoreId: Value(goodScore.id),
            ),
            AttendancesCompanion.insert(
              eventId: event.id,
              dancerId: dancers.firstWhere((d) => d.name == 'Bob Martinez').id,
              markedAt: Value(eventTime.add(const Duration(minutes: 30))),
              status: const Value('served'),
              dancedAt:
                  Value(eventTime.add(const Duration(hours: 1, minutes: 15))),
              impression: const Value('Nice bachata-style following in salsa'),
              scoreId: Value(goodScore.id),
            ),
            AttendancesCompanion.insert(
              eventId: event.id,
              dancerId: dancers.firstWhere((d) => d.name == 'Elena Volkov').id,
              markedAt: Value(eventTime.add(const Duration(minutes: 20))),
              status: const Value('served'),
              dancedAt: Value(eventTime.add(const Duration(hours: 1))),
              impression: const Value(
                  'Amazing energy, made the whole dance floor smile'),
              scoreId: Value(goodScore.id),
            ),
            // Dancers who attended but left early
            AttendancesCompanion.insert(
              eventId: event.id,
              dancerId:
                  dancers.firstWhere((d) => d.name == 'Carlos Thompson').id,
              markedAt: Value(eventTime.add(const Duration(minutes: 45))),
              status: const Value('left'),
              dancedAt:
                  Value(eventTime.add(const Duration(hours: 1, minutes: 30))),
              impression: const Value('Still learning but enthusiastic'),
              scoreId: Value(okayScore.id),
            ),
          ]);
        } else if (event.name.contains('Weekend Social')) {
          // Weekend Social Dance - more casual, more attendees
          final eventTime = event.date;
          batch.insertAll(_database.attendances, [
            // Multiple dancers with varied experiences
            AttendancesCompanion.insert(
              eventId: event.id,
              dancerId:
                  dancers.firstWhere((d) => d.name == 'Alice Rodriguez').id,
              markedAt: Value(eventTime.add(const Duration(minutes: 10))),
              status: const Value('served'),
              dancedAt: Value(eventTime.add(const Duration(minutes: 35))),
              impression: const Value('Always reliable, great leading'),
              scoreId: Value(goodScore.id),
            ),
            AttendancesCompanion.insert(
              eventId: event.id,
              dancerId: dancers.firstWhere((d) => d.name == 'Diana Chang').id,
              markedAt: Value(eventTime.add(const Duration(minutes: 20))),
              status: const Value('served'),
              dancedAt: Value(eventTime.add(const Duration(minutes: 50))),
              impression: const Value('Complex patterns, very technical'),
              scoreId: Value(goodScore.id),
            ),
            AttendancesCompanion.insert(
              eventId: event.id,
              dancerId: dancers.firstWhere((d) => d.name == 'Grace Wilson').id,
              markedAt: Value(eventTime.add(const Duration(minutes: 5))),
              status: const Value('served'),
              dancedAt:
                  Value(eventTime.add(const Duration(hours: 1, minutes: 20))),
              impression: const Value('Social butterfly, dances with everyone'),
              scoreId: Value(goodScore.id),
            ),
            AttendancesCompanion.insert(
              eventId: event.id,
              dancerId: dancers.firstWhere((d) => d.name == 'Frank Kim').id,
              markedAt: Value(eventTime.add(const Duration(minutes: 30))),
              status: const Value('present'),
              impression: const Value('Shy tonight, mostly watched'),
            ),
            AttendancesCompanion.insert(
              eventId: event.id,
              dancerId: dancers.firstWhere((d) => d.name == 'Elena Volkov').id,
              markedAt: Value(eventTime.add(const Duration(minutes: 15))),
              status: const Value('served'),
              dancedAt: Value(eventTime.add(const Duration(hours: 2))),
              impression: const Value('Late dance but worth the wait'),
              scoreId: Value(okayScore.id),
            ),
          ]);
        }
      }
    });
  }
}
