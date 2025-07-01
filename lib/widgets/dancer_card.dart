import 'package:flutter/material.dart';

import '../services/dancer_service.dart';
import '../theme/theme_extensions.dart';
import '../utils/action_logger.dart';
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main text content
                  RichText(
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
                        if (dancer.notes != null &&
                            dancer.notes!.isNotEmpty &&
                            (isPlanningMode || !dancer.hasDanced)) ...[
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

                          // Show first met indicator
                          if (dancer.isFirstMetHere) ...[
                            const TextSpan(text: ' '),
                            TextSpan(
                              text: '⭐',
                              style: TextStyle(
                                fontSize: 14,
                                color: context.danceTheme.danceAccent,
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),

                  // Score pill (separate from main text for better styling)
                  if (dancer.hasDanced && dancer.hasScore) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: context.danceTheme.rankingHigh.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.danceTheme.rankingHigh.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        dancer.scoreName!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: context.danceTheme.rankingHigh,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showPresenceIndicator && dancer.isPresent)
              Icon(Icons.check, color: context.danceTheme.present, size: 20),
          ],
        ),
        onTap: () {
          ActionLogger.logUserAction('DancerCard', 'dancer_tapped', {
            'dancerId': dancer.id,
            'dancerName': dancer.name,
            'eventId': eventId,
            'isPlanningMode': isPlanningMode,
            'dancerStatus': dancer.status,
            'isPresent': dancer.isPresent,
            'hasRanking': dancer.hasRanking,
            'hasDanced': dancer.hasDanced,
          });

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
