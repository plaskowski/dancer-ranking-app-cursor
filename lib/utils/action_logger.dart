import 'dart:developer' as developer;

/// Centralized action logging utility for debugging and tracking user actions
/// Format designed to be easily processable by Cursor agent for bug analysis
class ActionLogger {
  static const String _actionPrefix = '[ACTION_LOG]';
  static const String _listPrefix = '[LIST_LOG]';
  static const String _statePrefix = '[STATE_LOG]';
  static const String _errorPrefix = '[ERROR_LOG]';

  /// Log a user action with structured format
  /// [component] - Which component/screen/service performed the action
  /// [action] - What action was performed
  /// [details] - Additional context (IDs, values, etc.)
  static void logAction(String component, String action, [Map<String, dynamic>? details]) {
    final timestamp = DateTime.now().toIso8601String();
    final detailsStr = details != null ? _formatDetails(details) : '';
    final message = '$_actionPrefix $timestamp | $component | $action$detailsStr';

    developer.log(message, name: 'ActionLogger');
    print(message); // Also print for easy console viewing
  }

  /// Log list items being rendered with IDs and key info
  /// [component] - Which component is rendering the list
  /// [listType] - Type of list (dancers, events, rankings, etc.)
  /// [items] - List of items with their key information
  static void logListRendering(String component, String listType, List<Map<String, dynamic>> items) {
    final timestamp = DateTime.now().toIso8601String();
    final count = items.length;
    final itemsStr = items.map((item) => _formatDetails(item)).join(', ');
    final message = '$_listPrefix $timestamp | $component | $listType | count=$count | items=[$itemsStr]';

    developer.log(message, name: 'ActionLogger');
    print(message);
  }

  /// Log state changes (data updates, navigation, etc.)
  /// [component] - Which component had state change
  /// [stateChange] - Description of what changed
  /// [before] - Previous state (optional)
  /// [after] - New state (optional)
  static void logStateChange(String component, String stateChange,
      {Map<String, dynamic>? before, Map<String, dynamic>? after}) {
    final timestamp = DateTime.now().toIso8601String();
    String message = '$_statePrefix $timestamp | $component | $stateChange';

    if (before != null) {
      message += ' | before=${_formatDetails(before)}';
    }
    if (after != null) {
      message += ' | after=${_formatDetails(after)}';
    }

    developer.log(message, name: 'ActionLogger');
    print(message);
  }

  /// Log errors with context for debugging
  /// [component] - Where the error occurred
  /// [error] - The error that occurred
  /// [context] - Additional context about what was being attempted
  static void logError(String component, String error, [Map<String, dynamic>? context]) {
    final timestamp = DateTime.now().toIso8601String();
    final contextStr = context != null ? _formatDetails(context) : '';
    final message = '$_errorPrefix $timestamp | $component | ERROR: $error$contextStr';

    developer.log(message, name: 'ActionLogger', level: 1000); // Error level
    print(message);
  }

  /// Helper to format details map into readable string
  static String _formatDetails(Map<String, dynamic> details) {
    if (details.isEmpty) return '';

    final parts = details.entries.map((e) {
      final value = e.value;
      // Handle different value types for better readability
      String valueStr;
      if (value is String) {
        // Allow longer strings for error messages and stack traces
        final maxLength = (e.key == 'error' || e.key == 'stackTrace') ? 500 : 30;
        valueStr = '"${value.length > maxLength ? '${value.substring(0, maxLength)}...' : value}"';
      } else if (value is DateTime) {
        valueStr = value.toIso8601String();
      } else if (value is List) {
        valueStr = '[${value.length} items]';
      } else {
        valueStr = value.toString();
      }
      return '${e.key}=$valueStr';
    }).join(', ');

    return ' | $parts';
  }

  // Convenience methods for common logging scenarios

  /// Log database operations
  static void logDbOperation(String operation, String table, Map<String, dynamic> data) {
    logAction('Database', '$operation $table', data);
  }

  /// Log UI interactions
  static void logUserAction(String screen, String action, [Map<String, dynamic>? context]) {
    logAction('UI_$screen', action, context);
  }

  /// Log navigation events
  static void logNavigation(String from, String to, [Map<String, dynamic>? params]) {
    logAction('Navigation', '$from -> $to', params);
  }

  /// Log service method calls
  static void logServiceCall(String service, String method, [Map<String, dynamic>? params]) {
    logAction('Service_$service', method, params);
  }
}
