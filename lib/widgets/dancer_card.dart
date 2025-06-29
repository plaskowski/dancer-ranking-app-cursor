import 'package:flutter/material.dart';

import '../services/dancer_service.dart';
import 'dancer_actions_dialog.dart';

// Dancer Card widget used in both tabs
class DancerCard extends StatelessWidget {
  final DancerWithEventInfo dancer;
  final int eventId;
  final bool showPresenceIndicator;
  final bool isPlanningMode;

  const DancerCard({
    super.key,
    required this.dancer,
    required this.eventId,
    required this.showPresenceIndicator,
    required this.isPlanningMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                dancer.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            if (showPresenceIndicator && dancer.isPresent)
              const Icon(Icons.check, color: Colors.green, size: 20),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dancer.rankingReason != null)
              Text(
                '"${dancer.rankingReason}"',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            if (dancer.hasDanced)
              const Row(
                children: [
                  Icon(Icons.music_note, size: 16, color: Colors.purple),
                  SizedBox(width: 4),
                  Text('Danced!', style: TextStyle(color: Colors.purple)),
                ],
              ),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => DancerActionsDialog(
              dancer: dancer,
              eventId: eventId,
              isPlanningMode: isPlanningMode,
            ),
          );
        },
      ),
    );
  }
}
