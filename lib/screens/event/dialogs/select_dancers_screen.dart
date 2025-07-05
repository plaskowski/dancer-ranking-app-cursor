import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/ranking_service.dart';
import 'base_dancer_selection_screen.dart';
import 'event_dancer_selection_mixin.dart';

class SelectDancersScreen extends StatefulWidget {
  final int eventId;
  final String eventName;

  const SelectDancersScreen({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  @override
  State<SelectDancersScreen> createState() => _SelectDancersScreenState();
}

class _SelectDancersScreenState extends State<SelectDancersScreen> with EventDancerSelectionMixin {
  @override
  int get eventId => widget.eventId;

  Future<void> _onDancerSelected(int dancerId, String dancerName) async {
    final rankingService = Provider.of<RankingService>(context, listen: false);
    await rankingService.setRankNeutral(widget.eventId, dancerId);
    showSuccessMessage('$dancerName added to event');
    triggerRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDancerSelectionScreen(
      eventId: widget.eventId,
      eventName: widget.eventName,
      onDancerSelected: _onDancerSelected,
      actionButtonText: 'Add to Event',
      infoMessage: 'Showing unranked and absent dancers only. Select multiple dancers to add to the event.',
      screenTitle: 'Select Dancers',
      shouldCloseAfterSelection: true,
      returnValueOnClose: true,
    );
  }
}
