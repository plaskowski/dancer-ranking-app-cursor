import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/dancer_with_tags.dart';
import '../../../services/attendance_service.dart';
import '../../../services/dancer/dancer_filter_service.dart';
import '../../../widgets/dancer_filter_list_widget.dart';
import 'event_dancer_selection_mixin.dart';

class AddExistingDancerScreen extends StatefulWidget {
  final int eventId;
  final String eventName;

  const AddExistingDancerScreen({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  @override
  State<AddExistingDancerScreen> createState() => _AddExistingDancerScreenState();
}

class _AddExistingDancerScreenState extends State<AddExistingDancerScreen> with EventDancerSelectionMixin {
  @override
  int get eventId => widget.eventId;

  Future<void> _markDancerPresent(int dancerId, String dancerName) async {
    try {
      final attendanceService = Provider.of<AttendanceService>(context, listen: false);

      await attendanceService.markPresent(widget.eventId, dancerId);

      if (mounted) {
        // Show a brief success message without closing the screen
        showSuccessMessage('$dancerName marked as present');

        // Trigger a refresh by updating the key
        triggerRefresh();
      }
    } catch (e) {
      showErrorMessage('Error marking dancer as present: $e');
    }
  }

  Future<List<DancerWithTags>> _getAvailableDancers(List<int> tagIds, String searchQuery) async {
    final filterService = DancerFilterService.of(context);

    // Get dancers based on tag filtering
    List<DancerWithTags> dancers;
    if (tagIds.isNotEmpty) {
      // Use tag filtering when tags are selected
      dancers = await filterService.getAvailableDancersWithTagsForEvent(
        widget.eventId,
        tagIds: tagIds.toSet(),
      );
    } else {
      // Get all available dancers when no tags are selected
      dancers = await filterService.getAvailableDancersWithTagsForEvent(
        widget.eventId,
      );
    }

    // Apply search filtering if search query is provided
    if (searchQuery.isNotEmpty) {
      dancers = filterService.filterDancersByText(dancers, searchQuery);
    }

    return dancers;
  }

  Widget _buildDancerTile(DancerWithTags dancer) {
    return Card(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: ListTile(
        title: Text(
          dancer.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: dancer.notes != null && dancer.notes!.isNotEmpty ? Text(dancer.notes!) : null,
        trailing: ElevatedButton(
          onPressed: () => _markDancerPresent(dancer.id, dancer.name),
          child: const Text('Mark Present'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DancerFilterListWidget(
      title: 'Add to ${widget.eventName}',
      infoMessage: 'Showing unranked and absent dancers only. Present dancers managed in Present tab.',
      getDancers: getAvailableDancers,
      buildDancerTile: _buildDancerTile,
      refreshKey: refreshKey,
    );
  }
}
