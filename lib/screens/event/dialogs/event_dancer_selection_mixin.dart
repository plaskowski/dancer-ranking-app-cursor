import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/database.dart';
import '../../../models/dancer_with_tags.dart';
import '../../../services/dancer/dancer_activity_service.dart';
import '../../../services/dancer/dancer_filter_service.dart';
import '../../../theme/theme_extensions.dart';

/// Mixin providing common functionality for event dancer selection screens
mixin EventDancerSelectionMixin<T extends StatefulWidget> on State<T> {
  int _refreshKey = 0;

  /// Get the event ID - to be implemented by the mixing class
  int get eventId;

  /// Get available dancers for the event with tag and search filtering
  Future<List<DancerWithTags>> getAvailableDancers(List<int> tagIds, String searchQuery, [String? activityFilter]) async {
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

    // Apply activity filtering if provided
    if (activityFilter != null && activityFilter.isNotEmpty && activityFilter != 'All') {
      dancers = await _applyActivityFiltering(dancers, activityFilter);
    }

    // Apply search filtering if search query is provided
    if (searchQuery.isNotEmpty) {
      dancers = filterService.filterDancersByText(dancers, searchQuery);
    }

    return dancers;
  }

  /// Apply activity filtering to dancers
  Future<List<DancerWithTags>> _applyActivityFiltering(List<DancerWithTags> dancers, String activityFilter) async {
    final activityLevel = _mapActivityStringToLevel(activityFilter);
    
    if (activityLevel == ActivityLevel.all) {
      return dancers;
    }

    final filteredDancers = <DancerWithTags>[];
    
    for (final dancer in dancers) {
      final recentEventCount = await _getRecentEventCount(dancer.id, activityLevel);
      final meetsActivityLevel = _checkActivityLevel(recentEventCount, activityLevel);
      
      if (meetsActivityLevel) {
        filteredDancers.add(dancer);
      }
    }

    return filteredDancers;
  }

  ActivityLevel _mapActivityStringToLevel(String activityString) {
    switch (activityString.toLowerCase()) {
      case 'regular':
        return ActivityLevel.regular;
      case 'occasional':
        return ActivityLevel.occasional;
      default:
        return ActivityLevel.all;
    }
  }

  bool _checkActivityLevel(int recentEventCount, ActivityLevel level) {
    switch (level) {
      case ActivityLevel.regular:
        return recentEventCount >= 3; // 3+ events in last 2 months
      case ActivityLevel.occasional:
        return recentEventCount >= 1; // 1+ event in last 3 months
      case ActivityLevel.all:
        return true;
    }
  }

  Future<int> _getRecentEventCount(int dancerId, ActivityLevel level) async {
    final months = level == ActivityLevel.regular ? 2 : 3;
    
    // Get the activity service to calculate recent event count
    final database = Provider.of<AppDatabase>(context, listen: false);
    final activityService = DancerActivityService(database);
    
    // Calculate recent event count using the activity service
    return await activityService.getRecentEventCount(dancerId, months);
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
