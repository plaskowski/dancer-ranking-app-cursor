import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dancer_ranking_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dancer Ranking App Integration Tests', () {
    testWidgets('App launches and shows home screen', (tester) async {
      app.main([]);
      await tester.pumpAndSettle();

      // Verify the app launches and shows the home screen
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Check for the home screen elements
      expect(find.text('Dancer Ranking'), findsOneWidget);
      expect(find.text('Events'), findsOneWidget);
    });

    testWidgets('Navigation between tabs works', (tester) async {
      app.main([]);
      await tester.pumpAndSettle();

      // Navigate to Dancers tab
      await tester.tap(find.text('Dancers'));
      await tester.pumpAndSettle();
      expect(find.text('Dancers'), findsOneWidget);

      // Navigate to Settings tab
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);

      // Navigate back to Events tab
      await tester.tap(find.text('Events'));
      await tester.pumpAndSettle();
      expect(find.text('Events'), findsOneWidget);
    });

    testWidgets('Create event flow works', (tester) async {
      app.main([]);
      await tester.pumpAndSettle();

      // Tap the FAB to create a new event
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify the create event dialog appears
      expect(find.text('Create New Event'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);

      // Enter event name
      await tester.enterText(find.byType(TextFormField), 'Test Event');
      await tester.pumpAndSettle();

      // Tap create button
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Verify we're back on the home screen
      expect(find.text('Events'), findsOneWidget);
    });

    testWidgets('Event screen navigation works', (tester) async {
      app.main([]);
      await tester.pumpAndSettle();

      // Create an event first
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Test Event');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Tap on the created event to navigate to event screen
      await tester.tap(find.text('Test Event'));
      await tester.pumpAndSettle();

      // Verify we're on the event screen
      expect(find.text('Test Event'), findsOneWidget);
      expect(find.text('Planning'), findsOneWidget);
      expect(find.text('Present'), findsOneWidget);
      expect(find.text('Summary'), findsOneWidget);
    });

    testWidgets('Event tabs navigation works', (tester) async {
      app.main([]);
      await tester.pumpAndSettle();

      // Create and navigate to an event
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Test Event');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Test Event'));
      await tester.pumpAndSettle();

      // Navigate to Present tab
      await tester.tap(find.text('Present'));
      await tester.pumpAndSettle();
      expect(find.text('Present'), findsOneWidget);

      // Navigate to Summary tab
      await tester.tap(find.text('Summary'));
      await tester.pumpAndSettle();
      expect(find.text('Summary'), findsOneWidget);

      // Navigate back to Planning tab
      await tester.tap(find.text('Planning'));
      await tester.pumpAndSettle();
      expect(find.text('Planning'), findsOneWidget);
    });
  });
} 