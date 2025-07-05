import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/attendance_service.dart';
import 'base_dancer_selection_screen.dart';
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

  Future<void> _onDancerSelected(int dancerId, String dancerName) async {
    final attendanceService = Provider.of<AttendanceService>(context, listen: false);
    await attendanceService.markPresent(widget.eventId, dancerId);
    showSuccessMessage('$dancerName marked as present');
    triggerRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDancerSelectionScreen(
      eventId: widget.eventId,
      eventName: widget.eventName,
      onDancerSelected: _onDancerSelected,
      actionButtonText: 'Mark Present',
      infoMessage: 'Showing unranked and absent dancers only. Present dancers managed in Present tab.',
      screenTitle: 'Add to ${widget.eventName}',
    );
  }
}
