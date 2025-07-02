import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/event_service.dart';
import '../services/ranking_service.dart';
import '../theme/theme_extensions.dart';
import '../utils/action_logger.dart';
import '../utils/event_status_helper.dart';

class ImportRankingsDialog extends StatefulWidget {
  final int targetEventId;
  final String targetEventName;

  const ImportRankingsDialog({
    super.key,
    required this.targetEventId,
    required this.targetEventName,
  });

  @override
  State<ImportRankingsDialog> createState() => _ImportRankingsDialogState();
}

class _ImportRankingsDialogState extends State<ImportRankingsDialog> {
  List<Event> _availableEvents = [];
  Event? _selectedSourceEvent;
  bool _overwriteExisting = false;
  bool _isLoading = false;
  bool _isImporting = false;

  @override
  void initState() {
    super.initState();

    ActionLogger.logUserAction('ImportRankingsDialog', 'dialog_opened', {
      'targetEventId': widget.targetEventId,
      'targetEventName': widget.targetEventName,
    });

    _loadAvailableEvents();
  }

  Future<void> _loadAvailableEvents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final eventService = Provider.of<EventService>(context, listen: false);
      final rankingService =
          Provider.of<RankingService>(context, listen: false);

      // Get all events except the target event
      final allEventsStream = eventService.watchAllEvents();
      final allEvents = await allEventsStream.first;

      // Filter out target event and events with no rankings
      final filteredEvents = <Event>[];
      for (final event in allEvents) {
        if (event.id != widget.targetEventId) {
          final rankingsCount =
              await rankingService.getRankingsCountForEvent(event.id);
          if (rankingsCount > 0) {
            filteredEvents.add(event);
          }
        }
      }

      if (mounted) {
        setState(() {
          _availableEvents = filteredEvents;
          _isLoading = false;
        });

        ActionLogger.logAction('ImportRankingsDialog', 'events_loaded', {
          'targetEventId': widget.targetEventId,
          'availableEventsCount': filteredEvents.length,
          'totalEventsCount': allEvents.length,
        });
      }
    } catch (e) {
      ActionLogger.logError(
          'ImportRankingsDialog._loadAvailableEvents', e.toString(), {
        'targetEventId': widget.targetEventId,
      });

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading events: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _performImport() async {
    if (_selectedSourceEvent == null) return;

    ActionLogger.logUserAction('ImportRankingsDialog', 'import_started', {
      'sourceEventId': _selectedSourceEvent!.id,
      'sourceEventName': _selectedSourceEvent!.name,
      'targetEventId': widget.targetEventId,
      'targetEventName': widget.targetEventName,
      'overwriteExisting': _overwriteExisting,
    });

    setState(() {
      _isImporting = true;
    });

    try {
      final rankingService =
          Provider.of<RankingService>(context, listen: false);

      final result = await rankingService.importRankingsFromEvent(
        sourceEventId: _selectedSourceEvent!.id,
        targetEventId: widget.targetEventId,
        overwriteExisting: _overwriteExisting,
      );

      if (mounted) {
        ActionLogger.logUserAction('ImportRankingsDialog', 'import_completed', {
          'sourceEventId': _selectedSourceEvent!.id,
          'targetEventId': widget.targetEventId,
          'imported': result.imported,
          'skipped': result.skipped,
          'overwritten': result.overwritten,
          'sourceRankingsCount': result.sourceRankingsCount,
        });

        Navigator.pop(context, true); // Return true to indicate success

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rankings imported from "${_selectedSourceEvent!.name}"'),
                Text(
                  result.summaryMessage,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            backgroundColor: result.hasAnyChanges
                ? context.danceTheme.success
                : context.danceTheme.warning,
          ),
        );
      }
    } catch (e) {
      ActionLogger.logError(
          'ImportRankingsDialog._performImport', e.toString(), {
        'sourceEventId': _selectedSourceEvent!.id,
        'targetEventId': widget.targetEventId,
      });

      if (mounted) {
        setState(() {
          _isImporting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing rankings: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Import Rankings to "${widget.targetEventName}"'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select an event to import rankings from:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_availableEvents.isEmpty)
              const Center(
                child: Column(
                  children: [
                    Icon(Icons.event_busy, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'No events with rankings found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: Column(
                    children: _availableEvents.map((event) {
                      final formattedDate =
                          DateFormat('MMM d, y').format(event.date);
                      final isOld = EventStatusHelper.isOldEvent(event.date);
                      final isCurrent =
                          EventStatusHelper.isCurrentEvent(event.date);

                      // Determine date color based on event status
                      Color dateColor;
                      if (isOld) {
                        // Old events (2+ days ago) - gray color
                        dateColor = Colors.grey;
                      } else if (isCurrent) {
                        // Current events (within 6-day window) - white color
                        dateColor = Colors.white;
                      } else {
                        // Future events - primary color
                        dateColor = Theme.of(context).colorScheme.primary;
                      }

                      return RadioListTile<Event>(
                        title: Text(event.name),
                        subtitle: Text(
                          formattedDate,
                          style: TextStyle(
                            color: dateColor,
                          ),
                        ),
                        value: event,
                        groupValue: _selectedSourceEvent,
                        onChanged: (Event? value) {
                          ActionLogger.logUserAction(
                              'ImportRankingsDialog', 'source_event_selected', {
                            'sourceEventId': value?.id,
                            'sourceEventName': value?.name,
                            'targetEventId': widget.targetEventId,
                          });

                          setState(() {
                            _selectedSourceEvent = value;
                          });
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                ),
              ),
            if (_selectedSourceEvent != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              CheckboxListTile(
                title: const Text('Overwrite existing rankings'),
                subtitle: const Text(
                  'If a dancer already has a ranking in the target event, overwrite it',
                ),
                value: _overwriteExisting,
                onChanged: (bool? value) {
                  ActionLogger.logUserAction(
                      'ImportRankingsDialog', 'overwrite_option_changed', {
                    'newValue': value,
                    'targetEventId': widget.targetEventId,
                  });

                  setState(() {
                    _overwriteExisting = value ?? false;
                  });
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isImporting
              ? null
              : () {
                  ActionLogger.logUserAction(
                      'ImportRankingsDialog', 'dialog_cancelled', {
                    'targetEventId': widget.targetEventId,
                  });
                  Navigator.pop(context, false);
                },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: (_selectedSourceEvent == null || _isImporting)
              ? null
              : _performImport,
          child: _isImporting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Import'),
        ),
      ],
    );
  }
}
