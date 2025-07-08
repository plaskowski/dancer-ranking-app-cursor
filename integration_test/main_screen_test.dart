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

    // Verify the empty events view is shown when no events exist.
    expect(find.text('No events yet'), findsOneWidget);

    // Capture a screenshot for reporting purposes.
    await binding.takeScreenshot('01_home_screen');
  });
}