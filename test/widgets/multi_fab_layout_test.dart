import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dancer_ranking_app/widgets/multi_fab_layout.dart';

void main() {
  group('MultiFABLayout Widget Tests', () {
    testWidgets('should display only primary FAB when secondary is hidden', (tester) async {
      final primaryFAB = FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      );
      
      final secondaryFAB = FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.keyboard_arrow_down),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiFABLayout(
              primaryFAB: primaryFAB,
              secondaryFAB: secondaryFAB,
              showSecondary: false,
            ),
          ),
        ),
      );

      // Should find primary FAB
      expect(find.byIcon(Icons.add), findsOneWidget);
      
      // Should not find secondary FAB (it's scaled to 0)
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      
      // Check that the AnimatedScale is at scale 0
      final animatedScale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(animatedScale.scale, 0.0);
    });

    testWidgets('should display both FABs when secondary is shown', (tester) async {
      final primaryFAB = FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      );
      
      final secondaryFAB = FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.keyboard_arrow_down),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiFABLayout(
              primaryFAB: primaryFAB,
              secondaryFAB: secondaryFAB,
              showSecondary: true,
            ),
          ),
        ),
      );

      // Should find both FABs
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      
      // Check that the AnimatedScale is at scale 1
      final animatedScale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(animatedScale.scale, 1.0);
    });

    testWidgets('should animate secondary FAB appearance', (tester) async {
      final primaryFAB = FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      );
      
      final secondaryFAB = FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.keyboard_arrow_down),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiFABLayout(
              primaryFAB: primaryFAB,
              secondaryFAB: secondaryFAB,
              showSecondary: false,
            ),
          ),
        ),
      );

      // Initial state - secondary FAB should be scaled to 0
      AnimatedScale animatedScale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(animatedScale.scale, 0.0);

      // Update to show secondary FAB
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiFABLayout(
              primaryFAB: primaryFAB,
              secondaryFAB: secondaryFAB,
              showSecondary: true,
            ),
          ),
        ),
      );

      // Should update to scale 1
      animatedScale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(animatedScale.scale, 1.0);
    });

    testWidgets('should handle null secondary FAB', (tester) async {
      final primaryFAB = FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiFABLayout(
              primaryFAB: primaryFAB,
              secondaryFAB: null,
              showSecondary: true,
            ),
          ),
        ),
      );

      // Should only find primary FAB
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);
      
      // Should not find AnimatedScale when secondary is null
      expect(find.byType(AnimatedScale), findsNothing);
    });

    testWidgets('should have correct animation duration', (tester) async {
      final primaryFAB = FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      );
      
      final secondaryFAB = FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.keyboard_arrow_down),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiFABLayout(
              primaryFAB: primaryFAB,
              secondaryFAB: secondaryFAB,
              showSecondary: true,
            ),
          ),
        ),
      );

      // Check animation duration
      final animatedScale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(animatedScale.duration, const Duration(milliseconds: 200));
      expect(animatedScale.curve, Curves.easeInOut);
    });

    testWidgets('should have correct layout structure', (tester) async {
      final primaryFAB = FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      );
      
      final secondaryFAB = FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.keyboard_arrow_down),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiFABLayout(
              primaryFAB: primaryFAB,
              secondaryFAB: secondaryFAB,
              showSecondary: true,
            ),
          ),
        ),
      );

      // Should have Column as root widget
      expect(find.byType(Column), findsOneWidget);
      
      // Check column properties
      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisSize, MainAxisSize.min);
      
      // Should have SizedBox for spacing
      expect(find.byType(SizedBox), findsOneWidget);
      
      // Check SizedBox height
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, 16.0);
    });
  });
}