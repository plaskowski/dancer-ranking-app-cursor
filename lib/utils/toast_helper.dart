import 'package:flutter/material.dart';

/// Utility class for showing improved toast notifications
class ToastHelper {
  /// Shows a success toast notification
  static void showSuccess(BuildContext context, String message) {
    _showToast(
      context,
      message: message,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
    );
  }

  /// Shows an error toast notification
  static void showError(BuildContext context, String message) {
    _showToast(
      context,
      message: message,
      backgroundColor: Theme.of(context).colorScheme.error,
      textColor: Theme.of(context).colorScheme.onError,
    );
  }

  /// Shows a warning toast notification
  static void showWarning(BuildContext context, String message) {
    _showToast(
      context,
      message: message,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }

  /// Shows a general info toast notification
  static void showInfo(BuildContext context, String message) {
    _showToast(
      context,
      message: message,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      textColor: Theme.of(context).colorScheme.onSurface,
    );
  }

  /// Private helper method that creates the improved SnackBar
  static void _showToast(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required Color textColor,
  }) {
    // Clear any existing SnackBars first
    ScaffoldMessenger.of(context).clearSnackBars();

    final snackBar = SnackBar(
      content: GestureDetector(
        onTap: () {
          // Dismiss immediately when tapped
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        child: Text(
          message,
          style: TextStyle(color: textColor),
        ),
      ),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 2), // Shorter duration
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      dismissDirection: DismissDirection.horizontal,
      action: SnackBarAction(
        label: '✕',
        textColor: textColor.withOpacity(0.8),
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
