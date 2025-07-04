import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/dancer_with_tags.dart';
import '../../services/dancer/dancer_tag_service.dart';
import '../../services/dancer_service.dart';

/// Service for filtering dancers with common logic used across multiple dialogs
class DancerFilterService {
  final DancerService _dancerService;
  final DancerTagService _dancerTagService;

  DancerFilterService(this._dancerService, this._dancerTagService);

  /// Filter dancers by tag ID
  /// Returns filtered dancers that have the specified tag
  Future<List<DancerWithTags>> filterDancersByTag(int tagId) async {
    try {
      final dancers = await _dancerService.getDancersWithTags();

      return dancers.where((dancer) {
        return dancer.tags.any((tag) => tag.id == tagId);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Filter dancers by multiple tag IDs
  /// Returns filtered dancers that have any of the specified tags
  Future<List<DancerWithTags>> filterDancersByTags(Set<int> tagIds) async {
    if (tagIds.isEmpty) {
      return await _dancerService.getDancersWithTags();
    }

    try {
      final dancers = await _dancerService.getDancersWithTags();

      return dancers.where((dancer) {
        return dancer.tags.any((tag) => tagIds.contains(tag.id));
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Filter dancers by text search (name and notes)
  /// Returns dancers whose name or notes contain the search query
  List<DancerWithTags> filterDancersByText(
    List<DancerWithTags> dancers,
    String searchQuery,
  ) {
    if (searchQuery.isEmpty) {
      return dancers;
    }

    final query = searchQuery.toLowerCase();
    return dancers.where((dancer) {
      final name = dancer.name.toLowerCase();
      final notes = (dancer.notes ?? '').toLowerCase();
      return name.contains(query) || notes.contains(query);
    }).toList();
  }

  /// Filter dancers by text search with word-start matching
  /// Returns dancers whose name or notes start with the search query words
  List<DancerWithTags> filterDancersByTextWords(
    List<DancerWithTags> dancers,
    String searchQuery,
  ) {
    if (searchQuery.isEmpty) {
      return dancers;
    }

    final query = searchQuery.toLowerCase();
    return dancers.where((dancer) {
      // Search in dancer name - match start of words only
      final nameWords = dancer.name.toLowerCase().split(' ');
      if (nameWords.any((word) => word.startsWith(query))) {
        return true;
      }

      // Search in notes - match start of words only
      if (dancer.notes != null) {
        final noteWords = dancer.notes!.toLowerCase().split(' ');
        if (noteWords.any((word) => word.startsWith(query))) {
          return true;
        }
      }

      return false;
    }).toList();
  }

  /// Get unranked dancers for an event, optionally filtered by tag
  Future<List<DancerWithEventInfo>> getUnrankedDancersForEvent(
    int eventId, {
    int? tagId,
  }) async {
    if (tagId != null) {
      return _dancerTagService.getUnrankedDancersForEventByTag(eventId, tagId);
    } else {
      return _dancerService.getUnrankedDancersForEvent(eventId);
    }
  }

  /// Get available dancers for an event, optionally filtered by tags
  Stream<List<DancerWithEventInfo>> getAvailableDancersForEvent(
    int eventId, {
    Set<int>? tagIds,
  }) {
    if (tagIds != null && tagIds.isNotEmpty) {
      // Use tag-filtered stream (for now, just use first tag)
      return _dancerTagService.watchAvailableDancersForEventByTag(
        eventId,
        tagIds.first,
      );
    } else {
      // Use existing stream and filter to show only unranked and absent dancers
      return _dancerService.watchDancersForEvent(eventId).map((allDancers) {
        return allDancers.where((dancer) {
          // Show dancers who are NOT ranked (no rankName) AND NOT present (no attendanceMarkedAt)
          final isUnranked = dancer.rankName == null;
          final isAbsent = dancer.attendanceMarkedAt == null;
          return isUnranked && isAbsent;
        }).toList();
      });
    }
  }

  /// Filter dancers by text search (for DancerWithEventInfo)
  List<DancerWithEventInfo> filterDancersByTextEvent(
    List<DancerWithEventInfo> dancers,
    String searchQuery,
  ) {
    if (searchQuery.isEmpty) {
      return dancers;
    }

    final query = searchQuery.toLowerCase();
    return dancers.where((dancer) {
      final name = dancer.name.toLowerCase();
      final notes = (dancer.notes ?? '').toLowerCase();
      return name.contains(query) || notes.contains(query);
    }).toList();
  }

  /// Create a DancerFilterService instance using Provider
  static DancerFilterService of(BuildContext context) {
    final dancerService = Provider.of<DancerService>(context, listen: false);
    final dancerTagService =
        Provider.of<DancerTagService>(context, listen: false);
    return DancerFilterService(dancerService, dancerTagService);
  }
}
