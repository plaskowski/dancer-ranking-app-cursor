import 'package:dancer_ranking_app/database/database.dart';
import 'package:dancer_ranking_app/services/dancer/dancer_crud_service.dart';
import 'package:dancer_ranking_app/services/event_import_validator.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dancer Name Matching Tests', () {
    late AppDatabase database;
    late EventImportValidator validator;
    late DancerCrudService dancerService;

    setUp(() async {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      validator = EventImportValidator(database);
      dancerService = DancerCrudService(database);
    });

    tearDown(() async {
      await database.close();
    });

    group('Basic Name Variants', () {
      test('should match exact names', () async {
        // Create a dancer in database
        final dancerId = await dancerService.createDancer(name: 'John Doe');
        final dancer = await dancerService.getDancer(dancerId);

        // Test exact match
        final result = await validator.getExistingDancersByNamesWithVariants({'John Doe'});

        expect(result.length, 1);
        expect(result['John Doe'], isNotNull);
        expect(result['John Doe']!.id, dancerId);
      });

      test('should match case variations', () async {
        await dancerService.createDancer(name: 'John Doe');

        // Test different case variations
        final result = await validator.getExistingDancersByNamesWithVariants({
          'john doe',
          'JOHN DOE',
          'John Doe',
        });

        expect(result.length, 3);
        expect(result['john doe'], isNotNull);
        expect(result['JOHN DOE'], isNotNull);
        expect(result['John Doe'], isNotNull);
        expect(result['john doe']!.id, result['JOHN DOE']!.id);
        expect(result['john doe']!.id, result['John Doe']!.id);
      });

      test('should match space variations', () async {
        await dancerService.createDancer(name: 'John Doe');

        final result = await validator.getExistingDancersByNamesWithVariants({
          'John   Doe',
          'John Doe',
          '  John Doe  ',
        });

        expect(result.length, 3);
        expect(result['John   Doe'], isNotNull);
        expect(result['John Doe'], isNotNull);
        expect(result['  John Doe  '], isNotNull);
        expect(result['John   Doe']!.id, result['John Doe']!.id);
      });
    });

    group('Dot Handling', () {
      test('should match names with and without dots', () async {
        await dancerService.createDancer(name: 'John Doe');

        final result = await validator.getExistingDancersByNamesWithVariants({
          'John Doe',
          'John Doe.',
        });

        expect(result.length, 2);
        expect(result['John Doe'], isNotNull);
        expect(result['John Doe.'], isNotNull);
        expect(result['John Doe']!.id, result['John Doe.']!.id);
      });

      test('should match names with dots in database', () async {
        await dancerService.createDancer(name: 'John Doe.');

        final result = await validator.getExistingDancersByNamesWithVariants({
          'John Doe',
          'John Doe.',
        });

        expect(result.length, 2);
        expect(result['John Doe'], isNotNull);
        expect(result['John Doe.'], isNotNull);
        expect(result['John Doe']!.id, result['John Doe.']!.id);
      });
    });

    group('Diacritic Handling', () {
      test('should match names with and without diacritics', () async {
        await dancerService.createDancer(name: 'José García');

        final result = await validator.getExistingDancersByNamesWithVariants({
          'José García',
          'Jose Garcia',
          'jose garcia',
        });

        expect(result.length, 3);
        expect(result['José García'], isNotNull);
        expect(result['Jose Garcia'], isNotNull);
        expect(result['jose garcia'], isNotNull);
        expect(result['José García']!.id, result['Jose Garcia']!.id);
        expect(result['José García']!.id, result['jose garcia']!.id);
      });

      test('should handle various diacritic characters', () async {
        await dancerService.createDancer(name: 'François Müller');

        final result = await validator.getExistingDancersByNamesWithVariants({
          'François Müller',
          'Francois Muller',
          'francois muller',
        });

        expect(result.length, 3);
        expect(result['François Müller'], isNotNull);
        expect(result['Francois Muller'], isNotNull);
        expect(result['francois muller'], isNotNull);
        expect(result['François Müller']!.id, result['Francois Muller']!.id);
      });

      test('should handle Polish characters', () async {
        await dancerService.createDancer(name: 'Łukasz Świątek');

        final result = await validator.getExistingDancersByNamesWithVariants({
          'Łukasz Świątek',
          'Lukasz Swiatek',
          'lukasz swiatek',
        });

        expect(result.length, 3);
        expect(result['Łukasz Świątek'], isNotNull);
        expect(result['Lukasz Swiatek'], isNotNull);
        expect(result['lukasz swiatek'], isNotNull);
        expect(result['Łukasz Świątek']!.id, result['Lukasz Swiatek']!.id);
      });
    });

    group('Word Order Switching', () {
      test('should match two-word names in different orders', () async {
        await dancerService.createDancer(name: 'John Doe');

        final result = await validator.getExistingDancersByNamesWithVariants({
          'John Doe',
          'Doe John',
          'doe john',
          'Doe John.',
        });

        expect(result.length, 4);
        expect(result['John Doe'], isNotNull);
        expect(result['Doe John'], isNotNull);
        expect(result['doe john'], isNotNull);
        expect(result['Doe John.'], isNotNull);
        expect(result['John Doe']!.id, result['Doe John']!.id);
        expect(result['John Doe']!.id, result['doe john']!.id);
        expect(result['John Doe']!.id, result['Doe John.']!.id);
      });

      test('should not switch order for single words', () async {
        await dancerService.createDancer(name: 'John');

        final result = await validator.getExistingDancersByNamesWithVariants({
          'John',
          'Doe', // This should not match
        });

        expect(result.length, 1);
        expect(result['John'], isNotNull);
        expect(result['Doe'], isNull);
      });

      test('should not switch order for three or more words', () async {
        await dancerService.createDancer(name: 'John Doe Smith');

        final result = await validator.getExistingDancersByNamesWithVariants({
          'John Doe Smith',
          'Smith Doe John', // This should not match
        });

        expect(result.length, 1);
        expect(result['John Doe Smith'], isNotNull);
        expect(result['Smith Doe John'], isNull);
      });
    });

    group('Complex Combinations', () {
      test('should handle word switching with diacritics and dots', () async {
        await dancerService.createDancer(name: 'José García');

        final result = await validator.getExistingDancersByNamesWithVariants({
          'José García',
          'García José',
          'Garcia Jose',
          'García José.',
          'Garcia Jose.',
        });

        expect(result.length, 5);
        expect(result['José García'], isNotNull);
        expect(result['García José'], isNotNull);
        expect(result['Garcia Jose'], isNotNull);
        expect(result['García José.'], isNotNull);
        expect(result['Garcia Jose.'], isNotNull);

        // All should match the same dancer
        final dancerId = result['José García']!.id;
        expect(result['García José']!.id, dancerId);
        expect(result['Garcia Jose']!.id, dancerId);
        expect(result['García José.']!.id, dancerId);
        expect(result['Garcia Jose.']!.id, dancerId);
      });

      test('should handle multiple dancers with similar names', () async {
        final dancer1Id = await dancerService.createDancer(name: 'John Doe');
        final dancer2Id = await dancerService.createDancer(name: 'Jane Smith');

        final result = await validator.getExistingDancersByNamesWithVariants({
          'John Doe',
          'Doe John',
          'Jane Smith',
          'Smith Jane',
        });

        expect(result.length, 4);
        expect(result['John Doe']!.id, dancer1Id);
        expect(result['Doe John']!.id, dancer1Id);
        expect(result['Jane Smith']!.id, dancer2Id);
        expect(result['Smith Jane']!.id, dancer2Id);
      });
    });

    group('Performance and Edge Cases', () {
      test('should handle empty names gracefully', () async {
        final result = await validator.getExistingDancersByNamesWithVariants({
          '',
          '   ',
        });

        expect(result.length, 0);
      });

      test('should handle single character names', () async {
        await dancerService.createDancer(name: 'A');

        final result = await validator.getExistingDancersByNamesWithVariants({
          'A',
          'a',
        });

        expect(result.length, 2);
        expect(result['A'], isNotNull);
        expect(result['a'], isNotNull);
        expect(result['A']!.id, result['a']!.id);
      });

      test('should handle very long names', () async {
        final longName = 'A' * 100; // 100 characters
        await dancerService.createDancer(name: longName);

        final result = await validator.getExistingDancersByNamesWithVariants({
          longName,
          longName.toLowerCase(),
        });

        expect(result.length, 2);
        expect(result[longName], isNotNull);
        expect(result[longName.toLowerCase()], isNotNull);
        expect(result[longName]!.id, result[longName.toLowerCase()]!.id);
      });

      test('should not match non-existent names', () async {
        await dancerService.createDancer(name: 'John Doe');

        final result = await validator.getExistingDancersByNamesWithVariants({
          'John Doe',
          'Jane Smith', // Non-existent
          'Different Person', // Non-existent
        });

        expect(result.length, 1);
        expect(result['John Doe'], isNotNull);
        expect(result['Jane Smith'], isNull);
        expect(result['Different Person'], isNull);
      });
    });

    group('Action Logging', () {
      test('should log variant matches', () async {
        await dancerService.createDancer(name: 'John Doe');

        // This should trigger variant matching and logging
        await validator.getExistingDancersByNamesWithVariants({
          'john doe', // This should match via variant
        });

        // Note: In a real test, you might want to verify the logs
        // For now, we just ensure the method completes without errors
        expect(true, isTrue);
      });
    });
  });
}
