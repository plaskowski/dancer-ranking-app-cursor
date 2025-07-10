import 'package:flutter/material.dart';

/// Widget for displaying multiple floating action buttons in a vertical layout
/// with the primary FAB at the bottom and secondary FABs stacked above it.
class MultiFABLayout extends StatelessWidget {
  final Widget primaryFAB;
  final Widget? secondaryFAB;
  final bool showSecondary;

  const MultiFABLayout({
    super.key,
    required this.primaryFAB,
    this.secondaryFAB,
    this.showSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showSecondary && secondaryFAB != null) ...[
          AnimatedScale(
            scale: showSecondary ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: secondaryFAB!,
          ),
          const SizedBox(height: 16),
        ],
        primaryFAB,
      ],
    );
  }
}