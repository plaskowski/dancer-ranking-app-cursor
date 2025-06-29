import 'package:flutter/material.dart';

import '../services/dancer_service.dart';
import '../theme/theme_extensions.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    // Dancer name
                    TextSpan(
                      text: dancer.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),

                    // Show dancer notes if they exist (hide for danced dancers in Present tab)
                    if (dancer.notes != null && dancer.notes!.isNotEmpty && (isPlanningMode || !dancer.hasDanced)) ...[
                      const TextSpan(text: ' • '),
                      TextSpan(
                        text: dancer.notes!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],

                    // Show ranking reason if it exists (hide for danced dancers in Present tab)
                    if (dancer.rankingReason != null &&
                        dancer.rankingReason!.isNotEmpty &&
                        (isPlanningMode || !dancer.hasDanced)) ...[
                      const TextSpan(text: ' • '),
                      TextSpan(
                        text: '"${dancer.rankingReason}"',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],

                    // Show "Left" indicator if they left before dancing
                    if (dancer.hasLeft) ...[
                      const TextSpan(text: ' • '),
                      TextSpan(
                        text: 'Left',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: context.danceTheme.warning,
                        ),
                      ),
                    ],

                    // Show "Danced!" indicator with impression if they have danced
                    if (dancer.hasDanced) ...[
                      const TextSpan(text: ' • '),
                      TextSpan(
                        text: 'Danced!',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: context.danceTheme.danceAccent,
                        ),
                      ),
                      if (dancer.impression != null && dancer.impression!.isNotEmpty) ...[
                        TextSpan(
                          text: ' - ${dancer.impression!}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                            color: context.danceTheme.danceAccent,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            if (showPresenceIndicator && dancer.isPresent)
              Icon(Icons.check, color: context.danceTheme.present, size: 20),
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
