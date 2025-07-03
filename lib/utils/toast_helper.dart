import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Utility class for showing native toast notifications
class ToastHelper {
  /// Shows a success toast notification
  static void showSuccess(BuildContext context, String message) {
    _showToast(
      context: context,
      message: message,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
    );
  }

  /// Shows an error toast notification
  static void showError(BuildContext context, String message) {
    _showToast(
      context: context,
      message: message,
      backgroundColor: Theme.of(context).colorScheme.error,
      textColor: Theme.of(context).colorScheme.onError,
    );
  }

  /// Shows a warning toast notification
  static void showWarning(BuildContext context, String message) {
    _showToast(
      context: context,
      message: message,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }

  /// Shows a general info toast notification
  static void showInfo(BuildContext context, String message) {
    _showToast(
      context: context,
      message: message,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      textColor: Theme.of(context).colorScheme.onSurface,
    );
  }

  /// Private helper method that shows appropriate toast based on platform
  static void _showToast({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required Color textColor,
  }) {
    // Use SnackBar for macOS and other platforms where fluttertoast might not work
    if (Platform.isMacOS) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: textColor),
          ),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // Use native Android toasts on Android platform
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16.0,
      );
    }
  }
}
