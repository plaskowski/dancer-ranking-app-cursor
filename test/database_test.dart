import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:matcher/matcher.dart' as matcher;

import 'package:dancer_ranking_app/database/database.dart';
import 'package:dancer_ranking_app/services/event_service.dart';
import 'package:dancer_ranking_app/services/dancer_service.dart';
import 'package:dancer_ranking_app/services/ranking_service.dart';
import 'package:dancer_ranking_app/services/attendance_service.dart';

void main() {
  group('Database and Services Tests', () {
    late AppDatabase database;
    late EventService eventService;
    late DancerService dancerService;
    late RankingService rankingService;
    late AttendanceService attendanceService;

    setUp(() {
      // Create in-memory database for testing
      database = AppDatabase.forTesting(NativeDatabase.memory());
      eventService = EventService(database);
      dancerService = DancerService(database);
      rankingService = RankingService(database);
      attendanceService = AttendanceService(database);
    });

    tearDown(() async {
      await database.close();
    });

    test('should create and retrieve event', () async {
      // Create an event
      final eventId = await eventService.createEvent(
        name: 'Test Salsa Night',
        date: DateTime(2024, 12, 15),
      );

      expect(eventId, greaterThan(0));

      // Retrieve the event
      final event = await eventService.getEvent(eventId);
      expect(event, matcher.isNotNull);
      expect(event!.name, 'Test Salsa Night');
      expect(event.date, DateTime(2024, 12, 15));
    });

    test('should create and retrieve dancer', () async {
      // Create a dancer
      final dancerId = await dancerService.createDancer(
        name: 'Maria',
        notes: 'Great lead, loves bachata',
      );

      expect(dancerId, greaterThan(0));

      // Retrieve the dancer
      final dancer = await dancerService.getDancer(dancerId);
      expect(dancer, matcher.isNotNull);
      expect(dancer!.name, 'Maria');
      expect(dancer.notes, 'Great lead, loves bachata');
    });

    test('should create ranking and retrieve with rank info', () async {
      // Create event and dancer
      final eventId = await eventService.createEvent(
        name: 'Test Event',
        date: DateTime.now(),
      );
      final dancerId = await dancerService.createDancer(name: 'John');

      // Get all ranks
      final ranks = await rankingService.getAllRanks();
      expect(ranks.length, 5); // Should have 5 default ranks

      // Set ranking
      await rankingService.setRanking(
        eventId: eventId,
        dancerId: dancerId,
        rankId: ranks.first.id,
        reason: 'Looking great tonight!',
      );

      // Retrieve ranking
      final ranking = await rankingService.getRanking(eventId, dancerId);
      expect(ranking, matcher.isNotNull);
      expect(ranking!.reason, 'Looking great tonight!');
    });

    test('should handle attendance and dance recording', () async {
      // Create event and dancer
      final eventId = await eventService.createEvent(
        name: 'Test Event',
        date: DateTime.now(),
      );
      final dancerId = await dancerService.createDancer(name: 'Sarah');

      // Mark present
      await attendanceService.markPresent(eventId, dancerId);

      // Check if marked present
      final isPresent = await attendanceService.isPresent(eventId, dancerId);
      expect(isPresent, true);

      // Record dance
      await attendanceService.recordDance(
        eventId: eventId,
        dancerId: dancerId,
        impression: 'Amazing dance!',
      );

      // Check if has danced
      final hasDanced = await attendanceService.hasDanced(eventId, dancerId);
      expect(hasDanced, true);
    });

    test('should get dancers for event with complete info', () async {
      // Create event
      final eventId = await eventService.createEvent(
        name: 'Test Party',
        date: DateTime.now(),
      );

      // Create dancer
      final dancerId = await dancerService.createDancer(
        name: 'Alex',
        notes: 'Smooth dancer',
      );

      // Get dancers for event (without ranking first)
      final dancers = await dancerService.getDancersForEvent(eventId);
      expect(dancers.length, 1);

      final dancer = dancers.first;
      expect(dancer.name, 'Alex');
      expect(dancer.notes, 'Smooth dancer');
      expect(dancer.isPresent, false);
      expect(dancer.hasRanking, false);
      expect(dancer.hasDanced, false);
    });
  });
} 