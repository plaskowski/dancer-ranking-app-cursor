import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dancer_ranking_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Simple UI Integration Tests', () {
    testWidgets('App launches successfully', (tester) async {
      app.main([]);
      await tester.pumpAndSettle();

      // Verify the app launches
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Bottom navigation tabs are present', (tester) async {
      app.main([]);
      await tester.pumpAndSettle();

      // Check for bottom navigation tabs
      expect(find.text('Events'), findsOneWidget);
      expect(find.text('Dancers'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('Floating action button is present on home screen', (tester) async {
      app.main([]);
      await tester.pumpAndSettle();

      // Check for FAB
      expect(find.byType(FloatingActionButton), findsOneWidget);
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

    testWidgets('Settings tabs are present', (tester) async {
      app.main([]);
      await tester.pumpAndSettle();

      // Navigate to Settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Check for settings tabs
      expect(find.text('General'), findsOneWidget);
      expect(find.text('Ranks'), findsOneWidget);
      expect(find.text('Scores'), findsOneWidget);
      expect(find.text('Tags'), findsOneWidget);
    });
  });
} 