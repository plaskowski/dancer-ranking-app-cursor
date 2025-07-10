import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:dancer_ranking_app/main.dart' as app;

void main() {
  // Ensure we are using the integration test binding.
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding
    ..framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('Home screen renders empty state and captures screenshot',
      (WidgetTester tester) async {
    // Launch the full app.
    app.main([]);
    await tester.pumpAndSettle();

    // Verify AppBar title is visible.
    expect(find.text('Events'), findsOneWidget);

    // App built successfully without runtime errors.

    // Capture golden image of the HomeScreen for visual regression checks.
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/home_screen.png'),
    );
  });
}