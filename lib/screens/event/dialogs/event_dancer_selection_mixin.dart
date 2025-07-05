import 'package:flutter/material.dart';

import '../../../models/dancer_with_tags.dart';
import '../../../services/dancer/dancer_filter_service.dart';
import '../../../theme/theme_extensions.dart';

/// Mixin providing common functionality for event dancer selection screens
mixin EventDancerSelectionMixin<T extends StatefulWidget> on State<T> {
  int _refreshKey = 0;

  /// Get the event ID - to be implemented by the mixing class
  int get eventId;

  /// Get available dancers for the event with tag and search filtering
  Future<List<DancerWithTags>> getAvailableDancers(List<int> tagIds, String searchQuery) async {
    final filterService = DancerFilterService.of(context);

    // Get dancers based on tag filtering
    List<DancerWithTags> dancers;
    if (tagIds.isNotEmpty) {
      // Use tag filtering when tags are selected
      dancers = await filterService.getAvailableDancersWithTagsForEvent(
        eventId,
        tagIds: tagIds.toSet(),
      );
    } else {
      // Get all available dancers when no tags are selected
      dancers = await filterService.getAvailableDancersWithTagsForEvent(
        eventId,
      );
    }

    // Apply search filtering if search query is provided
    if (searchQuery.isNotEmpty) {
      dancers = filterService.filterDancersByText(dancers, searchQuery);
    }

    return dancers;
  }

  /// Show error message using SnackBar
  void showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  /// Show success message using SnackBar
  void showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: context.danceTheme.success,
        ),
      );
    }
  }

  /// Trigger a refresh by updating the refresh key
  void triggerRefresh() {
    setState(() {
      _refreshKey++;
    });
  }

  /// Get the current refresh key
  int get refreshKey => _refreshKey;
}
