import 'package:flutter/material.dart';

/// A FloatingActionButton that automatically accounts for Android system navigation bar padding
class SafeFAB extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? tooltip;
  final Widget child;
  final bool? mini;
  final bool? isExtended;
  final Widget? label;
  final Widget? icon;

  const SafeFAB({
    super.key,
    required this.onPressed,
    this.tooltip,
    required this.child,
    this.mini,
    this.isExtended,
    this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: isExtended == true
          ? FloatingActionButton.extended(
              onPressed: onPressed,
              tooltip: tooltip,
              label: label ?? const Text(''),
              icon: icon,
            )
          : FloatingActionButton(
              onPressed: onPressed,
              tooltip: tooltip,
              mini: mini ?? false,
              child: child,
            ),
    );
  }
}
