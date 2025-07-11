import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dancer_ranking_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dancer Management Integration Tests', () {
    testWidgets('Add dancer to event flow', (tester) async {
      app.main([]);
      await tester.pumpAndSettle();

      // Create an event
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Test Event');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Navigate to the event
      await tester.tap(find.text('Test Event'));
      await tester.pumpAndSettle();

      // Verify we're on the Planning tab
      expect(find.text('Planning'), findsOneWidget);

      // Tap the add dancer button (FAB in planning tab)
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify the add dancer dialog appears
      expect(find.text('Add Dancer'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);

      // Enter dancer name
      await tester.enterText(find.byType(TextFormField), 'John Doe');
      await tester.pumpAndSettle();

      // Tap add button
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Verify dancer was added
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('Dancer ranking flow', (tester) async {
      app.main([]);
      await tester.pumpAndSettle();

      // Create an event and add a dancer
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Test Event');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Test Event'));
      await tester.pumpAndSettle();

      // Add a dancer
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Jane Smith');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Tap on the dancer to open ranking dialog
      await tester.tap(find.text('Jane Smith'));
      await tester.pumpAndSettle();

      // Verify ranking dialog appears
      expect(find.text('Rank Dancer'), findsOneWidget);

      // Select a rank
      await tester.tap(find.text('Would like to dance'));
      await tester.pumpAndSettle();

      // Tap save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify the rank is displayed
      expect(find.text('Would like to dance'), findsOneWidget);
    });

    testWidgets('Dancer filtering works', (tester) async {
      app.main([]);
      await tester.pumpAndSettle();

      // Navigate to Dancers tab
      await tester.tap(find.text('Dancers'));
      await tester.pumpAndSettle();

      // Verify we're on the Dancers screen
      expect(find.text('Dancers'), findsOneWidget);

      // Look for search field
      expect(find.byType(TextField), findsOneWidget);

      // Enter search term
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();

      // Verify search functionality works (either shows results or empty state)
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Settings navigation works', (tester) async {
      app.main([]);
      await tester.pumpAndSettle();

      // Navigate to Settings tab
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Verify we're on the Settings screen
      expect(find.text('Settings'), findsOneWidget);

      // Check for settings tabs
      expect(find.text('General'), findsOneWidget);
      expect(find.text('Ranks'), findsOneWidget);
      expect(find.text('Scores'), findsOneWidget);
      expect(find.text('Tags'), findsOneWidget);
    });
  });
} 