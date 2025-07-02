import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Utility class for showing native toast notifications
class ToastHelper {
  /// Shows a success toast notification
  static void showSuccess(BuildContext context, String message) {
    _showNativeToast(
      message: message,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
    );
  }

  /// Shows an error toast notification
  static void showError(BuildContext context, String message) {
    _showNativeToast(
      message: message,
      backgroundColor: Theme.of(context).colorScheme.error,
      textColor: Theme.of(context).colorScheme.onError,
    );
  }

  /// Shows a warning toast notification
  static void showWarning(BuildContext context, String message) {
    _showNativeToast(
      message: message,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }

  /// Shows a general info toast notification
  static void showInfo(BuildContext context, String message) {
    _showNativeToast(
      message: message,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      textColor: Theme.of(context).colorScheme.onSurface,
    );
  }

  /// Private helper method that shows native Android toasts
  static void _showNativeToast({
    required String message,
    required Color backgroundColor,
    required Color textColor,
  }) {
    // Use native Android toasts on Android platform
    if (Platform.isAndroid) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16.0,
      );
    } else {
      // Fallback to SnackBar for other platforms (macOS, iOS, web)
      // Note: This fallback won't work without context, so we'll need to handle this differently
      // For now, we'll just use the native toast on all platforms
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
