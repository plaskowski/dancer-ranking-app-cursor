import 'dart:io';

import 'package:dancer_ranking_app/services/event_import_parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

void main() {
  group('Import Validation Tests', () {
    test('Validate all JSON files in test directory', () async {
      // Directory containing your historical JSON files
      final testDirectory = Platform.environment['TEST_IMPORT_DIRECTORY'] ??
          '/Users/plaskowski/dev/private/dancer-diary-extractor-cursor/output/by_year_half';

      // Check if directory exists
      final directory = Directory(testDirectory);
      if (!await directory.exists()) {
        print(
            '⚠️  Test directory "$testDirectory" not found. Skipping validation.');
        return;
      }

      // Get all JSON files in the directory
      final jsonFiles = await directory
          .list()
          .where((entity) =>
              entity is File && path.extension(entity.path) == '.json')
          .cast<File>()
          .toList();

      if (jsonFiles.isEmpty) {
        print('⚠️  No JSON files found in "$testDirectory" directory.');
        return;
      }

      print('🔍 Found ${jsonFiles.length} JSON files to validate:');
      for (final file in jsonFiles) {
        print('  - ${path.basename(file.path)}');
      }
      print('');

      // Initialize the parser (no database needed for validation)
      final parser = EventImportParser();

      int totalFiles = 0;
      int validFiles = 0;
      int totalEvents = 0;
      int totalAttendances = 0;
      int totalDancers = 0;

      for (final file in jsonFiles) {
        totalFiles++;
        final fileName = path.basename(file.path);
        print('📄 Testing: $fileName');

        try {
          // Read the file content
          final content = await file.readAsString();

          // Use the actual parser service
          final result = await parser.parseJsonContent(content);

          if (result.isValid) {
            validFiles++;
            final events = result.events;
            final uniqueDancers = <String>{};

            for (final event in events) {
              for (final attendance in event.attendances) {
                totalAttendances++;
                uniqueDancers.add(attendance.dancerName);
              }
            }

            totalEvents += events.length;
            totalDancers += uniqueDancers.length;

            print(
                '  ✅ Valid: ${events.length} events, ${uniqueDancers.length} unique dancers');
          } else {
            print('  ❌ Errors:');
            for (final error in result.errors.take(5)) {
              // Show first 5 errors
              print('    - $error');
            }
            if (result.errors.length > 5) {
              print('    ... and ${result.errors.length - 5} more errors');
            }

            // Still count events that were parsed successfully despite errors
            for (final event in result.events) {
              for (final attendance in event.attendances) {
                totalAttendances++;
                totalDancers++;
              }
            }
            totalEvents += result.events.length;
          }
        } catch (e) {
          print('  ❌ Failed to parse JSON: ${e.toString()}');
        }

        print('');
      }

      // Print summary
      print('📊 Validation Summary:');
      print('  Files tested: $totalFiles');
      print('  Valid files: $validFiles');
      print('  Total events: $totalEvents');
      print('  Total attendances: $totalAttendances');
      print('  Total unique dancers: $totalDancers');

      if (validFiles > 0) {
        print(
            '  ✅ Success rate: ${(validFiles / totalFiles * 100).toStringAsFixed(1)}%');
      } else {
        print('  ❌ No valid files found');
      }

      // Assert that at least some files are valid
      expect(validFiles, greaterThan(0),
          reason: 'At least one JSON file should be valid for import');
    });

    test('Validate specific file structure using service', () async {
      // Test the expected structure using the actual service
      const validJson = '''
      {
        "events": [
          {
            "name": "Test Event",
            "date": "2024-01-15",
            "attendances": [
              {
                "dancer_name": "Test Dancer",
                "status": "served",
                "impression": "Great dance",
                "score": "Amazing"
              }
            ]
          }
        ]
      }
      ''';

      final parser = EventImportParser();
      final result = await parser.parseJsonContent(validJson);

      expect(result.isValid, isTrue);
      expect(result.events.length, equals(1));

      final event = result.events[0];
      expect(event.name, equals('Test Event'));
      expect(event.attendances.length, equals(1));
      expect(event.attendances[0].dancerName, equals('Test Dancer'));
      expect(event.attendances[0].status, equals('served'));
    });
  });
}
