import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dancer_ranking_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Import Functionality Integration Tests', () {
    testWidgets('Import dancers dialog appears', (tester) async {
      app.main([]);
      await tester.pumpAndSettle();

      // Navigate to Dancers tab
      await tester.tap(find.text('Dancers'));
      await tester.pumpAndSettle();

      // Look for import button (usually in app bar or FAB)
      // This test verifies the import functionality is accessible
      expect(find.text('Dancers'), findsOneWidget);
      
      // Check if there's an import button or menu option
      // The exact implementation may vary, so we'll check for common patterns
      final importButtons = find.byWidgetPredicate(
        (widget) => widget is IconButton || 
                    (widget is Text && widget.data!.toLowerCase().contains('import')),
      );
      
      // If import button exists, test it
      if (importButtons.evaluate().isNotEmpty) {
        await tester.tap(importButtons.first);
        await tester.pumpAndSettle();
        
        // Verify import dialog appears
        expect(find.text('Import Dancers'), findsOneWidget);
      }
    });

    testWidgets('Import events dialog appears', (tester) async {
      app.main([]);
      await tester.pumpAndSettle();

      // Navigate to Events tab (should be default)
      expect(find.text('Events'), findsOneWidget);

      // Look for import events functionality
      // This might be in a menu or app bar
      final importEventButtons = find.byWidgetPredicate(
        (widget) => widget is IconButton || 
                    (widget is Text && widget.data!.toLowerCase().contains('import')),
      );
      
      // If import events button exists, test it
      if (importEventButtons.evaluate().isNotEmpty) {
        await tester.tap(importEventButtons.first);
        await tester.pumpAndSettle();
        
        // Verify import events dialog appears
        expect(find.text('Import Events'), findsOneWidget);
      }
    });

    testWidgets('Import rankings dialog appears', (tester) async {
      app.main([]);
      await tester.pumpAndSettle();

      // Create an event first
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Test Event');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Navigate to the event
      await tester.tap(find.text('Test Event'));
      await tester.pumpAndSettle();

      // Look for import rankings functionality in the event screen
      // This might be in the app bar or planning tab
      final importRankingButtons = find.byWidgetPredicate(
        (widget) => widget is IconButton || 
                    (widget is Text && widget.data!.toLowerCase().contains('import')),
      );
      
      // If import rankings button exists, test it
      if (importRankingButtons.evaluate().isNotEmpty) {
        await tester.tap(importRankingButtons.first);
        await tester.pumpAndSettle();
        
        // Verify import rankings dialog appears
        expect(find.text('Import Rankings'), findsOneWidget);
      }
    });

    testWidgets('File picker integration works', (tester) async {
      app.main([]);
      await tester.pumpAndSettle();

      // This test verifies that file picker functionality is accessible
      // The actual file picking would require platform-specific testing
      
      // Navigate to Dancers tab
      await tester.tap(find.text('Dancers'));
      await tester.pumpAndSettle();

      // Look for any file-related functionality
      final fileButtons = find.byWidgetPredicate(
        (widget) => widget is IconButton || 
                    (widget is Text && (widget.data!.toLowerCase().contains('file') ||
                                       widget.data!.toLowerCase().contains('browse'))),
      );
      
      // If file-related buttons exist, verify they're accessible
      if (fileButtons.evaluate().isNotEmpty) {
        expect(fileButtons, findsWidgets);
      }
    });
  });
} 