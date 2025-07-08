import 'package:dancer_ranking_app/database/database.dart';
import 'package:dancer_ranking_app/services/dancer/dancer_crud_service.dart';
import 'package:dancer_ranking_app/services/dancer_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dancer Archival System Tests', () {
    late AppDatabase database;
    late DancerService dancerService;
    late DancerCrudService crudService;

    setUp(() async {
      // Create in-memory database for testing
      database = AppDatabase.forTesting(NativeDatabase.memory());
      dancerService = DancerService(database);
      crudService = DancerCrudService(database);

      // Reset database to clean state
      await database.resetDatabase();
    });

    tearDown(() async {
      await database.close();
    });

    group('Database Schema Tests', () {
      test('should have isArchived and archivedAt columns', () async {
        // Create a dancer and verify the new fields exist
        final dancerId = await crudService.createDancer(
          name: 'Test Dancer',
          notes: 'Test notes',
        );

        final dancer = await crudService.getDancer(dancerId);
        expect(dancer, isNotNull);
        expect(dancer!.isArchived, isFalse);
        expect(dancer.archivedAt, isNull);
      });

      test('should set default values for existing dancers', () async {
        // Create multiple dancers
        final dancer1Id = await crudService.createDancer(name: 'Dancer 1');
        final dancer2Id = await crudService.createDancer(name: 'Dancer 2');
        final dancer3Id = await crudService.createDancer(name: 'Dancer 3');

        // Verify all are active by default
        final dancer1 = await crudService.getDancer(dancer1Id);
        final dancer2 = await crudService.getDancer(dancer2Id);
        final dancer3 = await crudService.getDancer(dancer3Id);

        expect(dancer1!.isArchived, isFalse);
        expect(dancer1.archivedAt, isNull);
        expect(dancer2!.isArchived, isFalse);
        expect(dancer2.archivedAt, isNull);
        expect(dancer3!.isArchived, isFalse);
        expect(dancer3.archivedAt, isNull);
      });
    });

    group('Archival Methods Tests', () {
      test('should archive a dancer successfully', () async {
        // Create a dancer
        final dancerId =
            await crudService.createDancer(name: 'Dancer to Archive');

        // Archive the dancer
        final success = await crudService.archiveDancer(dancerId);
        expect(success, isTrue);

        // Verify the dancer is archived
        final dancer = await crudService.getDancer(dancerId);
        expect(dancer!.isArchived, isTrue);
        expect(dancer.archivedAt, isNotNull);
        expect(
            dancer.archivedAt!
                .isAfter(DateTime.now().subtract(const Duration(minutes: 1))),
            isTrue);
      });

      test('should reactivate an archived dancer', () async {
        // Create and archive a dancer
        final dancerId =
            await crudService.createDancer(name: 'Dancer to Reactivate');
        await crudService.archiveDancer(dancerId);

        // Reactivate the dancer
        final success = await crudService.reactivateDancer(dancerId);
        expect(success, isTrue);

        // Verify the dancer is active again
        final dancer = await crudService.getDancer(dancerId);
        expect(dancer!.isArchived, isFalse);
        expect(dancer.archivedAt, isNull);
      });

      test('should handle archiving already archived dancer', () async {
        // Create and archive a dancer
        final dancerId =
            await crudService.createDancer(name: 'Already Archived');
        await crudService.archiveDancer(dancerId);

        // Try to archive again
        final success = await crudService.archiveDancer(dancerId);
        expect(success, isFalse);
      });

      test('should handle reactivating already active dancer', () async {
        // Create a dancer (already active)
        final dancerId = await crudService.createDancer(name: 'Already Active');

        // Try to reactivate
        final success = await crudService.reactivateDancer(dancerId);
        expect(success, isFalse);
      });

      test('should handle archiving non-existent dancer', () async {
        final success = await crudService.archiveDancer(99999);
        expect(success, isFalse);
      });

      test('should handle reactivating non-existent dancer', () async {
        final success = await crudService.reactivateDancer(99999);
        expect(success, isFalse);
      });
    });

    group('Active-Only Streams Tests', () {
      test('should watch only active dancers', () async {
        // Create active and archived dancers
        final active1Id = await crudService.createDancer(name: 'Active 1');
        final active2Id = await crudService.createDancer(name: 'Active 2');
        final toArchiveId = await crudService.createDancer(name: 'To Archive');

        // Archive one dancer
        await crudService.archiveDancer(toArchiveId);

        // Watch active dancers
        final activeDancers = await dancerService.watchActiveDancers().first;

        expect(activeDancers.length, equals(2));
        expect(activeDancers.any((d) => d.id == active1Id), isTrue);
        expect(activeDancers.any((d) => d.id == active2Id), isTrue);
        expect(activeDancers.any((d) => d.id == toArchiveId), isFalse);
      });

      test('should watch all dancers including archived', () async {
        // Create active and archived dancers
        final active1Id = await crudService.createDancer(name: 'Active 1');
        final toArchiveId = await crudService.createDancer(name: 'To Archive');

        // Archive one dancer
        await crudService.archiveDancer(toArchiveId);

        // Watch all dancers
        final allDancers = await dancerService.watchAllDancers().first;

        expect(allDancers.length, equals(2));
        expect(allDancers.any((d) => d.id == active1Id), isTrue);
        expect(allDancers.any((d) => d.id == toArchiveId), isTrue);
      });

      test('should search only active dancers', () async {
        // Create dancers with similar names
        final activeId = await crudService.createDancer(name: 'John Smith');
        final toArchiveId = await crudService.createDancer(name: 'John Doe');

        // Archive one
        await crudService.archiveDancer(toArchiveId);

        // Search active dancers for "John"
        final activeResults =
            await dancerService.searchActiveDancers('John').first;

        expect(activeResults.length, equals(1));
        expect(activeResults.first.id, equals(activeId));
        expect(activeResults.first.name, equals('John Smith'));
      });

      test('should search all dancers including archived', () async {
        // Create dancers with similar names
        final activeId = await crudService.createDancer(name: 'John Smith');
        final toArchiveId = await crudService.createDancer(name: 'John Doe');

        // Archive one
        await crudService.archiveDancer(toArchiveId);

        // Search all dancers for "John"
        final allResults = await dancerService.searchDancers('John').first;

        expect(allResults.length, equals(2));
        expect(allResults.any((d) => d.id == activeId), isTrue);
        expect(allResults.any((d) => d.id == toArchiveId), isTrue);
      });
    });

    group('Archived Dancers List Tests', () {
      test('should get archived dancers list', () async {
        // Create and archive dancers
        final dancer1Id = await crudService.createDancer(name: 'Dancer 1');
        final dancer2Id = await crudService.createDancer(name: 'Dancer 2');
        final dancer3Id = await crudService.createDancer(name: 'Dancer 3');

        await crudService.archiveDancer(dancer1Id);
        await crudService.archiveDancer(dancer2Id);
        // Leave dancer3 active

        // Get archived dancers
        final archivedDancers = await crudService.getArchivedDancers();

        expect(archivedDancers.length, equals(2));
        expect(archivedDancers.any((d) => d.id == dancer1Id), isTrue);
        expect(archivedDancers.any((d) => d.id == dancer2Id), isTrue);
        expect(archivedDancers.any((d) => d.id == dancer3Id), isFalse);
      });

      test('should order archived dancers by archivedAt desc', () async {
        // Create and archive dancers with delay
        final dancer1Id = await crudService.createDancer(name: 'Dancer 1');
        await crudService.archiveDancer(dancer1Id);

        // Wait sufficiently to ensure the timestamps differ even on coarse
        // system clocks (e.g., SQLite seconds resolution on some platforms).
        await Future.delayed(const Duration(seconds: 1));

        final dancer2Id = await crudService.createDancer(name: 'Dancer 2');
        await crudService.archiveDancer(dancer2Id);

        // Get archived dancers
        final archivedDancers = await crudService.getArchivedDancers();

        expect(archivedDancers.length, equals(2));

        // Both dancers should be present
        expect(archivedDancers.any((d) => d.id == dancer1Id), isTrue);
        expect(archivedDancers.any((d) => d.id == dancer2Id), isTrue);

        // Check that the list is ordered by archivedAt descending (most recent first)
        expect(archivedDancers[0].id, equals(dancer2Id));
        expect(archivedDancers[1].id, equals(dancer1Id));

        // Verify that the timestamps are actually different
        expect(
            archivedDancers[0]
                .archivedAt!
                .isAfter(archivedDancers[1].archivedAt!),
            isTrue);
      });
    });

    group('Data Preservation Tests', () {
      test('should preserve dancer data during archival', () async {
        // Create a dancer with notes
        final dancerId = await crudService.createDancer(
          name: 'Dancer with Notes',
          notes: 'Important notes to preserve',
        );

        // Archive the dancer
        await crudService.archiveDancer(dancerId);

        // Verify data is preserved
        final dancer = await crudService.getDancer(dancerId);
        expect(dancer!.name, equals('Dancer with Notes'));
        expect(dancer.notes, equals('Important notes to preserve'));
        expect(dancer.isArchived, isTrue);
      });

      test('should preserve data during reactivation', () async {
        // Create a dancer with notes
        final dancerId = await crudService.createDancer(
          name: 'Dancer with Notes',
          notes: 'Important notes to preserve',
        );

        // Archive and reactivate
        await crudService.archiveDancer(dancerId);
        await crudService.reactivateDancer(dancerId);

        // Verify data is preserved
        final dancer = await crudService.getDancer(dancerId);
        expect(dancer!.name, equals('Dancer with Notes'));
        expect(dancer.notes, equals('Important notes to preserve'));
        expect(dancer.isArchived, isFalse);
        expect(dancer.archivedAt, isNull);
      });
    });

    group('Service Layer Integration Tests', () {
      test('should use active-only streams in service layer', () async {
        // Create dancers
        final activeId = await crudService.createDancer(name: 'Active Dancer');
        final toArchiveId = await crudService.createDancer(name: 'To Archive');

        // Archive one
        await crudService.archiveDancer(toArchiveId);

        // Test service layer methods
        final activeDancers = await dancerService.watchActiveDancers().first;
        final allDancers = await dancerService.watchAllDancers().first;

        expect(activeDancers.length, equals(1));
        expect(allDancers.length, equals(2));
        expect(activeDancers.first.id, equals(activeId));
      });
    });
  });
}
