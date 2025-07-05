import 'package:flutter/material.dart';

import '../utils/action_logger.dart';

/// A reusable error display component that follows the audit log pattern
/// and provides consistent error UI across the app.
class ErrorDisplay extends StatelessWidget {
  final String source;
  final String action;
  final Object error;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? additionalContext;
  final String title;
  final String message;

  const ErrorDisplay({
    super.key,
    required this.source,
    required this.action,
    required this.error,
    this.stackTrace,
    this.additionalContext,
    this.title = 'Unable to load data',
    this.message = 'Please restart the app or contact support',
  });

  @override
  Widget build(BuildContext context) {
    // Log the error with full details for debugging
    ActionLogger.logError(source, action, {
      'error': error.toString(),
      'stackTrace': stackTrace?.toString(),
      if (additionalContext != null) ...additionalContext!,
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Convenience factory methods for common error scenarios
class ErrorDisplayFactory {
  /// For stream errors in screens
  static ErrorDisplay streamError({
    required String source,
    required Object error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
    String? title,
    String? message,
  }) {
    return ErrorDisplay(
      source: source,
      action: 'stream_error',
      error: error,
      stackTrace: stackTrace,
      additionalContext: context,
      title: title ?? 'Unable to load data',
      message: message ?? 'Please restart the app or contact support',
    );
  }

  /// For database errors
  static ErrorDisplay databaseError({
    required String source,
    required Object error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    return ErrorDisplay(
      source: source,
      action: 'database_error',
      error: error,
      stackTrace: stackTrace,
      additionalContext: context,
      title: 'Database error',
    );
  }

  /// For network/API errors
  static ErrorDisplay networkError({
    required String source,
    required Object error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    return ErrorDisplay(
      source: source,
      action: 'network_error',
      error: error,
      stackTrace: stackTrace,
      additionalContext: context,
      title: 'Connection error',
      message: 'Please check your connection and try again',
    );
  }

  /// For validation errors
  static ErrorDisplay validationError({
    required String source,
    required Object error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    return ErrorDisplay(
      source: source,
      action: 'validation_error',
      error: error,
      stackTrace: stackTrace,
      additionalContext: context,
      title: 'Invalid data',
      message: 'Please check your input and try again',
    );
  }
}
